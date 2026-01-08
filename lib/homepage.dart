import 'dart:ui';
import 'package:blurbox/blurbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'github_contributions.dart';

// --- ENUMS ---
enum DeviceType { mobile, laptop, mobileLandscape }

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
  
  Offset _mousePos = Offset.zero;

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
    double minDiff = double.infinity;
    int targetIndex = 0;

    // Use viewport height to check if a section is occupying the screen
    final viewportHeight = MediaQuery.of(context).size.height;
    final viewCenter = viewportHeight / 2;

    for (int i = 0; i < _sectionKeys.length; i++) {
      final key = _sectionKeys[i];
      final context = key.currentContext;
      if (context == null) continue;

      final box = context.findRenderObject() as RenderBox?;
      if (box == null) continue;

      final position = box.localToGlobal(Offset.zero);
      // We check if the section is covering the center of the screen
      final top = position.dy;
      final bottom = top + box.size.height;

      // If the section covers the center point of the viewport
      if (top <= viewCenter && bottom >= viewCenter) {
          targetIndex = i;
          break; // Found the section covering the center
      }
      
      // Fallback: Closest to top if no section covers center (e.g. very top or bottom)
      final diff = top.abs();
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
    setState(() => _selectedIndex = index);
    final context = _sectionKeys[index].currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: 1000.ms,
        curve: Curves.easeInOutCubicEmphasized, 
        alignment: 0.0, 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: const Color(0xFF030303), 
      body: MouseRegion(
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
                  color: const Color(0xFF00F0FF)
                ),
              ),
            ),

            // 2. ANIMATED CYBER GRID FLOOR
            Positioned.fill(
              child: const _CyberGridBackground()
                  .animate(onPlay: (c) => c.repeat())
                  .shimmer(duration: 5.seconds, color: const Color(0xFF00F0FF).withValues(alpha: 0.1)),
            ),

            // 3. SCANLINE OVERLAY
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Color(0x0500F0FF), 
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                  ),
                ).animate(onPlay: (c) => c.repeat()).moveY(
                  begin: -100, 
                  end: 100, 
                  duration: 8.seconds, 
                  curve: Curves.linear
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
                      image: NetworkImage("https://www.transparenttextures.com/patterns/stardust.png"),
                      repeat: ImageRepeat.repeat,
                    ),
                  ),
                ),
              ),
            ),

            // 5. MAIN CONTENT
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
                        _HeroSection(key: _sectionKeys[0]),
                        _ProjectsSection(key: _sectionKeys[1]),
                        _SkillsExperienceSection(key: _sectionKeys[2]),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // 7. FLOATING BADGE
            Positioned(
              bottom: 30,
              right: 30,
              child: const _FloatingBadge()
                  .animate()
                  .fadeIn(delay: 1000.ms)
                  .slideY(begin: 1.0, end: 0.0),
            ),
          ],
        ),
      ),
    );
  }
}

// --- VISUAL FX: THE SPOTLIGHT PAINTER ---
class _SpotlightPainter extends CustomPainter {
  final Offset mousePos;
  final Color color;

