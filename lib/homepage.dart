import 'dart:ui';
import 'dart:math' as math;
import 'package:blurbox/blurbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'github_contributions.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  final _scrollController = ScrollController();
  final _key = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;
  final _sectionKeys = [GlobalKey(), GlobalKey(), GlobalKey()];
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isSyncing) return;

    double minDiff = double.infinity;
    int targetIndex = 0;

    for (int i = 0; i < _sectionKeys.length; i++) {
      final key = _sectionKeys[i];
      final context = key.currentContext;
      if (context == null) continue;

      final box = context.findRenderObject() as RenderBox?;
      if (box == null) continue;

      final position = box.localToGlobal(Offset.zero);
      final diff = position.dy.abs();

      if (diff < minDiff) {
        minDiff = diff;
        targetIndex = i;
      }
    }

    if (_selectedIndex != targetIndex) {
      setState(() => _selectedIndex = targetIndex);
    }
  }

  void _scrollTo(int index) {
    _isSyncing = true;
    setState(() => _selectedIndex = index);
    
    final context = _sectionKeys[index].currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: 800.ms,
        curve: Curves.easeInOutQuart,
        alignment: 0.0, 
      ).then((_) => _isSyncing = false);
    } else {
      _isSyncing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: const Color(0xFF050505),
      body: Stack(
        children: [
          const _BackgroundOrbs(),
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage("https://www.transparenttextures.com/patterns/stardust.png"),
                    repeat: ImageRepeat.repeat,
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              _CustomSideNav(
                selectedIndex: _selectedIndex,
                onItemSelected: _scrollTo,
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _ProfileSection(key: _sectionKeys[0]),
                      _ProjectsSection(key: _sectionKeys[1]),
                      _SkillsExperienceSection(key: _sectionKeys[2]),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: const _FloatingBadge()
                .animate()
                .fadeIn(delay: 1000.ms)
                .slideY(begin: 1.0, end: 0.0),
          ),
        ],
      ),
    );
  }
}

// --- Device Frame Widget (The "Shots.so" Engine) ---

enum DeviceType { mobile, laptop }

class _DeviceFrame extends StatelessWidget {
  final String? asset;
  final DeviceType type;
  final Color accentColor;
  final bool isDefaultIcon;

  const _DeviceFrame({
    required this.asset,
    required this.type,
    required this.accentColor,
    this.isDefaultIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = type == DeviceType.mobile;
    
    // Base Frame
    Widget frame = Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(isMobile ? 30 : 12),
        border: Border.all(
          color: const Color(0xFF2D2D2D), // Dark bezel
          width: isMobile ? 8 : 12, // Thicker bezel for phones
        ),
        boxShadow: [
          // Deep shadow for floating effect
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 40,
            offset: const Offset(0, 30),
            spreadRadius: -5,
          ),
          // Subtle accent glow
          BoxShadow(
            color: accentColor.withValues(alpha: 0.15),
            blurRadius: 50,
            offset: const Offset(0, 0),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isMobile ? 22 : 4),
        child: Stack(
          children: [
            // The Screenshot or Fallback
            if (isDefaultIcon)
               Container(
                width: isMobile ? 200 : 500,
                height: isMobile ? 400 : 300,
                color: const Color(0xFF1A1A1A),
                child: const Center(
                  child: FlutterLogo(size: 80),
                ),
              )
            else
              Image.asset(
                asset!,
                fit: BoxFit.cover,
                width: isMobile ? 200 : 500, // Explicit sizing for mockups
                height: isMobile ? 400 : 300,
                errorBuilder: (c, o, s) => Container(
                  width: isMobile ? 200 : 500,
                  height: isMobile ? 400 : 300,
                  color: const Color(0xFF1A1A1A),
                  child: Center(
                    child: Icon(
                      type == DeviceType.mobile ? Icons.smartphone : Icons.laptop, 
                      color: Colors.white10, 
                      size: 60
                    ),
                  ),
                ),
              ),
            
            // Screen Glare / Reflection (The "Glass" look)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.05),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.white.withValues(alpha: 0.02),
                    ],
                    stops: const [0.0, 0.3, 0.7, 1.0],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // Add Laptop Header if needed
    if (!isMobile) {
      frame = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Laptop Lid/Camera
          Container(
            height: 24,
            width: 524, // Slightly wider than screen
            decoration: const BoxDecoration(
              color: Color(0xFF2D2D2D),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 15),
                _WindowDot(color: Colors.red),
                const SizedBox(width: 6),
                _WindowDot(color: Colors.amber),
                const SizedBox(width: 6),
                _WindowDot(color: Colors.green),
              ],
            ),
          ),
          frame,
        ],
      );
    }

    // Apply the "Floating in Zero-G" Animation
    return frame
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .moveY(
          begin: 0, 
          end: -15, 
          duration: 4.seconds, 
          curve: Curves.easeInOutSine
        ); 
  }
}

