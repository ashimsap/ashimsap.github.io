import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';

/// Wraps children with interactive background spotlight and section-relevant canvas painters:
/// - HOME: Cyberpunk Command Center & Constellation Nodes
/// - BUILD (Developer): Code Matrix, Circuit Traces & Syntax Brackets
/// - GROW (Marketer): Growth Curve Sine Waves & Analytics Dot Matrix
/// - OPERATE (Deployer): Server Node Mesh Network, Bus Lines & Terminal Glyphs
/// - LAB (Experiment): Atomic Constellation Grid & Quantum Particle Orbits
class CyberBackground extends StatefulWidget {
  final Widget child;
  final Color accentColor;
  final bool isLight;
  final int sectionIndex; // 0 = HOME, 1 = BUILD, 2 = GROW, 3 = OPERATE, 4 = LAB

  const CyberBackground({
    super.key,
    required this.child,
    this.accentColor = AppColors.cyan,
    this.isLight = false,
    this.sectionIndex = 0,
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
          // 0. BASE CANVAS COLOR WITH SILKY-SMOOTH COLOR INTERPOLATION TRANSITION
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOutCubic,
              color: widget.isLight
                  ? const Color(0xFFF8FAFC)
                  : AppColors.background,
            ),
          ),

          // 1. GLOBAL SPOTLIGHT BACKGROUND (Tracks Mouse Position)
          Positioned.fill(
            child: CustomPaint(
              painter: _SpotlightPainter(
                mousePos: _mousePos,
                color: widget.accentColor,
                isLight: widget.isLight,
              ),
            ),
          ),