  _SpotlightPainter({required this.mousePos, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    // 1. The primary spotlight
    paint.shader = RadialGradient(
      colors: [
        color.withValues(alpha: 0.15),
        Colors.transparent,
      ],
      stops: const [0.0, 0.6],
    ).createShader(Rect.fromCircle(center: mousePos, radius: 600));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // 2. Ambient secondary glow
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
      oldDelegate.mousePos != mousePos;
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
      ..color = const Color(0xFF00F0FF).withValues(alpha: 0.05)
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

// --- SECTIONS ---

class _HeroSection extends StatelessWidget {
  const _HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 800;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // LEFT SIDE: INFO
              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "FLUTTER DEVELOPER & ARCHITECT",
                      style: GoogleFonts.robotoMono(
                        color: const Color(0xFF00F0FF),
                        fontSize: 14,
                        letterSpacing: 2,
                      ),
                    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1),

                    const SizedBox(height: 20),

                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.syne(
                          fontSize: isWide ? 100 : 60, 
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 0.9,
                          letterSpacing: -2,
                        ),
                        children: [
                          const TextSpan(text: "ASHIM\n"),
                          TextSpan(
                            text: "SAPKOTA.",
                            style: GoogleFonts.syne(
                              fontSize: isWide ? 100 : 60,
                              fontWeight: FontWeight.w800,
                              color: Colors.transparent, // Outline effect
                              height: 0.9,
                              letterSpacing: -2,
                              shadows: [],
                              decoration: TextDecoration.none,
                            ).copyWith(
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 2
                                ..color = Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 200.ms).moveY(begin: 20, end: 0, duration: 800.ms, curve: Curves.easeOutExpo),

                    const SizedBox(height: 40),

                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Text(
                        "I build pixel-perfect, fluid mobile experiences. Currently crafting high-performance applications at F1Soft. Obsessed with micro-interactions and clean architecture.",
                        style: GoogleFonts.outfit(
                          color: Colors.white60,
                          fontSize: 20,
                          height: 1.6,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ).animate().fadeIn(delay: 400.ms),

                    const SizedBox(height: 60),

                    const GithubContributions(),
                  ],
                ),
              ),
              
              if (isWide) const SizedBox(width: 40),

              // RIGHT SIDE: LINKS (Balancing the page)
              if (isWide)
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _SocialLinkLarge(label: "GITHUB", url: "https://github.com/ashimsap"),
                      const SizedBox(height: 20),
                      _SocialLinkLarge(label: "LINKEDIN", url: "https://www.linkedin.com/in/ashimsapkota"),
                      const SizedBox(height: 20),
                      _SocialLinkLarge(label: "GMAIL", url: "mailto:ashimsapkota1@gmail.com"),
                      const SizedBox(height: 20),
                      _SocialLinkLarge(label: "FACEBOOK", url: "https://facebook.com/ashimsap"),
                    ],
                  ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.2),
                ),
            ],
          );
        }
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
        description: "Nepal's premier map-based rental platform.",
        details: "A completed Flutter + Firebase project for the Nepali market. Users can browse listings on a map, see rental places around them, and use a trust-based verification workflow (Phone + optional owner consent/OTP). It uses Mapbox for maps & location.",
        color: const Color(0xFF00F0FF),
        url: "https://github.com/ashimsap/basobaas_map",
        deviceType: DeviceType.mobile,
        imageAsset: "assets/ss/basobas ss 1.jpg", 
      ),
      _ProjectData(
        title: "Stream Deck",
        tags: ["Linux", "WebSocket", "Dart"],
        description: "Custom hardware interface control.",
        details: "A custom Stream Deck alternative where the server runs on Manjaro Linux and the UI is controlled by a Flutter mobile client. It lets you trigger commands/actions on your computer from your phone using real-time WebSocket communication.",
        color: const Color(0xFF7000FF),
        url: "https://github.com/ashimsap/deck",
        deviceType: DeviceType.mobileLandscape, // Changed to mobileLandscape
        imageAsset: "assets/ss/deck screenshot 1.jpg", 
      ),
      _ProjectData(
        title: "Code Vault",
        tags: ["Server-Side Dart", "LAN"],
        description: "Mobile-hosted snippet manager.",
        details: "A code snippet vault where the mobile app itself hosts a server. You can connect over the local LAN from any browser and access your saved code snippets. It shows creative engineering by embedding local server logic inside a mobile app.",
        color: const Color(0xFF00FF9D),
        url: "https://github.com/ashimsap/code_vault",
        deviceType: DeviceType.mobile,
        imageAsset: "assets/ss/codevault ss 1.jpg", 
      ),
       _ProjectData(
        title: "To-Do App",
        tags: ["Flutter", "Hive"],
        description: "Everyday productivity task manager.",
        details: "A To-Do list application built using Flutter. It helps the user add, edit, mark complete/incomplete, and delete tasks. Uses local storage (Hive) and clean UI for task input and listing.",
        color: const Color(0xFFFF0055),
        url: "https://github.com/ashimsap/to_do",
        deviceType: DeviceType.mobile,
        // No asset, will fallback to custom Generated UI
      ),
      _ProjectData(
        title: "Dummy App",
        tags: ["R&D", "Packages"],
        description: "Experimental sandbox.",
        details: "A practice project and experimental app. It is a sandbox where I try new Flutter widgets, layouts, animations, or features. It demonstrates continuous learning and exploration of the framework.",
        color: Colors.amberAccent,
        url: "https://github.com/ashimsap/dummy_app",
        deviceType: DeviceType.mobile,
        isIconMode: true, 
      ),
    ];

    return Container(
      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: "SELECTED WORKS"),
          const SizedBox(height: 80),
          
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: projects.length,
            separatorBuilder: (c, i) => const SizedBox(height: 100),
            itemBuilder: (context, index) {
              return _GodTierProjectCard(
                project: projects[index], 
                index: index,
                isReversed: index % 2 != 0, 
              );
            },
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
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: "EXPERIENCE"),
          const SizedBox(height: 40),
          _GlassExperienceCard(),
          const SizedBox(height: 100),
          _SectionTitle(title: "ARSENAL"),
          const SizedBox(height: 40),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _BigSkillCard("Flutter", Icons.flutter_dash, const Color(0xFF00F0FF)),
              _BigSkillCard("Dart", Icons.code, const Color(0xFF00C8FF)),
              _BigSkillCard("Riverpod", Icons.waves, const Color(0xFF7000FF)),
              _BigSkillCard("Firebase", Icons.local_fire_department, const Color(0xFFFF5F57)),
              _BigSkillCard("Linux", Icons.terminal, const Color(0xFFFEBC2E)),
              _BigSkillCard("Git", Icons.merge_type, const Color(0xFFF05033)),
              _BigSkillCard("REST API", Icons.api, const Color(0xFF28C840)),
              _BigSkillCard("CI/CD", Icons.build, const Color(0xFF00FF9D)),
            ],
          ),
        ],
      ),
    );
  }
}