class _WindowDot extends StatelessWidget {
  final Color color;
  const _WindowDot({required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

// --- Custom Components ---

class _GlitchText extends StatelessWidget {
  final String text;
  final double fontSize;

  const _GlitchText({required this.text, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Red Channel
        Text(
          text,
          style: GoogleFonts.outfit(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            color: Colors.red.withValues(alpha: 0.8),
            height: 1.1,
          ),
        )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .move(begin: const Offset(-2, 0), end: const Offset(2, 0), duration: 100.ms, curve: Curves.easeInOut)
        .fadeIn(duration: 100.ms)
        .then()
        .hide(duration: 2000.ms),

        // Blue Channel
        Text(
          text,
          style: GoogleFonts.outfit(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            color: Colors.blue.withValues(alpha: 0.8),
            height: 1.1,
          ),
        )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .move(begin: const Offset(2, 0), end: const Offset(-2, 0), duration: 120.ms, curve: Curves.easeInOut)
        .fadeIn(duration: 120.ms)
        .then()
        .hide(duration: 1500.ms),

        // Main Text
        Text(
          text,
          style: GoogleFonts.outfit(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            height: 1.1,
            shadows: [
              BoxShadow(
                color: const Color(0xFF00F0FF).withValues(alpha: 0.5),
                blurRadius: 20,
                offset: const Offset(0, 0),
              )
            ]
          ),
        ),
      ],
    );
  }
}

class _HoloCard extends StatefulWidget {
  final Widget child;
  final Color color;
  final VoidCallback? onTap;

  const _HoloCard({required this.child, required this.color, this.onTap});

  @override
  State<_HoloCard> createState() => _HoloCardState();
}

class _HoloCardState extends State<_HoloCard> {
  Offset _mousePos = Offset.zero;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _mousePos = Offset.zero;
      }),
      onHover: (details) {
        final renderBox = context.findRenderObject() as RenderBox;
        final localPos = renderBox.globalToLocal(details.position);
        final center = renderBox.size.center(Offset.zero);
        setState(() {
          _mousePos = (localPos - center);
        });
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: TweenAnimationBuilder<Offset>(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          tween: Tween(begin: Offset.zero, end: _isHovered ? _mousePos : Offset.zero),
          builder: (context, offset, child) {
            double tiltX = -offset.dy * 0.001;
            double tiltY = offset.dx * 0.001;
            
            tiltX = tiltX.clamp(-0.01, 0.01);
            tiltY = tiltY.clamp(-0.01, 0.01);

            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) 
                ..rotateX(tiltX)
                ..rotateY(tiltY),
              alignment: Alignment.center,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withValues(alpha: 0.6),
                  border: Border.all(
                    color: _isHovered ? widget.color.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                  boxShadow: _isHovered 
                    ? [
                        BoxShadow(
                          color: widget.color.withValues(alpha: 0.2),
                          blurRadius: 30,
                          spreadRadius: -10,
                          offset: const Offset(0, 20)
                        )
                      ]
                    : [],
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _CyberGridPainter(
                          color: widget.color.withValues(alpha: 0.15),
                          offset: offset * 0.2,
                        ),
                      ),
                    ),
                    widget.child,
                    if (_isHovered)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: Alignment(
                                offset.dx * 0.005, 
                                offset.dy * 0.005,
                              ),
                              radius: 1.2,
                              colors: [
                                Colors.white.withValues(alpha: 0.1),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}

class _CyberGridPainter extends CustomPainter {
  final Color color;
  final Offset offset;

  _CyberGridPainter({required this.color, required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final gridSize = 40.0;
    
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x + (offset.dx % gridSize), 0),
        Offset(x + (offset.dx % gridSize), size.height),
        paint,
      );
    }
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y + (offset.dy % gridSize)),
        Offset(size.width, y + (offset.dy % gridSize)),
        paint,
      );
    }

    final pointPaint = Paint()..color = color.withValues(alpha: 0.5)..style = PaintingStyle.fill;
    for (double x = 0; x < size.width; x += gridSize * 2) {
      for (double y = 0; y < size.height; y += gridSize * 2) {
        if ((x + y) % 3 == 0) { 
           canvas.drawCircle(Offset(x + (offset.dx % gridSize), y + (offset.dy % gridSize)), 2, pointPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CyberGridPainter oldDelegate) => 
      oldDelegate.offset != offset || oldDelegate.color != color;
}

// --- Custom Side Navigation ---

class _CustomSideNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const _CustomSideNav({
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 800;
    
    return Container(
      width: isSmallScreen ? 80 : 220,
      color: Colors.transparent, 
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, 
        children: [
          _NavItem(
            icon: Icons.person_outline,
            label: "Profile",
            index: 0,
            isSelected: selectedIndex == 0,
            isCollapsed: isSmallScreen,
            onTap: () => onItemSelected(0),
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.2),
          
          const SizedBox(height: 25),
          
          _NavItem(
            icon: Icons.code_rounded,
            label: "Projects",
            index: 1,
            isSelected: selectedIndex == 1,
            isCollapsed: isSmallScreen,
            onTap: () => onItemSelected(1),
          ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),
          
          const SizedBox(height: 25),
          
          _NavItem(
            icon: Icons.bar_chart_rounded,
            label: "Skills",
            index: 2,
            isSelected: selectedIndex == 2,
            isCollapsed: isSmallScreen,
            onTap: () => onItemSelected(2),
          ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.2),
        ],
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final int index;
  final bool isSelected;
  final bool isCollapsed;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.isSelected,
    required this.isCollapsed,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;
    final activeColor = const Color(0xFF00F0FF); // Neon Cyan

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutQuart,
          padding: EdgeInsets.symmetric(
            vertical: 12, 
            horizontal: widget.isCollapsed ? 0 : 20
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.isCollapsed
                  ? Icon(
                      widget.icon,
                      color: isSelected ? activeColor : Colors.white60,
                      size: 24, 
                    ).animate(target: isSelected ? 1 : 0)
                     .scale(begin: const Offset(1, 1), end: const Offset(1.3, 1.3), duration: 300.ms, curve: Curves.easeOutBack)
                     .tint(color: activeColor, duration: 300.ms)
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.icon,
                          color: isSelected ? activeColor : Colors.white60,
                          size: 22,
                        ).animate(target: isSelected ? 1 : 0)
                         .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 300.ms, curve: Curves.easeOutBack)
                         .tint(color: activeColor, duration: 300.ms),
                        
                        const SizedBox(width: 15),
                        
                        AnimatedDefaultTextStyle(
                          duration: 300.ms,
                          style: GoogleFonts.robotoMono(
                            color: isSelected ? Colors.white : Colors.white60,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: isSelected ? 16 : 14,
                            letterSpacing: 1,
                          ),
                          child: Text(widget.label),
                        ),
                      ],
                    ),
              
              const SizedBox(height: 8), 
              
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 3,
                width: isSelected ? (widget.isCollapsed ? 20 : 80) : 0, 
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: activeColor.withValues(alpha: 0.8),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                          BoxShadow(
                            color: activeColor.withValues(alpha: 0.4),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ]
                      : [],
                ),
              ).animate(target: isSelected ? 1 : 0)
               .shimmer(duration: 2.seconds, color: Colors.white.withValues(alpha: 0.5)),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackgroundOrbs extends StatelessWidget {
  const _BackgroundOrbs();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF00F0FF).withValues(alpha: 0.15),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
              duration: 4.seconds, begin: const Offset(1, 1), end: const Offset(1.2, 1.2)),
        ),
        Positioned(
          top: -100,
          left: -100,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: const SizedBox(width: 400, height: 400),
          ),
        ),
        Positioned(
          bottom: 100,
          right: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF7000FF).withValues(alpha: 0.15),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(
            duration: 5.seconds, begin: 0, end: 50),
        ),
        Positioned(
          bottom: 100,
          right: -50,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: const SizedBox(width: 300, height: 300),
          ),
        ),
         Align(
          alignment: Alignment.center,
          child: Container(
            width: 600,
            height: 600,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.02),
            ),
          ),
        ),
      ],
    );
  }
}