          // 2. SECTION-RELEVANT CANVAS PAINTER
          Positioned.fill(
            child: _SectionCanvasBackground(
              sectionIndex: widget.sectionIndex,
              color: widget.accentColor,
              isLight: widget.isLight,
            )
                .animate(onPlay: (c) => c.repeat())
                .shimmer(
                  duration: 6.seconds,
                  color: widget.accentColor.withValues(
                      alpha: widget.isLight ? 0.15 : 0.08),
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
                      widget.accentColor.withValues(
                          alpha: widget.isLight ? 0.02 : 0.03),
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

          // 4. NOISE TEXTURE OVERLAY
          Positioned.fill(
            child: Opacity(
              opacity: widget.isLight ? 0.02 : 0.04,
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
  final bool isLight;

  _SpotlightPainter({
    required this.mousePos,
    required this.color,
    required this.isLight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    paint.shader = RadialGradient(
      colors: [
        color.withValues(alpha: isLight ? 0.14 : 0.12),
        Colors.transparent,
      ],
      stops: const [0.0, 0.65],
    ).createShader(Rect.fromCircle(center: mousePos, radius: 650));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    final secondaryPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.bottomRight,
        radius: 1.5,
        colors: [
          (isLight ? const Color(0xFFA855F7) : const Color(0xFF7000FF))
              .withValues(alpha: isLight ? 0.08 : 0.05),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), secondaryPaint);
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter oldDelegate) =>
      oldDelegate.mousePos != mousePos ||
      oldDelegate.color != color ||
      oldDelegate.isLight != isLight;
}

class _SectionCanvasBackground extends StatelessWidget {
  final int sectionIndex;
  final Color color;
  final bool isLight;

  const _SectionCanvasBackground({
    required this.sectionIndex,
    required this.color,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    switch (sectionIndex) {
      case 1:
        // BUILD (Developer) -> Code Matrix, Circuit Traces & Syntax Brackets
        return CustomPaint(
          painter: _DeveloperCodeMatrixPainter(color: color),
        );
      case 2:
        // GROW (Marketer) -> Growth Curve Sine Waves & Analytics Matrix
        return CustomPaint(
          painter: _MarketerGrowthWavePainter(color: color),
        );
      case 3:
        // OPERATE (Deployer/DevOps) -> Server Node Mesh, Bus Lines & Terminal Glyphs
        return CustomPaint(
          painter: _DeployerNetworkTopologyPainter(color: color),
        );
      case 4:
        // LAB (Experiments) -> Quantum Particle Constellation & Orbit Rings
        return CustomPaint(
          painter: _LabQuantumParticlePainter(color: color),
        );
      case 0:
      default:
        // HOME -> Cyber Command Center Perspective Grid Floor & Constellation
        return CustomPaint(
          painter: _HomePerspectiveGridPainter(color: color, isLight: isLight),
        );
    }
  }
}

// =============================================================================
// SECTION 0: HOME — Cyber Command Center & Perspective Grid
// =============================================================================
class _HomePerspectiveGridPainter extends CustomPainter {
  final Color color;
  final bool isLight;

  _HomePerspectiveGridPainter({required this.color, required this.isLight});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: isLight ? 0.07 : 0.04)
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
  bool shouldRepaint(covariant _HomePerspectiveGridPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.isLight != isLight;
}

// =============================================================================
// SECTION 1: BUILD (DEVELOPER) — Code Matrix, Circuit Traces & Syntax Glyphs
// =============================================================================
class _DeveloperCodeMatrixPainter extends CustomPainter {
  final Color color;

  _DeveloperCodeMatrixPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final tracePaint = Paint()
      ..color = color.withValues(alpha: 0.04)
      ..strokeWidth = 1;

    final dotPaint = Paint()
      ..color = color.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;

    // Draw Grid Circuit Traces
    const step = 60.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), tracePaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), tracePaint);
    }

    // Circuit Nodes at Intersections
    for (double x = step; x < size.width; x += step * 2) {
      for (double y = step; y < size.height; y += step * 2) {
        canvas.drawCircle(Offset(x, y), 2.5, dotPaint);
      }
    }

    // Floating Code Syntax Glyphs ({ }, </>, =>, 01)
    const textStyle = TextStyle(
      color: Color(0x0F00F0FF),
      fontSize: 16,
      fontFamily: 'monospace',
      fontWeight: FontWeight.bold,
    );

    final glyphs = ["{ }", "</>", "=>", "01", "fn()", "class", "async", "const"];
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    int idx = 0;
    for (double x = 80; x < size.width - 80; x += 180) {
      for (double y = 100; y < size.height - 100; y += 160) {
        final symbol = glyphs[idx % glyphs.length];
        textPainter.text = TextSpan(text: symbol, style: textStyle);
        textPainter.layout();
        textPainter.paint(canvas, Offset(x, y));
        idx++;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DeveloperCodeMatrixPainter oldDelegate) =>
      oldDelegate.color != color;
}

// =============================================================================
// SECTION 2: GROW (MARKETER) — Growth Curve Sine Waves & Analytics Grid
// =============================================================================
class _MarketerGrowthWavePainter extends CustomPainter {
  final Color color;

  _MarketerGrowthWavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final wavePaint = Paint()
      ..color = color.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final accentWavePaint = Paint()
      ..color = const Color(0xFF7C3AED).withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw Smooth Growth Sine Waves (Representing Conversion & Reach Charts)
    final path1 = Path();
    final path2 = Path();

    final midY = size.height * 0.5;

    path1.moveTo(0, midY + 50);
    path2.moveTo(0, midY - 30);

    for (double x = 0; x <= size.width; x += 10) {
      final y1 = midY + math.sin(x * 0.005) * 60 + math.cos(x * 0.002) * 30;
      final y2 = midY - 40 + math.sin(x * 0.004 + 1.0) * 80;
      path1.lineTo(x, y1);
      path2.lineTo(x, y2);
    }

    canvas.drawPath(path1, wavePaint);
    canvas.drawPath(path2, accentWavePaint);

    // Analytics Dot Matrix
    final dotPaint = Paint()
      ..color = color.withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;

    for (double x = 40; x < size.width; x += 80) {
      for (double y = 40; y < size.height; y += 80) {
        canvas.drawCircle(Offset(x, y), 1.5, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MarketerGrowthWavePainter oldDelegate) =>
      oldDelegate.color != color;
}

// =============================================================================
// SECTION 3: OPERATE (DEPLOYER / DEVOPS) — Server Node Mesh, Bus Lines & Prompts
// =============================================================================
class _DeployerNetworkTopologyPainter extends CustomPainter {
  final Color color;

  _DeployerNetworkTopologyPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final busPaint = Paint()
      ..color = color.withValues(alpha: 0.05)
      ..strokeWidth = 1.2;

    final nodePaint = Paint()
      ..color = color.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    final nodeBorderPaint = Paint()
      ..color = color.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Interconnected Server Rack Nodes
    final nodes = <Offset>[];
    for (double x = 100; x < size.width; x += 220) {
      for (double y = 80; y < size.height; y += 180) {
        nodes.add(Offset(x, y));
      }
    }

    // Bus Connection Lines between Nodes
    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        final dist = (nodes[i] - nodes[j]).distance;
        if (dist < 280) {
          canvas.drawLine(nodes[i], nodes[j], busPaint);
        }
      }
    }

    // Draw Server Node Circles
    for (var node in nodes) {
      canvas.drawCircle(node, 4, nodePaint);
      canvas.drawCircle(node, 8, nodeBorderPaint);
    }

    // Terminal Prompt Glyphs ($ _, SSH, IPv6, NGINX)
    const promptStyle = TextStyle(
      color: Color(0x1228C840),
      fontSize: 14,
      fontFamily: 'monospace',
      fontWeight: FontWeight.bold,
    );

    final prompts = ["\$ _", "SSH", "IPv6", "NGINX", "PORT:80", "DOCKER", "YAML"];
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    int idx = 0;
    for (double x = 60; x < size.width - 60; x += 200) {
      for (double y = 120; y < size.height - 60; y += 220) {
        final text = prompts[idx % prompts.length];
        textPainter.text = TextSpan(text: text, style: promptStyle);
        textPainter.layout();
        textPainter.paint(canvas, Offset(x + 12, y + 12));
        idx++;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DeployerNetworkTopologyPainter oldDelegate) =>
      oldDelegate.color != color;
}

// =============================================================================
// SECTION 4: LAB (EXPERIMENT) — Quantum Particle Constellation & Orbit Rings
// =============================================================================
class _LabQuantumParticlePainter extends CustomPainter {
  final Color color;

  _LabQuantumParticlePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = color.withValues(alpha: 0.05)
      ..strokeWidth = 1.0;

    final particlePaint = Paint()
      ..color = color.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    final orbitPaint = Paint()
      ..color = color.withValues(alpha: 0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Atomic Orbit Rings
    final center = Offset(size.width * 0.5, size.height * 0.5);
    canvas.drawCircle(center, 120, orbitPaint);
    canvas.drawCircle(center, 260, orbitPaint);

    // Particle Constellation Nodes
    final particles = <Offset>[];
    for (double x = 80; x < size.width; x += 160) {
      for (double y = 80; y < size.height; y += 160) {
        final offsetX = x + math.sin(y) * 20;
        final offsetY = y + math.cos(x) * 20;
        particles.add(Offset(offsetX, offsetY));
      }
    }

    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        if ((particles[i] - particles[j]).distance < 200) {
          canvas.drawLine(particles[i], particles[j], linePaint);
        }
      }
    }

    for (var p in particles) {
      canvas.drawCircle(p, 3.5, particlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LabQuantumParticlePainter oldDelegate) =>
      oldDelegate.color != color;
}
