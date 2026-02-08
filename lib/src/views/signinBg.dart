import 'dart:math';
import 'package:flutter/material.dart';

class FinisherBackground extends StatefulWidget {
  const FinisherBackground({super.key});

  @override
  State<FinisherBackground> createState() => _FinisherBackgroundState();
}

class _FinisherBackgroundState extends State<FinisherBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  final int particleCount = 6;
  final Random random = Random();

  late List<_Particle> particles;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 20))
          ..repeat();

    particles = List.generate(particleCount, (_) {
      return _Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        radius: 1100 + random.nextDouble() * 200,
        dx: 0.0002 + random.nextDouble() * 0.0004,
        dy: 0.0002 + random.nextDouble() * 0.0004,
        color: [
          const Color(0xFF9FB8FC),
          const Color(0xFF5C6FA6),
          const Color(0xFF0C215D),
        ][random.nextInt(3)],
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        for (var p in particles) {
          p.x += p.dx;
          p.y += p.dy;

          if (p.x > 1.2) p.x = -0.2;
          if (p.y > 1.2) p.y = -0.2;
        }

        return CustomPaint(
          painter: _FinisherPainter(particles),
          child: Container(),
        );
      },
    );
  }
}

class _Particle {
  double x;
  double y;
  double radius;
  double dx;
  double dy;
  Color color;

  _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.dx,
    required this.dy,
    required this.color,
  });
}

class _FinisherPainter extends CustomPainter {
  final List<_Particle> particles;

  _FinisherPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    final bgPaint = Paint()..color = const Color(0xFF1E3A8A);
    canvas.drawRect(Offset.zero & size, bgPaint);

    for (var p in particles) {
      final gradient = RadialGradient(
        colors: [
          p.color.withOpacity(0.6),
          p.color.withOpacity(0.05),
        ],
      );

      final rect = Rect.fromCircle(
        center: Offset(p.x * size.width, p.y * size.height),
        radius: p.radius,
      );

      final paint = Paint()
        ..shader = gradient.createShader(rect)
        ..blendMode = BlendMode.overlay;

      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        p.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
