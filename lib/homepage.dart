import 'dart:ui';

import 'package:blurbox/blurbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:url_launcher/url_launcher.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _scrollController = ScrollController();
  final _key = GlobalKey<ScaffoldState>();

  // Keys to track section positions
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
    _controller.dispose();
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

      // Get position relative to the top of the screen
      final position = box.localToGlobal(Offset.zero);

      // We want the section that is closest to the top (0)
      // but biased slightly towards the one occupying the screen (dy <= 100)
      final diff = position.dy.abs();

      if (diff < minDiff) {
        minDiff = diff;
        targetIndex = i;
      }
    }

    if (_controller.selectedIndex != targetIndex) {
      _controller.selectIndex(targetIndex);
    }
  }

  void _scrollTo(int index) {
    _isSyncing = true;
    _controller.selectIndex(index);
    final context = _sectionKeys[index].currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: 800.ms,
        curve: Curves.easeInOutQuart,
        alignment: 0.0, // Scroll to top
      ).then((_) => _isSyncing = false);
    } else {
      _isSyncing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 800;
    _controller.setExtended(!isSmallScreen);

    return Scaffold(
      key: _key,
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // Background Elements
          const _BackgroundOrbs(),
          
          // Main Content
          Row(
            children: [
              // Sidebar
              SidebarX(
                controller: _controller,
                showToggleButton: false,
                theme: SidebarXTheme(
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    border: Border(right: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
                  ),
                  margin: const EdgeInsets.all(10),
                  itemPadding: const EdgeInsets.all(10),
                  selectedItemPadding: const EdgeInsets.all(10),
                  itemTextPadding: const EdgeInsets.only(left: 10),
                  selectedItemTextPadding: const EdgeInsets.only(left: 10),
                  textStyle: const TextStyle(color: Colors.white60),
                  selectedTextStyle: const TextStyle(
                      color: Color(0xFF00F0FF), fontWeight: FontWeight.bold),
                  iconTheme: const IconThemeData(color: Colors.white60, size: 20),
                  selectedIconTheme:
                      const IconThemeData(color: Color(0xFF00F0FF), size: 24),
                  itemDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  selectedItemDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFF00F0FF).withValues(alpha: 0.1),
                    border: Border.all(
                        color: const Color(0xFF00F0FF).withValues(alpha: 0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00F0FF).withValues(alpha: 0.2),
                        blurRadius: 10,
                      )
                    ]
                  ),
                ),
                extendedTheme: SidebarXTheme(
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    border: Border(right: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
                  ),
                ),
                items: [
                  SidebarXItem(
                    icon: Icons.person_outline,
                    label: 'Profile',
                    onTap: () => _scrollTo(0),
                  ),
                  SidebarXItem(
                    icon: Icons.code_rounded,
                    label: 'Projects',
                    onTap: () => _scrollTo(1),
                  ),
                  SidebarXItem(
                    icon: Icons.bar_chart_rounded,
                    label: 'Skills',
                    onTap: () => _scrollTo(2),
                  ),
                ],
              ),
              
              // Scrollable Content
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

          // Floating "Made with Flutter" Badge
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

// --- Background Animation ---

class _BackgroundOrbs extends StatelessWidget {
  const _BackgroundOrbs();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Cyan Orb
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

        // Purple Orb
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

        // Center Subtle Glow
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

// --- Floating Badge ---

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

// --- Sections ---

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
            // Avatar with Neon Glow
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
                // Fallback to icon if image is missing
                 image: const DecorationImage(
                   image: AssetImage('assets/avatar.jpg'),
                   fit: BoxFit.cover,
                 ),
              ),
            )
            .animate()
            .fadeIn(duration: 800.ms)
            .scale(delay: 200.ms, curve: Curves.easeOutBack)
            .shimmer(delay: 1.seconds, duration: 2.seconds, color: const Color(0xFF00F0FF)),

            const SizedBox(height: 40),

            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.outfit(
                  fontSize: 56,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1,
                  height: 1.1
                ),
                children: const [
                  TextSpan(text: "ASHIM "),
                  TextSpan(
                    text: "SAPKOTA",
                    style: TextStyle(color: Color(0xFF00F0FF)), // Neon Cyan
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),

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

            const _GithubContributions(),

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

class _GithubContributions extends StatelessWidget {
  const _GithubContributions();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "CONTRIBUTIONS", 
          style: GoogleFonts.robotoMono(color: Colors.white54, fontSize: 12, letterSpacing: 2)
        ),
        const SizedBox(height: 15),
        Container(
          height: 180,
          constraints: const BoxConstraints(maxWidth: 800),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF00F0FF).withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(color: const Color(0xFF00F0FF).withValues(alpha: 0.05), blurRadius: 20)
            ]
          ),
          padding: const EdgeInsets.all(16),
          child: Image.network(
            "https://grass-graph.moshimo.works/images/ashimsap.png?background=none",
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(color: Color(0xFF00F0FF)),
              );
            },
            errorBuilder: (context, error, stackTrace) {
               return Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Icon(Icons.error_outline, color: Colors.white30, size: 40),
                   SizedBox(height: 10),
                   Text(
                     "Could not load GitHub chart",
                     style: GoogleFonts.robotoMono(color: Colors.white30, fontSize: 12),
                   ),
                   Text(
                     "Try checking your connection or GitHub username",
                     style: GoogleFonts.robotoMono(color: Colors.white12, fontSize: 10),
                   ),
                 ],
               );
            },
          ),
        ),
      ],
    ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.2);
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
        details:
            "Built with scalable logic for user trust and location verification.",
        color: const Color(0xFF00F0FF),
        url: "https://github.com/ashimsap/basobaas_map",
      ),
      _ProjectData(
        title: "Stream Deck System",
        tags: ["Linux", "WebSocket", "Dart"],
        description: "Custom hardware interface control via mobile.",
        details:
            "Real-time command execution bridge between Manjaro Linux and mobile devices.",
        color: const Color(0xFF7000FF),
        url: "https://github.com/ashimsap/deck",
      ),
      _ProjectData(
        title: "Code Vault",
        tags: ["Server-Side Dart", "LAN", "Utility"],
        description: "Secure code snippet manager on local network.",
        details:
            "Hosts a full server directly on the mobile device for team productivity.",
        color: const Color(0xFF00FF9D),
        url: "https://github.com/ashimsap/code_vault",
      ),
       _ProjectData(
        title: "To-Do App",
        tags: ["Flutter", "Hive", "Provider"],
        description: "A clean and efficient task management app.",
        details:
            "First major project exploring local storage and state management.",
        color: const Color(0xFFFF0055),
        url: "https://github.com/ashimsap/to_do",
      ),
      _ProjectData(
        title: "Dummy App",
        tags: ["Research", "Packages", "Refactoring"],
        description: "Sandbox for testing Flutter packages and patterns.",
        details:
            "Continuous refactoring and implementation of new Flutter features.",
        color: Colors.amberAccent,
        url: "https://github.com/ashimsap/dummy_app",
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
          const SizedBox(height: 40),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: projects.length,
            separatorBuilder: (c, i) => const SizedBox(height: 30),
            itemBuilder: (context, index) {
              final p = projects[index];
              return _ProjectCard(project: p, index: index);
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

class _ProjectCard extends StatefulWidget {
  final _ProjectData project;
  final int index;

  const _ProjectCard({required this.project, required this.index});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (widget.project.url != null) {
            launchUrl(Uri.parse(widget.project.url!));
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: isHovered 
                ? widget.project.color.withValues(alpha: 0.05) 
                : Colors.white.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isHovered
                  ? widget.project.color.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.05),
              width: 1,
            ),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                        color: widget.project.color.withValues(alpha: 0.1),
                        blurRadius: 30,
                        offset: const Offset(0, 10))
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.project.title,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "View Code", 
                        style: GoogleFonts.robotoMono(
                          color: isHovered ? widget.project.color : Colors.transparent, 
                          fontSize: 12
                        )
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_outward_rounded, 
                           color: isHovered ? widget.project.color : Colors.white30, size: 18),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Wrap(
                spacing: 10,
                children: widget.project.tags
                    .map((t) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: widget.project.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: widget.project.color.withValues(alpha: 0.2)
                            )
                          ),
                          child: Text(
                            t,
                            style: GoogleFonts.robotoMono(
                                color: widget.project.color,
                                fontSize: 11,
                                fontWeight: FontWeight.bold),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              Text(
                widget.project.description,
                style: GoogleFonts.outfit(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                widget.project.details,
                style: GoogleFonts.outfit(color: Colors.white38, fontSize: 14),
              ),
            ],
          ),
        ).animate().fadeIn(delay: (100 * widget.index).ms).slideY(begin: 0.2),
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlurBox(
      blur: 5,
      color: Colors.white.withValues(alpha: 0.02),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white10),
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

  _ProjectData({
    required this.title,
    required this.tags,
    required this.description,
    required this.details,
    required this.color,
    this.url,
  });
}