class _FloatingBadge extends StatefulWidget {
  const _FloatingBadge();

  @override
  State<_FloatingBadge> createState() => _FloatingBadgeState();
}

class _FloatingBadgeState extends State<_FloatingBadge> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isHovered ? const Color(0xFF00F0FF).withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: isHovered ? const Color(0xFF00F0FF) : Colors.white12),
          boxShadow: isHovered
              ? [
                  BoxShadow(
                      color: const Color(0xFF00F0FF).withValues(alpha: 0.4),
                      blurRadius: 15,
                      spreadRadius: 2)
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.flutter_dash, 
                 color: isHovered ? const Color(0xFF00F0FF) : Colors.white70, size: 20),
            const SizedBox(width: 8),
            Text(
              "Made with Flutter",
              style: GoogleFonts.robotoMono(
                color: isHovered ? const Color(0xFF00F0FF) : Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
                border: Border.all(
                    color: const Color(0xFF00F0FF).withValues(alpha: 0.8), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00F0FF).withValues(alpha: 0.4),
                    blurRadius: 40,
                    spreadRadius: 5,
                  ),
                ],
                 image: const DecorationImage(
                   image: AssetImage('assets/avatar/avatar.png'), // Updated path
                   fit: BoxFit.cover,
                 ),
              ),
            )
            .animate()
            .fadeIn(duration: 800.ms)
            .scale(delay: 200.ms, curve: Curves.easeOutBack)
            .shimmer(delay: 1.seconds, duration: 2.seconds, color: const Color(0xFF00F0FF)),

            const SizedBox(height: 40),

            const _GlitchText(text: "ASHIM SAPKOTA", fontSize: 56),

            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF7000FF).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFF7000FF).withValues(alpha: 0.3)),
              ),
              child: Text(
                "< Flutter Developer | Linux Enthusiast | Mobile Architect />",
                style: GoogleFonts.robotoMono(
                    color: const Color(0xFF00F0FF),
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3),

            const SizedBox(height: 40),

            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: BlurBox(
                blur: 10,
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                padding: const EdgeInsets.all(24),
                child: Text(
                  "Building production-ready mobile apps and robust systems. Currently creating solutions at F1Soft. Passionate about clean architecture, Linux ecosystems, and scalable code.",
                  style: GoogleFonts.outfit(
                      color: Colors.white70, fontSize: 18, height: 1.6),
                  textAlign: TextAlign.center,
                ),
              ),
            ).animate().fadeIn(delay: 800.ms),

            const SizedBox(height: 50),

            const GithubContributions(),

            const SizedBox(height: 50),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SocialPill(
                  label: "GitHub",
                  icon: Icons.code,
                  onTap: () =>
                      launchUrl(Uri.parse('https://github.com/ashimsap')),
                ),
                const SizedBox(width: 20),
                _SocialPill(
                  label: "LinkedIn",
                  icon: Icons.work_outline,
                  onTap: () => launchUrl(
                      Uri.parse('https://www.linkedin.com/in/ashimsapkota')),
                ),
              ],
            ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.5),
          ],
        ),
      ),
    );
  }
}