// --- GOD TIER COMPONENTS ---

class _GodTierProjectCard extends StatefulWidget {
  final _ProjectData project;
  final int index;
  final bool isReversed;

  const _GodTierProjectCard({
    required this.project, 
    required this.index,
    required this.isReversed
  });

  @override
  State<_GodTierProjectCard> createState() => _GodTierProjectCardState();
}

class _GodTierProjectCardState extends State<_GodTierProjectCard> {
  bool isHovered = false;

  void _showDetails() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: BlurBox(
            blur: 20,
            color: Colors.black.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: widget.project.color.withValues(alpha: 0.5)),
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.project.title, style: GoogleFonts.syne(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Text(widget.project.details, style: GoogleFonts.outfit(color: Colors.white70, fontSize: 18, height: 1.5)),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (widget.project.url != null)
                      TextButton.icon(
                        onPressed: () => launchUrl(Uri.parse(widget.project.url!)),
                        icon: Icon(Icons.code, color: widget.project.color),
                        label: Text("VIEW REPO", style: GoogleFonts.robotoMono(color: widget.project.color)),
                      ),
                    const SizedBox(width: 20),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("CLOSE", style: GoogleFonts.robotoMono(color: Colors.white54)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Added Gesture Detector here
      onTap: _showDetails, // Trigger the dialog on click
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        cursor: SystemMouseCursors.click, // Change cursor to indicate clickability
        child: Row(
          textDirection: widget.isReversed ? TextDirection.rtl : TextDirection.ltr,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. The Visual (Device Frame)
            Expanded(
              flex: 6,
              child: Center(
                child: AnimatedScale(
                  scale: isHovered ? 1.02 : 1.0,
                  duration: 500.ms,
                  curve: Curves.easeOutExpo,
                  child: _DeviceFrame(
                    asset: widget.project.imageAsset,
                    type: widget.project.deviceType,
                    accentColor: widget.project.color,
                    isIconMode: widget.project.isIconMode,
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 60),

            // 2. The Info
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: widget.isReversed ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    "0${widget.index + 1}",
                    style: GoogleFonts.robotoMono(
                      color: widget.project.color,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.project.title,
                    style: GoogleFonts.syne(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.0,
                    ),
                    textAlign: widget.isReversed ? TextAlign.right : TextAlign.left,
                  ),
                  const SizedBox(height: 20),
                  
                  // Description and Hover-Revealed Details
                  AnimatedCrossFade(
                    duration: 300.ms,
                    crossFadeState: isHovered ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                    firstChild: Text(
                      widget.project.description,
                      style: GoogleFonts.outfit(
                        color: Colors.white60,
                        fontSize: 18,
                        height: 1.5,
                      ),
                      textAlign: widget.isReversed ? TextAlign.right : TextAlign.left,
                    ),
                    secondChild: Column(
                      crossAxisAlignment: widget.isReversed ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.project.details,
                          style: GoogleFonts.outfit(
                            color: Colors.white, // Brighter text on hover
                            fontSize: 16,
                            height: 1.6,
                          ),
                          textAlign: widget.isReversed ? TextAlign.right : TextAlign.left,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                  Wrap(
                    alignment: widget.isReversed ? WrapAlignment.end : WrapAlignment.start,
                    spacing: 10,
                    children: widget.project.tags.map((t) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white12),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(t, style: GoogleFonts.robotoMono(color: Colors.white70, fontSize: 12)),
                    )).toList(),
                  ),
                  const SizedBox(height: 40),
                  
                  // ACTION BUTTONS
                  Row(
                    mainAxisAlignment: widget.isReversed ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      // Button: VIEW REPO
                      GestureDetector(
                        onTap: () => widget.project.url != null ? launchUrl(Uri.parse(widget.project.url!)) : null,
                        child: AnimatedContainer(
                          duration: 200.ms,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: isHovered ? widget.project.color : Colors.transparent,
                            border: Border.all(color: widget.project.color),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "VIEW REPO",
                                style: GoogleFonts.robotoMono(
                                  color: isHovered ? Colors.black : widget.project.color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.arrow_outward, 
                                   size: 16, 
                                   color: isHovered ? Colors.black : widget.project.color),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeviceFrame extends StatelessWidget {
  final String? asset;
  final DeviceType type;
  final Color accentColor;
  final bool isIconMode;

  const _DeviceFrame({
    required this.asset,
    required this.type,
    required this.accentColor,
    this.isIconMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = type == DeviceType.mobile;
    final isLandscape = type == DeviceType.mobileLandscape;
    final isLaptop = type == DeviceType.laptop;
    
    double width, height;
    
    if (isLandscape) {
      width = 440;
      height = 220;
    } else if (isMobile) {
      width = 220;
      height = 440;
    } else {
      width = 500;
      height = 320;
    }
    
    Widget frame = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(isLaptop ? 12 : 32),
        border: Border.all(
          color: const Color(0xFF222222), 
          width: isLaptop ? 12 : 8, 
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.1),
            blurRadius: 60,
            spreadRadius: -10,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isLaptop ? 6 : 24),
        child: Stack(
          children: [
            if (isIconMode)
               Container(
                color: const Color(0xFF050505),
                child: Center(
                  child: asset != null 
                    ? Image.asset(asset!, width: 80, height: 80)
                    : const FlutterLogo(size: 80),
                ),
              )
            else if (asset != null)
              Image.asset(
                asset!,
                fit: BoxFit.cover,
                width: double.infinity, 
                height: double.infinity,
                errorBuilder: (c, o, s) => Container(
                  color: const Color(0xFF1A1A1A),
                  child: const Center(child: Icon(Icons.broken_image, color: Colors.white10)),
                ),
              )
            else 
              // GENERATED UI FALLBACK (For To-Do App)
              Container(
                color: const Color(0xFF151515),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Container(height: 20, width: 100, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(4))),
                    const SizedBox(height: 30),
                    // Fake List Items
                    for (int i=0; i<4; i++)
                      Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        height: 40,
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Container(width: 15, height: 15, decoration: BoxDecoration(border: Border.all(color: Colors.white24), shape: BoxShape.circle)),
                            const SizedBox(width: 10),
                            Container(width: 80, height: 8, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(2))),
                          ],
                        ),
                      )
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
      frame = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 24,
            width: 524,
            decoration: const BoxDecoration(
              color: Color(0xFF222222),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 15),
                _WindowDot(color: const Color(0xFFFF5F57)),
                const SizedBox(width: 8),
                _WindowDot(color: const Color(0xFFFEBC2E)),
                const SizedBox(width: 8),
                _WindowDot(color: const Color(0xFF28C840)),
              ],
            ),
          ),
          frame,
        ],
      );
    }

    return frame
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .moveY(begin: 0, end: -15, duration: 4.seconds, curve: Curves.easeInOutQuad); 
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

class _GlassExperienceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("F1Soft International", style: GoogleFonts.syne(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  Text("2023 - Present", style: GoogleFonts.robotoMono(color: Colors.white54)),
                ],
              ),
              const SizedBox(height: 10),
              Text("App Development Intern", style: GoogleFonts.robotoMono(color: const Color(0xFF00F0FF))),
              const SizedBox(height: 20),
              Text(
                "Contributing to the development of Nepal's leading fintech solutions. Bridging the gap between complex backend logic and fluid frontend experiences.",
                style: GoogleFonts.outfit(color: Colors.white70, fontSize: 16, height: 1.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- BIG SKILL CARD (ARSENAL) ---
class _BigSkillCard extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _BigSkillCard(this.label, this.icon, this.color);

  @override
  State<_BigSkillCard> createState() => _BigSkillCardState();
}

class _BigSkillCardState extends State<_BigSkillCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: 200.ms,
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          color: isHovered ? widget.color.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isHovered ? widget.color.withValues(alpha: 0.5) : Colors.white10,
            width: 1.5
          ),
          boxShadow: isHovered ? [
            BoxShadow(color: widget.color.withValues(alpha: 0.2), blurRadius: 20)
          ] : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, size: 48, color: isHovered ? widget.color : Colors.white54)
                .animate(target: isHovered ? 1 : 0)
                .scale(end: const Offset(1.1, 1.1), duration: 200.ms),
            const SizedBox(height: 16),
            Text(
              widget.label,
              style: GoogleFonts.robotoMono(
                color: isHovered ? Colors.white : Colors.white54,
                fontWeight: FontWeight.bold,
                fontSize: 14
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialLinkLarge extends StatefulWidget {
  final String label;
  final String url;
  const _SocialLinkLarge({required this.label, required this.url});

  @override
  State<_SocialLinkLarge> createState() => _SocialLinkLargeState();
}

class _SocialLinkLargeState extends State<_SocialLinkLarge> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.url)),
        child: AnimatedContainer(
          duration: 200.ms,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: isHovered ? const Color(0xFF00F0FF) : Colors.transparent,
                width: 4
              )
            )
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.syne(
              color: isHovered ? const Color(0xFF00F0FF) : Colors.white30,
              fontSize: 32, // Large and bold
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title, 
      style: GoogleFonts.robotoMono(
        color: Colors.white24, 
        fontSize: 14, 
        letterSpacing: 4
      )
    );
  }
}

