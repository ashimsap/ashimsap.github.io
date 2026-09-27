import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/responsive/responsive_layout.dart';
import '../../core/theme/app_colors.dart';
import 'data/marketing_data.dart';
import 'models/marketing_model.dart';

class MarketingPage extends StatelessWidget {
  const MarketingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final pillars = MarketingData.pillars;
    final caseStudies = MarketingData.caseStudies;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: isMobile ? 30 : 60,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "GROW // DIGITAL MARKETING",
            style: GoogleFonts.robotoMono(
              color: AppColors.purple,
              fontSize: 13,
              letterSpacing: 3,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "AUDIENCE, STRATEGY & ANALYTICS",
            style: GoogleFonts.syne(
              fontSize: isMobile ? 28 : 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Combining technical product engineering with growth strategy, search engine optimization, and audience acquisition.",
            style: GoogleFonts.outfit(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 40),

          // 1. STRATEGY PILLARS GRID
          Text(
            "CORE MARKETING PILLARS",
            style: GoogleFonts.robotoMono(
              color: AppColors.textMuted,
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),

          isMobile
              ? Column(
                  children: pillars
                      .map((p) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _PillarCard(pillar: p),
                          ))
                      .toList(),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.8,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: pillars.length,
                  itemBuilder: (context, index) =>
                      _PillarCard(pillar: pillars[index]),
                ),

          const SizedBox(height: 60),

          // 2. EXPANDABLE MARKETING CASE STUDIES & WORKSPACE CARDS
          Text(
            "STRATEGY & CAMPAIGN CASE STUDIES",
            style: GoogleFonts.robotoMono(
              color: AppColors.textMuted,
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: caseStudies.length,
            separatorBuilder: (c, i) => const SizedBox(height: 24),
            itemBuilder: (context, index) {
              return _CaseStudyWorkspaceCard(study: caseStudies[index]);
            },
          ),

          const SizedBox(height: 60),
        ],
      ),
    );
  }
}

class _PillarCard extends StatefulWidget {
  final MarketingPillar pillar;
  const _PillarCard({required this.pillar});

  @override
  State<_PillarCard> createState() => _PillarCardState();
}

class _PillarCardState extends State<_PillarCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.pillar;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isHovered
              ? AppColors.purple.withValues(alpha: 0.08)
              : AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isHovered
                ? AppColors.purple.withValues(alpha: 0.5)
                : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(p.icon,
                    color: isHovered ? AppColors.purple : Colors.white70,
                    size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    p.title,
                    style: GoogleFonts.syne(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              p.subtitle,
              style: GoogleFonts.outfit(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: p.skills
                  .map((s) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.purple.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                              color: AppColors.purple.withValues(alpha: 0.2)),
                        ),
                        child: Text(
                          s,
                          style: GoogleFonts.robotoMono(
                            color: Colors.white.withValues(alpha: 0.87),
                            fontSize: 10,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CaseStudyWorkspaceCard extends StatefulWidget {
  final MarketingCaseStudy study;
  const _CaseStudyWorkspaceCard({required this.study});

  @override
  State<_CaseStudyWorkspaceCard> createState() =>
      _CaseStudyWorkspaceCardState();
}

class _CaseStudyWorkspaceCardState extends State<_CaseStudyWorkspaceCard> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final s = widget.study;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Workspace Header Bar
          InkWell(
            onTap: () => setState(() => isExpanded = !isExpanded),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: s.accentColor.withValues(alpha: 0.05),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                border: const Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: s.accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      s.title,
                      style: GoogleFonts.syne(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white60,
                  ),
                ],
              ),
            ),
          ),

          if (isExpanded)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionBlock(
                    label: "OBJECTIVE",
                    content: s.objective,
                    accentColor: s.accentColor,
                  ),
                  const SizedBox(height: 16),
                  _SectionBlock(
                    label: "APPROACH",
                    content: s.approach,
                    accentColor: s.accentColor,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _TagBlock(
                          label: "CHANNELS",
                          items: s.channels,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _TagBlock(
                          label: "TOOLS",
                          items: s.tools,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _TagBlock(
                    label: "METRICS & PERFORMANCE",
                    items: s.metrics,
                    isMetric: true,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "KEY LESSONS LEARNED",
                    style: GoogleFonts.robotoMono(
                      color: s.accentColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...s.keyLearnings.map((k) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("• ",
                                style: TextStyle(color: s.accentColor)),
                            Expanded(
                              child: Text(
                                k,
                                style: GoogleFonts.outfit(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  final String label;
  final String content;
  final Color accentColor;

  const _SectionBlock({
    required this.label,
    required this.content,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.robotoMono(
            color: accentColor,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _TagBlock extends StatelessWidget {
  final String label;
  final List<String> items;
  final bool isMetric;

  const _TagBlock({
    required this.label,
    required this.items,
    this.isMetric = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.robotoMono(
            color: AppColors.textMuted,
            fontSize: 10,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: items
              .map((i) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isMetric
                          ? AppColors.purple.withValues(alpha: 0.15)
                          : Colors.white.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isMetric ? AppColors.purple : Colors.white12,
                      ),
                    ),
                    child: Text(
                      i,
                      style: GoogleFonts.robotoMono(
                        color: isMetric ? AppColors.purple : Colors.white70,
                        fontSize: 11,
                        fontWeight:
                            isMetric ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
