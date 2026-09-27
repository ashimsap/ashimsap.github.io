import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/navigation_provider.dart';
import '../../core/responsive/responsive_layout.dart';
import '../../core/theme/app_colors.dart';
import '../github/github_contributions.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 60,
        vertical: isMobile ? 24 : 60,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. HERO HEADER
          _buildHeroHeader(context, isMobile),

          const SizedBox(height: 40),

          // 2. BUILD / GROW / OPERATE GATEWAY TRIAD
          Text(
            "DIGITAL ECOSYSTEM",
            style: GoogleFonts.robotoMono(
              color: AppColors.textMuted,
              fontSize: 12,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 16),

          _buildGatewayCards(context, ref, isMobile),

          const SizedBox(height: 50),

          // 3. GITHUB ACTIVITY GRAPH
          const GithubContributions(),

          const SizedBox(height: 50),

          // 4. EXPERIENCE BRIEF
          _buildExperienceBrief(context, isMobile),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context, bool isMobile) {
    final screenWidth = MediaQuery.of(context).size.width;
    final heroFontSize =
        screenWidth < 360 ? 36.0 : (screenWidth < 480 ? 44.0 : (isMobile ? 56.0 : 84.0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Responsive Header Badges (Wraps cleanly on narrow screens < 380px)
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 10,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.cyan.withValues(alpha: 0.1),
                border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "FLUTTER DEVELOPER & DIGITAL ARCHITECT",
                style: GoogleFonts.robotoMono(
                  color: AppColors.cyan,
                  fontSize: screenWidth < 360 ? 9 : (isMobile ? 10 : 12),
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Floating Status Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "BUILDING & LEARNING",
                    style: GoogleFonts.robotoMono(
                      color: Colors.white60,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ).animate().fadeIn(duration: 500.ms),

        const SizedBox(height: 20),

        RichText(
          text: TextSpan(
            style: GoogleFonts.syne(
              fontSize: heroFontSize,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 0.95,
              letterSpacing: -1.5,
            ),
            children: [
              const TextSpan(text: "ASHIM\n"),
              TextSpan(
                text: "SAPKOTA.",
                style: GoogleFonts.syne(
                  fontSize: heroFontSize,
                  fontWeight: FontWeight.w800,
                  color: Colors.transparent,
                  height: 0.95,
                  letterSpacing: -1.5,
                ).copyWith(
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = screenWidth < 360 ? 1.5 : 2.0
                    ..color = Colors.white.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms).moveY(begin: 15, end: 0),

        const SizedBox(height: 20),

        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Text(
            "Software builder crafting cross-platform applications with Flutter, digital marketer executing creative campaigns, and Linux/infrastructure explorer building toward DevOps.",
            style: GoogleFonts.outfit(
              color: AppColors.textSecondary,
              fontSize: screenWidth < 360 ? 14 : (isMobile ? 15 : 18),
              height: 1.5,
              fontWeight: FontWeight.w300,
            ),
          ),
        ).animate().fadeIn(delay: 400.ms),

        const SizedBox(height: 24),

        // Social Link Buttons Row
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: const [
            _SocialChip(
              label: "GitHub",
              icon: Icons.code,
              url: "https://github.com/ashimsap",
            ),
            _SocialChip(
              label: "LinkedIn",
              icon: Icons.work_outline,
              url: "https://www.linkedin.com/in/ashim-sapkota-7792552a4/",
            ),
            _SocialChip(
              label: "Email",
              icon: Icons.email_outlined,
              url: "mailto:ashimsap@gmail.com",
            ),
          ],
        ).animate().fadeIn(delay: 500.ms),
      ],
    );
  }

  Widget _buildGatewayCards(
      BuildContext context, WidgetRef ref, bool isMobile) {
    final gateways = [
      _GatewayItem(
        title: "BUILD",
        subtitle: "DEVELOPMENT",
        description:
            "Cross-platform mobile apps, embedded local servers & map engines.",
        color: AppColors.cyan,
        icon: Icons.code_rounded,
        targetIndex: 1,
        tags: ["Flutter", "Dart", "Firebase", "WebSockets"],
      ),
      _GatewayItem(
        title: "GROW",
        subtitle: "DIGITAL MARKETING",
        description:
            "Graphic design, short-form video editing, Meta ads & social campaigns.",
        color: AppColors.purple,
        icon: Icons.trending_up_rounded,
        targetIndex: 2,
        tags: ["Graphic Design", "Meta Ads", "Reels", "Email / SMS"],
      ),
      _GatewayItem(
        title: "OPERATE",
        subtitle: "DEVOPS & INFRASTRUCTURE",
        description:
            "Primary Linux workstation, self-hosted Jellyfin server & GitHub Actions.",
        color: AppColors.green,
        icon: Icons.terminal_rounded,
        targetIndex: 3,
        tags: ["Linux", "Self-Hosting", "Nginx", "GitHub Actions"],
      ),
    ];

    if (isMobile) {
      return Column(
        children: gateways
            .map((g) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _GatewayCard(item: g, ref: ref),
                ))
            .toList(),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: gateways
          .map((g) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: _GatewayCard(item: g, ref: ref),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildExperienceBrief(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "PROFESSIONAL EXPERIENCE SUMMARY",
          style: GoogleFonts.robotoMono(
            color: AppColors.textMuted,
            fontSize: 12,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(isMobile ? 16 : 28),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Enlighten Infosys
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 4,
                children: [
                  Text(
                    "Enlighten Infosys",
                    style: GoogleFonts.syne(
                      color: Colors.white,
                      fontSize: isMobile ? 18 : 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "May 2026 – Present",
                    style: GoogleFonts.robotoMono(
                      color: AppColors.purple,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                "Digital Marketing",
                style: GoogleFonts.robotoMono(
                  color: AppColors.purple,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Graphic design (Canva, Photoshop), short-form reel video editing & color grading, Meta ads management, social platform scheduling, direct Email/SMS campaigns, and KPI analytics.",
                style: GoogleFonts.outfit(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(color: Colors.white10),
              ),

              // 2. F1Soft International
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 4,
                children: [
                  Text(
                    "F1Soft International",
                    style: GoogleFonts.syne(
                      color: Colors.white,
                      fontSize: isMobile ? 18 : 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Dec 2025 - Feb 2026",
                    style: GoogleFonts.robotoMono(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                "App Development Intern",
                style: GoogleFonts.robotoMono(
                  color: AppColors.cyan,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Contributed to mobile fintech workflows in Nepal. Worked on bridging backend service endpoints with responsive, fluid mobile UI components.",
                style: GoogleFonts.outfit(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GatewayCard extends StatefulWidget {
  final _GatewayItem item;
  final WidgetRef ref;

  const _GatewayCard({required this.item, required this.ref});

  @override
  State<_GatewayCard> createState() => _GatewayCardState();
}

class _GatewayCardState extends State<_GatewayCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.item.color;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          widget.ref.read(navigationIndexProvider.notifier).state =
              widget.item.targetIndex;
        },
        child: AnimatedContainer(
          duration: 200.ms,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isHovered
                ? color.withValues(alpha: 0.08)
                : Colors.white.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isHovered
                  ? color.withValues(alpha: 0.6)
                  : Colors.white.withValues(alpha: 0.08),
              width: 1.5,
            ),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.15),
                      blurRadius: 20,
                      spreadRadius: -2,
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(widget.item.icon,
                      color: isHovered ? color : Colors.white60, size: 26),
                  Icon(Icons.arrow_forward_rounded,
                      color: isHovered ? color : Colors.white24, size: 18),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.item.title,
                style: GoogleFonts.syne(
                  color: isHovered ? color : Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                widget.item.subtitle,
                style: GoogleFonts.robotoMono(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.item.description,
                style: GoogleFonts.outfit(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: widget.item.tags
                    .map((t) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.04),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Text(
                            t,
                            style: GoogleFonts.robotoMono(
                              color: Colors.white60,
                              fontSize: 10,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GatewayItem {
  final String title;
  final String subtitle;
  final String description;
  final Color color;
  final IconData icon;
  final int targetIndex;
  final List<String> tags;

  _GatewayItem({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.color,
    required this.icon,
    required this.targetIndex,
    required this.tags,
  });
}

class _SocialChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final String url;

  const _SocialChip({
    required this.label,
    required this.icon,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse(url)),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: AppColors.cyan),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.robotoMono(
                color: Colors.white.withValues(alpha: 0.87),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