// --- Custom Side Navigation ---

class _CustomSideNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const _CustomSideNav({required this.selectedIndex, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 800;
    return Container(
      width: isSmallScreen ? 80 : 120,
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _NavItem(icon: Icons.person_outline, index: 0, isSelected: selectedIndex == 0, onTap: () => onItemSelected(0)),
          const SizedBox(height: 40),
          _NavItem(icon: Icons.grid_view_rounded, index: 1, isSelected: selectedIndex == 1, onTap: () => onItemSelected(1)),
          const SizedBox(height: 40),
          _NavItem(icon: Icons.bar_chart_rounded, index: 2, isSelected: selectedIndex == 2, onTap: () => onItemSelected(2)),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.index, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final activeColor = const Color(0xFF00F0FF);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: 300.ms,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border(right: BorderSide(color: isSelected ? activeColor : Colors.transparent, width: 2)),
          ),
          child: Icon(icon, color: isSelected ? activeColor : Colors.white24, size: 28)
              .animate(target: isSelected ? 1 : 0)
              .scale(begin: const Offset(1,1), end: const Offset(1.2, 1.2), duration: 200.ms),
        ),
      ),
    );
  }
}

class _FloatingBadge extends StatelessWidget {
  const _FloatingBadge();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(children: [
        const Icon(Icons.bolt, color: Color(0xFF00F0FF), size: 14),
        const SizedBox(width: 6),
        Text("FLUTTER POWERED", style: GoogleFonts.robotoMono(color: Colors.white54, fontSize: 10)),
      ]),
    );
  }
}

// Data Model
class _ProjectData {
  final String title;
  final List<String> tags;
  final String description;
  final String details;
  final Color color;
  final String? url;
  final String? imageAsset;
  final DeviceType deviceType;
  final bool isIconMode;

  _ProjectData({
    required this.title,
    required this.tags,
    required this.description,
    required this.details,
    required this.color,
    this.url,
    this.imageAsset,
    this.deviceType = DeviceType.mobile,
    this.isIconMode = false,
  });
}
