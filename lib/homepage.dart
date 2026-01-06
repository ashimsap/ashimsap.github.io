import 'dart:ui';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:blurbox/blurbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class _GithubContributions extends StatefulWidget {
  const _GithubContributions();

  @override
  State<_GithubContributions> createState() => _GithubContributionsState();
}

class _GithubContributionsState extends State<_GithubContributions> {
  // Using the public API from github-contributions-api.jogruber.de
  // This helps us avoid CORS issues and needing a personal access token
  List<Map<String, dynamic>> _contributions = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchContributions();
  }

  Future<void> _fetchContributions() async {
    try {
      final response = await http.get(
        Uri.parse('https://github-contributions-api.jogruber.de/v4/ashimsap?y=last')
      );
      
      if (response.statusCode == 200) {
         final data = json.decode(response.body);
         // The API returns { "contributions": [ { "date": "...", "count": X, "level": Y }, ... ] }
         final List<dynamic> items = data['contributions'];
         
         if (mounted) {
           setState(() {
             _contributions = items.cast<Map<String, dynamic>>();
             _isLoading = false;
           });
         }
      } else {
        throw Exception("Failed to load");
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = "Could not fetch GitHub data";
          _isLoading = false;
        });
      }
    }
  }

  // Helper to check if two dates are in the same month
  bool _isSameMonth(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month;
  }

  String _monthName(int month) {
    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "CONTRIBUTIONS (LAST YEAR)", 
          style: GoogleFonts.robotoMono(color: Colors.white54, fontSize: 12, letterSpacing: 2)
        ),
        const SizedBox(height: 15),
        Container(
          constraints: const BoxConstraints(maxWidth: 900),
          decoration: BoxDecoration(
            color: const Color(0xFF0D1117), // GitHub dark background
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFF30363D)),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10)
            ]
          ),
          padding: const EdgeInsets.all(20),
          child: _isLoading 
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF39D353)))
            : _error != null 
              ? Center(child: Text(_error!, style: GoogleFonts.robotoMono(color: Colors.white30)))
              : LayoutBuilder(
                builder: (context, constraints) {
                  // We need to group flat list into weeks starting on Sunday.
                  if (_contributions.isEmpty) return const SizedBox();

                  final firstDate = DateTime.parse(_contributions.first['date']);
                  
                  // GitHub grid starts with Sunday at the top (index 0).
                  // If firstDate is e.g. Wednesday (weekday 3), we need 3 padding items before it (Sun, Mon, Tue).
                  // DateTime.weekday: Mon=1 ... Sun=7.
                  // We want Sun=0, Mon=1 ... Sat=6.
                  // So mapping:
                  // Sun(7) -> 0 padding
                  // Mon(1) -> 1 padding
                  // ...
                  // Sat(6) -> 6 padding
                  
                  int paddingCount = 0;
                  if (firstDate.weekday != 7) {
                    paddingCount = firstDate.weekday;
                  }
                  
                  final paddedContributions = [
                    ...List.generate(paddingCount, (_) => <String, dynamic>{'empty': true}),
                    ..._contributions
                  ];

                  // Calculate chunks of weeks (7 days per week)
                  final totalWeeks = (paddedContributions.length / 7).ceil();
                  final gap = 3.0;
                  
                  // Calculate dynamic size based on available width, reserving space for labels
                  final availableWidth = constraints.maxWidth - 30; // 30px for left labels
                  final calculatedSize = (availableWidth - (totalWeeks - 1) * gap) / totalWeeks;
                  final size = calculatedSize.clamp(4.0, 11.0);

                  // Track placed month labels to avoid duplicates
                  int lastLabelMonth = -1;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Graph with labels
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Day Labels Column (Mon, Wed, Fri)
                          // In 7-row column: Sun=0, Mon=1, Tue=2, Wed=3, Thu=4, Fri=5, Sat=6
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: size + gap + 20), // Top margin for month labels + Sun
                              _DayLabel(label: "Mon", height: size, gap: gap), // Index 1
                              SizedBox(height: size + gap), // Skip Tue
                              _DayLabel(label: "Wed", height: size, gap: gap), // Index 3
                              SizedBox(height: size + gap), // Skip Thu
                              _DayLabel(label: "Fri", height: size, gap: gap), // Index 5
                            ],
                          ),
                          const SizedBox(width: 5),
                          
                          // The Graph itself
                          Expanded(
                            child: SizedBox(
                              height: (size + gap) * 8 + 20, // 7 rows + label row
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: totalWeeks,
                                itemBuilder: (context, weekIndex) {
                                  final startIndex = weekIndex * 7;
                                  final endIndex = (startIndex + 7 > paddedContributions.length)
                                      ? paddedContributions.length
                                      : startIndex + 7;
                                  final weekDays = paddedContributions.sublist(startIndex, endIndex);
                                  
                                  // Determine month label for this column
                                  String? monthLabel;
                                  
                                  // Find the first *real* date in this week
                                  DateTime? firstRealDateInWeek;
                                  for (var day in weekDays) {
                                    if (day['empty'] != true) {
                                      firstRealDateInWeek = DateTime.parse(day['date']);
                                      break;
                                    }
                                  }

                                  // Logic: If this week contains the 1st day of a month (or close to it)
                                  // AND we haven't labeled this month recently.
                                  if (firstRealDateInWeek != null) {
                                     // Check if any day in this week is the 1st of the month
                                     // OR if it's the very first column and we want to show the starting month.
                                     bool startOfMonthInWeek = false;
                                     
                                     // Check specifically if the month changed from the previous week
                                     // But simpler: just check if 'day 1' exists in this week
                                     for(var day in weekDays) {
                                       if (day['empty'] != true) {
                                         final d = DateTime.parse(day['date']);
                                         if (d.day == 1) {
                                           startOfMonthInWeek = true;
                                           break;
                                         }
                                       }
                                     }

                                     // Special case: The very first column always gets a label
                                     if (weekIndex == 0) {
                                        monthLabel = _monthName(firstRealDateInWeek.month);
                                        lastLabelMonth = firstRealDateInWeek.month;
                                     } else if (startOfMonthInWeek) {
                                        // Only show if we haven't just shown it (weeks can overlap months, but 1st is unique)
                                        // Actually, if 1st is in this week, we definitely show it.
                                        final m = firstRealDateInWeek.month; // This might be prev month if 1st is later in week
                                        // Re-find the actual 1st day to get correct month
                                        int targetMonth = m;
                                        for(var day in weekDays) {
                                          if (day['empty'] != true) {
                                            final d = DateTime.parse(day['date']);
                                            if (d.day == 1) targetMonth = d.month;
                                          }
                                        }
                                        
                                        if (targetMonth != lastLabelMonth) {
                                          monthLabel = _monthName(targetMonth);
                                          lastLabelMonth = targetMonth;
                                        }
                                     }
                                  }

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Month Label Row
                                      SizedBox(
                                        height: 20,
                                        width: size + gap,
                                        child: (monthLabel != null)
                                          ? Text(monthLabel, 
                                              overflow: TextOverflow.visible,
                                              softWrap: false,
                                              style: GoogleFonts.roboto(color: const Color(0xFF8B949E), fontSize: 10))
                                          : null,
                                      ),
                                      
                                      // The 7 boxes
                                      ...weekDays.map((day) {
                                         if (day['empty'] == true) {
                                           return SizedBox(width: size, height: size + gap);
                                         }
                                      
                                         final level = day['level'] as int;
                                         Color color;
                                         switch (level) {
                                            case 1: color = const Color(0xFF0E4429); break;
                                            case 2: color = const Color(0xFF006D32); break;
                                            case 3: color = const Color(0xFF26A641); break;
                                            case 4: color = const Color(0xFF39D353); break;
                                            default: color = const Color(0xFF161B22);
                                         }
                  
                                         return Tooltip(
                                           message: "${day['date']}: ${day['count']} contributions",
                                           waitDuration: const Duration(milliseconds: 500),
                                           child: Container(
                                             width: size,
                                             height: size,
                                             margin: EdgeInsets.only(bottom: gap),
                                             decoration: BoxDecoration(
                                               color: color,
                                               borderRadius: BorderRadius.circular(2),
                                             ),
                                           ),
                                         );
                                      }),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 10),
                      
                      // Legend
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Less", style: GoogleFonts.roboto(color: const Color(0xFF8B949E), fontSize: 10)),
                          const SizedBox(width: 5),
                          _LegendSquare(color: const Color(0xFF161B22)),
                          _LegendSquare(color: const Color(0xFF0E4429)),
                          _LegendSquare(color: const Color(0xFF006D32)),
                          _LegendSquare(color: const Color(0xFF26A641)),
                          _LegendSquare(color: const Color(0xFF39D353)),
                          const SizedBox(width: 5),
                          Text("More", style: GoogleFonts.roboto(color: const Color(0xFF8B949E), fontSize: 10)),
                        ],
                      )
                    ],
                  );
                }
              ),
        ),
      ],
    ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.2);
  }
}

class _DayLabel extends StatelessWidget {
  final String label;
  final double height;
  final double gap;

  const _DayLabel({required this.label, required this.height, required this.gap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.only(bottom: gap),
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: GoogleFonts.roboto(color: const Color(0xFF8B949E), fontSize: 9),
      ),
    );
  }
}

class _LegendSquare extends StatelessWidget {
  final Color color;
  const _LegendSquare({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
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
