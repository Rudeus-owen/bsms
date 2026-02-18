import 'package:flutter/material.dart';
import 'package:bsms/exports.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late AnimationController _textController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Shimmer effect controller (repeats)
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Entrance animation controller
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    _textController.forward();
    _checkAuth();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final token = await ApiService.storage.read(key: 'access_token');

    if (mounted) {
      if (token != null) {
        Navigator.of(context).pushReplacementNamed(OverviewScreen.routeName);
      } else {
        Navigator.of(context).pushReplacementNamed(SignInPage.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Dynamic Background
          const Positioned.fill(child: FinisherBackground()),

          // Content
          Center(
            child: AnimatedBuilder(
              animation: _textController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Shimmering Main Title
                        AnimatedBuilder(
                          animation: _shimmerController,
                          builder: (context, child) {
                            return ShaderMask(
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Colors.white,
                                    Colors.white.withOpacity(0.5),
                                    Colors.white,
                                    Colors.white,
                                  ],
                                  stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
                                  begin: Alignment(
                                    -1.0 + (_shimmerController.value * 3),
                                    0,
                                  ),
                                  end: Alignment(
                                    1.0 + (_shimmerController.value * 3),
                                    0,
                                  ),
                                  tileMode: TileMode.clamp,
                                ).createShader(bounds);
                              },
                              child: const Text(
                                "BSMS",
                                style: TextStyle(
                                  fontSize: 72,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 4.0,
                                  fontFamily: 'Roboto', // Default fallback
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        // Subtitle
                        Text(
                          "Beauty Salon Management",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.9),
                            letterSpacing: 6.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