class _ProjectsSection extends StatelessWidget {
  const _ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = [
      _ProjectData(
        title: "Basobaas Map",
        tags: ["Flutter", "Firebase", "Mapbox"],
        description: "Nepal's map-based rental discovery platform.",
        details: "Built with scalable logic for user trust and location verification.",
        color: const Color(0xFF00F0FF),
        url: "https://github.com/ashimsap/basobaas_map",
        deviceType: DeviceType.mobile,
        imageAsset: "assets/ss/basobaas.png", // Assumed filename
      ),
      _ProjectData(
        title: "Stream Deck System",
        tags: ["Linux", "WebSocket", "Dart"],
        description: "Custom hardware interface control via mobile.",
        details: "Real-time command execution bridge between Manjaro Linux and mobile devices.",
        color: const Color(0xFF7000FF),
        url: "https://github.com/ashimsap/deck",
        deviceType: DeviceType.laptop,
        imageAsset: "assets/ss/deck.png", // Assumed filename
      ),
      _ProjectData(
        title: "Code Vault",
        tags: ["Server-Side Dart", "LAN", "Utility"],
        description: "Secure code snippet manager on local network.",
        details: "Hosts a full server directly on the mobile device for team productivity.",
        color: const Color(0xFF00FF9D),
        url: "https://github.com/ashimsap/code_vault",
        deviceType: DeviceType.mobile,
        imageAsset: "assets/ss/code_vault.png", // Assumed filename
      ),
       _ProjectData(
        title: "To-Do App",
        tags: ["Flutter", "Hive", "Provider"],
        description: "A clean and efficient task management app.",
        details: "First major project exploring local storage and state management.",
        color: const Color(0xFFFF0055),
        url: "https://github.com/ashimsap/to_do",
        deviceType: DeviceType.mobile,
        // No SS available, will use fallback
      ),
      _ProjectData(
        title: "Dummy App",
        tags: ["Research", "Packages", "Refactoring"],
        description: "Sandbox for testing Flutter packages and patterns.",
        details: "Continuous refactoring and implementation of new Flutter features.",
        color: Colors.amberAccent,
        url: "https://github.com/ashimsap/dummy_app",
        deviceType: DeviceType.mobile,
        isDefaultIcon: true, // Uses Flutter Logo
      ),
    ];

