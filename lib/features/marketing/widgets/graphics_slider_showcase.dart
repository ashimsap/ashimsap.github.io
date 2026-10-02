import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class GraphicsSliderShowcase extends StatefulWidget {
  final List<String>? customGraphicsList;

  const GraphicsSliderShowcase({super.key, this.customGraphicsList});

  @override
  State<GraphicsSliderShowcase> createState() => _GraphicsSliderShowcaseState();
}

class _GraphicsSliderShowcaseState extends State<GraphicsSliderShowcase> {
  late PageController _pageController;
  Timer? _autoSliderTimer;
  int _currentIndex = 0;

  // Default serial graphics list (scalable for future graphics_4.png, etc.)
  final List<String> _graphics = [
    "assets/graphics/graphics_1.png",
    "assets/graphics/graphics_2.png",
    "assets/graphics/graphics_3.png",
  ];

  List<String> get _activeList => widget.customGraphicsList ?? _graphics;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoSlider();
  }

  void _startAutoSlider() {
    _autoSliderTimer?.cancel();
    _autoSliderTimer = Timer.periodic(const Duration(milliseconds: 3500), (timer) {
      if (!mounted || _activeList.isEmpty) return;
      final nextIndex = (_currentIndex + 1) % _activeList.length;
      _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _autoSliderTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 20,
                spreadRadius: -2,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Padding(
                padding: EdgeInsets.all(isMobile ? 16 : 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3E8FF),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: const Color(0xFFDDD6FE)),
                          ),
                          child: Text(
                            "GRAPHIC DESIGN & BRANDING",
                            style: GoogleFonts.robotoMono(
                              color: const Color(0xFF7E22CE),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.palette_outlined,
                            color: const Color(0xFF7C3AED), size: 18),
                        const SizedBox(width: 6),
                        Text(
                          "AUTO SLIDER",
                          style: GoogleFonts.robotoMono(
                            color: const Color(0xFF7C3AED),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "GRAPHIC CREATIVES",
                      style: GoogleFonts.syne(
                        color: const Color(0xFF0F172A),
                        fontSize: isMobile ? 20 : 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Promotional campaign designs, social media graphics, and marketing visual assets.",
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF475569),
                        fontSize: isMobile ? 13 : 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              // Main Graphics Viewer Frame (Matched to 4:5 aspect ratio)
              _buildGraphicsViewer(context, isMobile),

              const SizedBox(height: 16),

              // Modern Indicator Dots Bar
              _buildDotsIndicator(context),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGraphicsViewer(BuildContext context, bool isMobile) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCBD5E1)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: 4 / 5, // Exact 4:5 ratio for social graphics
          child: Stack(
            children: [
              // PageView Auto-Slider
              PageView.builder(
                controller: _pageController,
                itemCount: _activeList.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final assetPath = _activeList[index];
                  return Image.asset(
                    assetPath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF1E293B),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.image_outlined,
                                  color: Colors.white38, size: 36),
                              const SizedBox(height: 8),
                              Text(
                                "Graphic Creative 0${index + 1}",
                                style: GoogleFonts.robotoMono(
                                  color: Colors.white60,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

              // Graphic Serial Badge Overlay (Top Right)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C3AED).withValues(alpha: 0.88),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.white60),
                  ),
                  child: Text(
                    "CREATIVE 0${_currentIndex + 1} / 0${_activeList.length}",
                    style: GoogleFonts.robotoMono(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDotsIndicator(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_activeList.length, (index) {
        final isSelected = _currentIndex == index;
        return GestureDetector(
          onTap: () {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutCubic,
            );
          },
          child: AnimatedContainer(
            duration: 200.ms,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isSelected ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF7C3AED) : const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }),
    );
  }
}
