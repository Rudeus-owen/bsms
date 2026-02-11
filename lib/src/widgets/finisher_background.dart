import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bsms/exports.dart';

/// A native Flutter recreation of the FinisherHeader animated background.
/// Draws floating gradient circles that bounce around the screen.
class FinisherBackground extends StatefulWidget {
  final Color backgroundColor;
  final List<Color> particleColors;
  final int particleCount;
  final double minSize;
  final double maxSize;
  final double speedFactor;

  const FinisherBackground({
    super.key,
    this.backgroundColor = AppColors.primary,
    this.particleColors = AppColors.particleColors,
    this.particleCount = 6,
    this.minSize = 1100,
    this.maxSize = 1300,
    this.speedFactor = 0.3,
  });

  @override
  State<FinisherBackground> createState() => _FinisherBackgroundState();
}

class _FinisherBackgroundState extends State<FinisherBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _particles = [];
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  void _initParticles(Size size) {
    if (size.isEmpty) return;
    _particles = List.generate(widget.particleCount, (index) {
      final color = widget.particleColors[index % widget.particleColors.length];
      final quadrant = index % 4;
      final halfW = size.width / 2;
      final halfH = size.height / 2;

      double x, y;
      switch (quadrant) {
        case 0:
          x = _random.nextDouble() * halfW;
          y = _random.nextDouble() * halfH;
          break;
        case 1:
          x = _random.nextDouble() * halfW + halfW;
          y = _random.nextDouble() * halfH + halfH;
          break;
        case 2:
          x = _random.nextDouble() * halfW;
          y = _random.nextDouble() * halfH + halfH;
          break;
        default:
          x = _random.nextDouble() * halfW + halfW;
          y = _random.nextDouble() * halfH;
      }

      final particleSize =
          _random.nextDouble() * (widget.maxSize - widget.minSize) + widget.minSize;
      final vx = (_random.nextDouble() * widget.speedFactor + 0.1) *
          (_random.nextBool() ? 1 : -1);
      final vy = (_random.nextDouble() * widget.speedFactor + 0.1) *
          (_random.nextBool() ? 1 : -1);

      return _Particle(
        x: x,
        y: y,
        size: particleSize,
        vx: vx,
        vy: vy,
        color: color,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        if (_particles.isEmpty && !size.isEmpty) {
          _initParticles(size);
        }
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Update particle positions
            for (var p in _particles) {
              p.x += p.vx;
              p.y += p.vy;
              if (p.x < 0) {
                p.vx = p.vx.abs();
                p.x = 0;
              } else if (p.x > size.width) {
                p.vx = -p.vx.abs();
                p.x = size.width;
              }
              if (p.y < 0) {
                p.vy = p.vy.abs();
                p.y = 0;
              } else if (p.y > size.height) {
                p.vy = -p.vy.abs();
                p.y = size.height;
              }
            }
            return CustomPaint(
              size: size,
              painter: _FinisherPainter(
                particles: _particles,
                backgroundColor: widget.backgroundColor,
              ),
            );
          },
        );
      },
    );
  }
}

class _Particle {
  double x;
  double y;
  double size;
  double vx;
  double vy;
  Color color;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.vx,
    required this.vy,
    required this.color,
  });
}

class _FinisherPainter extends CustomPainter {
  final List<_Particle> particles;
  final Color backgroundColor;

  _FinisherPainter({
    required this.particles,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = backgroundColor,
    );

    // Use saveLayer so overlay blending works against the background
    canvas.saveLayer(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint(),
    );

    // Re-draw background inside the layer
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = backgroundColor,
    );

    // Draw each particle with radial gradient and overlay blending
    for (var p in particles) {
      final radius = p.size / 2;
      final rect = Rect.fromCircle(center: Offset(p.x, p.y), radius: radius);

      final gradient = RadialGradient(
        colors: [
          p.color.withAlpha(255),
          p.color.withAlpha(25),
        ],
      );

      final paint = Paint()
        ..shader = gradient.createShader(rect)
        ..blendMode = BlendMode.overlay;

      canvas.drawCircle(Offset(p.x, p.y), radius, paint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _FinisherPainter oldDelegate) => true;
}