    return Container(
      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: "Featured Projects"),
          const SizedBox(height: 60),
          LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 40,
                runSpacing: 40,
                children: projects.map((p) => SizedBox(
                  width: constraints.maxWidth > 900 ? (constraints.maxWidth - 40) / 2 : constraints.maxWidth,
                  child: _HoloCard(
                    color: p.color,
                    onTap: p.url != null ? () => launchUrl(Uri.parse(p.url!)) : null,
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p.title, style: GoogleFonts.outfit(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 10),
                                    Text(p.description, style: GoogleFonts.outfit(color: Colors.white70, fontSize: 16)),
                                  ],
                                ),
                              ),
                              Icon(Icons.arrow_outward, color: p.color, size: 28)
                            ],
                          ),
                          const SizedBox(height: 25),
                          
                          // THE DEVICE FRAME ANIMATION
                          Center(
                            child: _DeviceFrame(
                              asset: p.imageAsset,
                              type: p.deviceType,
                              accentColor: p.color,
                              isDefaultIcon: p.isDefaultIcon,
                            ),
                          ),

                          const SizedBox(height: 25),
                          
                          Wrap(
                            spacing: 10,
                            children: p.tags.map((t) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: p.color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: p.color.withValues(alpha: 0.3)),
                              ),
                              child: Text(t, style: GoogleFonts.robotoMono(color: p.color, fontSize: 12, fontWeight: FontWeight.w600)),
                            )).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                )).toList(),
              );
            }
          ),
        ],
      ),
    );
  }
}

class _SkillsExperienceSection extends StatelessWidget {
  const _SkillsExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: "Experience"),
          const SizedBox(height: 30),
          _ExperienceCard(),
          const SizedBox(height: 80),
          _SectionTitle(title: "Tech Stack"),
          const SizedBox(height: 30),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _SkillChip(label: "Flutter & Dart", icon: Icons.flutter_dash),
              _SkillChip(label: "Riverpod", icon: Icons.waves),
              _SkillChip(label: "REST APIs", icon: Icons.api),
              _SkillChip(label: "Linux / Bash", icon: Icons.terminal),
              _SkillChip(label: "Git & CI/CD", icon: Icons.merge_type),
              _SkillChip(label: "Firebase", icon: Icons.local_fire_department),
            ],
          ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1),
        ],
      ),
    );
  }
}

// --- Components ---

class _ExperienceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _HoloCard(
      color: const Color(0xFF00F0FF),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "F1Soft International Pvt. Ltd.",
                  style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00F0FF).withValues(alpha: 0.1),
                    border: Border.all(color: const Color(0xFF00F0FF).withValues(alpha: 0.3)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "CURRENT",
                    style: GoogleFonts.robotoMono(
                        color: const Color(0xFF00F0FF),
                        fontWeight: FontWeight.bold,
                        fontSize: 10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text("App Development Intern",
                style: GoogleFonts.robotoMono(color: const Color(0xFF00F0FF), fontSize: 14)),
            const SizedBox(height: 20),
            Text(
              "• Collaborating on high-traffic financial applications.\n• Implementing clean architecture with Riverpod.\n• Bridging gaps between backend APIs and mobile UI.",
              style: GoogleFonts.outfit(color: Colors.white70, height: 1.6, fontSize: 16),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms);
  }
}

class _SocialPill extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _SocialPill(
      {required this.label, required this.icon, required this.onTap});

  @override
  State<_SocialPill> createState() => _SocialPillState();
}

class _SocialPillState extends State<_SocialPill> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: isHovered ? Colors.white : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isHovered ? Colors.white : Colors.white12
            )
          ),
          child: Row(
            children: [
              Icon(widget.icon, color: isHovered ? Colors.black : Colors.white),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: GoogleFonts.outfit(
                  color: isHovered ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _SkillChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(width: 10),
          Text(label, style: GoogleFonts.robotoMono(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "// ", 
              style: GoogleFonts.robotoMono(color: const Color(0xFF00F0FF), fontSize: 16)
            ),
            Text(
              title.toUpperCase(),
              style: GoogleFonts.robotoMono(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProjectData {
  final String title;
  final List<String> tags;
  final String description;
  final String details;
  final Color color;
  final String? url;
  final String? imageAsset;
  final DeviceType deviceType;
  final bool isDefaultIcon;

  _ProjectData({
    required this.title,
    required this.tags,
    required this.description,
    required this.details,
    required this.color,
    this.url,
    this.imageAsset,
    this.deviceType = DeviceType.mobile,
    this.isDefaultIcon = false,
  });
}
