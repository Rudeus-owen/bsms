import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

mixin ConnectivityRefreshMixin<T extends StatefulWidget> on State<T> {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _wasOffline = false;

  @override
  void initState() {
    super.initState();
    _initConnectivityListener();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  void _initConnectivityListener() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) {
      final isOffline = results.contains(ConnectivityResult.none);

      if (_wasOffline && !isOffline) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) onConnectivityRegained();
        });
      }

      _wasOffline = isOffline;
    });

    Connectivity().checkConnectivity().then((results) {
      _wasOffline = results.contains(ConnectivityResult.none);
    });
  }

  void onConnectivityRegained();
}
