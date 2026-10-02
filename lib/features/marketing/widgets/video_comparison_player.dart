import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class VideoComparisonPlayer extends StatefulWidget {
  const VideoComparisonPlayer({super.key});

  @override
  State<VideoComparisonPlayer> createState() => _VideoComparisonPlayerState();
}

class _VideoComparisonPlayerState extends State<VideoComparisonPlayer> {
  late VideoPlayerController _rawController;
  late VideoPlayerController _gradedController;

  bool _isInitialized = false;
  bool _hasError = false;
  String? _errorMessage;

  double _sliderValue = 0.5; // 0.0 = 100% GRADED, 0.5 = RAW left / GRADED right, 1.0 = 100% RAW
  bool _isPlaying = false;

  Timer? _loopSyncTimer;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  Future<VideoPlayerController> _createAssetController(String assetPath) async {
    VideoPlayerController controller;
    if (kIsWeb) {
      try {
        controller = VideoPlayerController.asset(assetPath);
        await controller.initialize();
        return controller;
      } catch (_) {
        controller = VideoPlayerController.networkUrl(Uri.parse(assetPath));
        await controller.initialize();
        return controller;
      }
    } else {
      controller = VideoPlayerController.asset(assetPath);
      await controller.initialize();
      return controller;
    }
  }

  Future<void> _initializeControllers() async {
    try {
      _rawController = await _createAssetController('assets/video/raw.mp4');
      _gradedController =
          await _createAssetController('assets/video/color_graded.mp4');

      // Strictly silent (no audio) for auto-loop playback
      await _rawController.setVolume(0.0);
      await _gradedController.setVolume(0.0);

      _rawController.setLooping(true);
      _gradedController.setLooping(true);

      // Initial alignment
      await _rawController.seekTo(Duration.zero);
      await _gradedController.seekTo(Duration.zero);

      // Start playing simultaneously
      await _rawController.play();
      await _gradedController.play();

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _isPlaying = true;
        });
      }

      // Check loop boundary & large macro drift periodically (every 1.5 seconds)
      _loopSyncTimer = Timer.periodic(const Duration(milliseconds: 1500), (_) {
        if (_isInitialized && _isPlaying) {
          _checkMacroSync();
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = "Could not load video files: $e";
        });
      }
    }
  }

  void _checkMacroSync() {
    if (!_isInitialized) return;
    final posRaw = _rawController.value.position;
    final posGraded = _gradedController.value.position;

    final diff = (posRaw.inMilliseconds - posGraded.inMilliseconds).abs();
    if (diff > 1000) {
      _gradedController.seekTo(posRaw);
    }
  }

  @override
  void dispose() {
    _loopSyncTimer?.cancel();
    if (_isInitialized) {
      _rawController.dispose();
      _gradedController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Align(
      alignment: Alignment.centerLeft, // Left aligned to accommodate future image grading components
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
                            "VIDEO PRODUCTION & EDITING",
                            style: GoogleFonts.robotoMono(
                              color: const Color(0xFF7E22CE),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.tune_rounded,
                            color: const Color(0xFF7C3AED), size: 18),
                        const SizedBox(width: 6),
                        Text(
                          "INTERACTIVE COMPARISON",
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
                      "COLOR GRADING",
                      style: GoogleFonts.syne(
                        color: const Color(0xFF0F172A),
                        fontSize: isMobile ? 20 : 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Comparing the original camera footage (left) with the final color-graded result (right). Drag the slider to reveal the grade.",
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF475569),
                        fontSize: isMobile ? 13 : 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              // Compact Video Viewer Frame
              if (_hasError)
                Container(
                  height: 220,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        _errorMessage ?? "Error loading video comparison.",
                        style: GoogleFonts.outfit(color: const Color(0xFF64748B)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              else if (!_isInitialized)
                Container(
                  height: isMobile ? 200 : 320,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF7C3AED),
                    ),
                  ),
                )
              else
                _buildVideoComparisonViewer(context, isMobile),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoComparisonViewer(BuildContext context, bool isMobile) {
    final aspectRatio = _rawController.value.aspectRatio > 0
        ? _rawController.value.aspectRatio
        : 16 / 9;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 20),
      decoration: BoxDecoration(
        color: Colors.black,
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
          aspectRatio: aspectRatio,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final boxWidth = constraints.maxWidth;

              return Stack(
                children: [
                  // 1. BASE LAYER: COLOR GRADED VIDEO (RIGHT SIDE)
                  Positioned.fill(
                    child: VideoPlayer(_gradedController),
                  ),

                  // GRADED Label Badge (Top Right)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED).withValues(alpha: 0.88),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.white60),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        "COLOR GRADED",
                        style: GoogleFonts.robotoMono(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // 2. TOP LAYER: RAW FOOTAGE (LEFT SIDE - Clipped to Slider Width)
                  Positioned.fill(
                    child: ClipRect(
                      clipper: _HorizontalRectClipper(_sliderValue),
                      child: VideoPlayer(_rawController),
                    ),
                  ),

                  // RAW Label Badge (Top Left)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.white30),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        "RAW FOOTAGE",
                        style: GoogleFonts.robotoMono(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // 3. BUTTERY-SMOOTH INTERACTIVE SLIDER DIVIDER HANDLE
                  Positioned(
                    left: (boxWidth * _sliderValue) - 18,
                    top: 0,
                    bottom: 0,
                    child: IgnorePointer(
                      child: SizedBox(
                        width: 36,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Vertical Glowing Line
                            Container(
                              width: 2.5,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xCC7C3AED),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),

                            // Floating Handle Knob
                            Container(
                              width: 36,
                              height: 38,
                              decoration: BoxDecoration(
                                color: const Color(0xFF7C3AED),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                    color: Colors.white, width: 2.5),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x66000000),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.swap_horiz_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 4. FULL FRAME TOUCH/MOUSE SMOOTH PANNING OVERLAY
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onPanStart: (details) {
                        final newPos = details.localPosition.dx;
                        setState(() {
                          _sliderValue = (newPos / boxWidth).clamp(0.0, 1.0);
                        });
                      },
                      onPanUpdate: (details) {
                        final newPos = details.localPosition.dx;
                        setState(() {
                          _sliderValue = (newPos / boxWidth).clamp(0.0, 1.0);
                        });
                      },
                      onTapDown: (details) {
                        final newPos = details.localPosition.dx;
                        setState(() {
                          _sliderValue = (newPos / boxWidth).clamp(0.0, 1.0);
                        });
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HorizontalRectClipper extends CustomClipper<Rect> {
  final double fraction; // 0.0 to 1.0
  _HorizontalRectClipper(this.fraction);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * fraction, size.height);
  }

  @override
  bool shouldReclip(covariant _HorizontalRectClipper oldClipper) =>
      oldClipper.fraction != fraction;
}
