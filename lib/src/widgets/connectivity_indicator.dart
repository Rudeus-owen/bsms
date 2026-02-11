import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityIndicator extends StatefulWidget {
  const ConnectivityIndicator({super.key});

  @override
  State<ConnectivityIndicator> createState() => _ConnectivityIndicatorState();
}

class _ConnectivityIndicatorState extends State<ConnectivityIndicator>
    with SingleTickerProviderStateMixin {
  late final StreamSubscription<List<ConnectivityResult>> _subscription;
  late final AnimationController _pulseController;
  Timer? _periodicCheck;

  bool _isConnected = true;
  String _label = 'Online';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Immediately read network type
    Connectivity().checkConnectivity().then(_onNetworkChanged);

    // Listen for changes (fires instantly on toggle)
    _subscription = Connectivity().onConnectivityChanged.listen(_onNetworkChanged);

    // Background reachability every 15s
    _periodicCheck = Timer.periodic(const Duration(seconds: 15), (_) => _pingCheck());
  }

  void _onNetworkChanged(List<ConnectivityResult> results) {
    final r = results.isNotEmpty ? results.first : ConnectivityResult.none;

    if (r == ConnectivityResult.none) {
      _setStatus(false, 'Offline');
    } else {
      // Show type immediately, then verify in background
      final type = switch (r) {
        ConnectivityResult.wifi => 'Wi-Fi',
        ConnectivityResult.mobile => 'Mobile',
        ConnectivityResult.ethernet => 'Ethernet',
        _ => 'Online',
      };
      _setStatus(true, type);
      _pingCheck(); // quick background verify
    }
  }

  Future<void> _pingCheck() async {
    try {
      final socket = await Socket.connect('8.8.8.8', 53,
          timeout: const Duration(seconds: 2));
      socket.destroy();
      if (!mounted) return;
      if (!_isConnected) {
        // Was showing offline but now reachable
        _setStatus(true, 'Online');
      }
    } catch (_) {
      if (!mounted) return;
      _setStatus(false, 'No Internet');
    }
  }

  void _setStatus(bool connected, String label) {
    if (!mounted) return;
    final changed = _isConnected != connected;
    setState(() {
      _isConnected = connected;
      _label = label;
      if (connected) {
        _pulseController.stop();
        _pulseController.value = 0;
      } else {
        _pulseController.repeat(reverse: true);
      }
    });

    if (changed) _showSnackBar(connected);
  }

  void _showSnackBar(bool online) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(online ? Icons.wifi : Icons.wifi_off, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Text(online ? 'Back online' : 'You are offline',
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        backgroundColor: online ? const Color(0xFF22c55e) : Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
        duration: Duration(seconds: online ? 2 : 4),
      ),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    _periodicCheck?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = _isConnected ? const Color(0xFF22c55e) : Colors.redAccent;

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, _) {
        final opacity = _isConnected ? 1.0 : 0.5 + (_pulseController.value * 0.5);
        return GestureDetector(
          onTap: _pingCheck,
          child: Opacity(
            opacity: opacity,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withAlpha(80)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_isConnected ? Icons.wifi : Icons.wifi_off, size: 14, color: color),
                  const SizedBox(width: 5),
                  Text(_label,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
