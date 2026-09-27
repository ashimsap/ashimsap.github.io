import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';

/// Wraps children with the signature Cyberpunk dark background, animated grid floor,
/// interactive mouse spotlight, scanlines, and subtle stardust noise texture.
class CyberBackground extends StatefulWidget {
  final Widget child;
  final Color accentColor;

  const CyberBackground({
    super.key,
    required this.child,
    this.accentColor = AppColors.cyan,
  });

  @override
  State<CyberBackground> createState() => _CyberBackgroundState();
}

class _CyberBackgroundState extends State<CyberBackground> {
  Offset _mousePos = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() {
          _mousePos = event.position;
        });
      },
      child: Stack(
        children: [
          // 1. GLOBAL SPOTLIGHT BACKGROUND
          Positioned.fill(
            child: CustomPaint(
              painter: _SpotlightPainter(
                mousePos: _mousePos,
                color: widget.accentColor,
              ),
            ),
          ),

          // 2. ANIMATED CYBER GRID FLOOR
          Positioned.fill(
            child: const _CyberGridBackground()
                .animate(onPlay: (c) => c.repeat())
                .shimmer(
                  duration: 5.seconds,
                  color: widget.accentColor.withValues(alpha: 0.1),
                ),
          ),

          // 3. SCANLINE OVERLAY
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      widget.accentColor.withValues(alpha: 0.03),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              )
                  .animate(onPlay: (c) => c.repeat())
                  .moveY(
                    begin: -100,
                    end: 100,
                    duration: 8.seconds,
                    curve: Curves.linear,
                  ),
            ),
          ),

          // 4. NOISE TEXTURE
          Positioned.fill(
            child: Opacity(
              opacity: 0.04,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://www.transparenttextures.com/patterns/stardust.png",
                    ),
                    repeat: ImageRepeat.repeat,
                  ),
                ),
              ),
            ),
          ),

          // 5. MAIN CONTENT
          Positioned.fill(child: widget.child),
        ],
      ),
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  final Offset mousePos;
  final Color color;

  _SpotlightPainter({required this.mousePos, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    paint.shader = RadialGradient(
      colors: [
        color.withValues(alpha: 0.12),
        Colors.transparent,
      ],
      stops: const [0.0, 0.6],
    ).createShader(Rect.fromCircle(center: mousePos, radius: 600));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    final secondaryPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.bottomRight,
        radius: 1.5,
        colors: [
          const Color(0xFF7000FF).withValues(alpha: 0.05),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), secondaryPaint);
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter oldDelegate) =>
      oldDelegate.mousePos != mousePos || oldDelegate.color != color;
}

class _CyberGridBackground extends StatelessWidget {
  const _CyberGridBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PerspectiveGridPainter(),
    );
  }
}

class _PerspectiveGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00F0FF).withValues(alpha: 0.04)
      ..strokeWidth = 1;

    final horizonY = size.height * 0.6;
    final centerX = size.width / 2;

    for (double i = -size.width; i < size.width * 2; i += 40) {
      canvas.drawLine(
        Offset(centerX + (i - centerX) * 0.1, horizonY),
        Offset(i, size.height),
        paint,
      );
    }

    for (double i = horizonY; i < size.height; i += (i - horizonY) * 0.1 + 5) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
