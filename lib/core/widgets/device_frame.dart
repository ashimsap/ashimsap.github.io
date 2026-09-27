import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum DeviceFrameType { mobile, mobileLandscape, laptop }

class DeviceFrame extends StatefulWidget {
  final List<String> assets;
  final DeviceFrameType type;
  final Color accentColor;
  final bool isIconMode;

  const DeviceFrame({
    super.key,
    required this.assets,
    required this.type,
    required this.accentColor,
    this.isIconMode = false,
  });

  @override
  State<DeviceFrame> createState() => _DeviceFrameState();
}

class _DeviceFrameState extends State<DeviceFrame> {
  int _imageIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.assets.length > 1) {
      _timer = Timer.periodic(2.seconds, (timer) {
        if (mounted) {
          setState(() {
            _imageIndex = (_imageIndex + 1) % widget.assets.length;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = widget.type == DeviceFrameType.mobile;
    final isLandscape = widget.type == DeviceFrameType.mobileLandscape;
    final isLaptop = widget.type == DeviceFrameType.laptop;

    double baseWidth, baseHeight;

    if (isLandscape) {
      baseWidth = 440;
      baseHeight = 220;
    } else if (isMobile) {
      baseWidth = 220;
      baseHeight = 440;
    } else {
      baseWidth = 500;
      baseHeight = 320;
    }

    Widget frameContent = Container(
      width: baseWidth,
      height: baseHeight,
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(isLaptop ? 12 : 32),
        border: Border.all(
          color: const Color(0xFF222222),
          width: isLaptop ? 12 : 8,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.accentColor.withValues(alpha: 0.15),
            blurRadius: 50,
            spreadRadius: -10,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isLaptop ? 6 : 24),
        child: Stack(
          children: [
            if (widget.isIconMode)
              Container(
                color: const Color(0xFF050505),
                child: Center(
                  child: widget.assets.isNotEmpty
                      ? Image.asset(widget.assets.first, width: 80, height: 80)
                      : const FlutterLogo(size: 80),
                ),
              )
            else if (widget.assets.isNotEmpty)
              AnimatedSwitcher(
                duration: 500.ms,
                child: Image.asset(
                  widget.assets[_imageIndex],
                  key: ValueKey<int>(_imageIndex),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (c, o, s) => Container(
                    color: const Color(0xFF1A1A1A),
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.white10),
                    ),
                  ),
                ),
              )
            else
              // GENERATED UI FALLBACK
              Container(
                color: const Color(0xFF151515),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      height: 20,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 30),
                    for (int i = 0; i < 4; i++)
                      Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white24),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 80,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

            // Glass Reflection Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.1),
                      Colors.transparent,
                      Colors.white.withValues(alpha: 0.05),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (isLaptop) {
      frameContent = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 24,
            width: baseWidth + 24,
            decoration: const BoxDecoration(
              color: Color(0xFF222222),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: const [
                SizedBox(width: 15),
                _WindowDot(color: Color(0xFFFF5F57)),
                SizedBox(width: 8),
                _WindowDot(color: Color(0xFFFEBC2E)),
                SizedBox(width: 8),
                _WindowDot(color: Color(0xFF28C840)),
              ],
            ),
          ),
          frameContent,
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final targetWidth = isLaptop ? baseWidth + 24 : baseWidth;
        if (constraints.maxWidth < targetWidth) {
          return FittedBox(
            fit: BoxFit.scaleDown,
            child: frameContent,
          );
        }
        return frameContent
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .moveY(
              begin: 0,
              end: -10,
              duration: 4.seconds,
              curve: Curves.easeInOutQuad,
            );
      },
    );
  }
}

class _WindowDot extends StatelessWidget {
  final Color color;
  const _WindowDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
