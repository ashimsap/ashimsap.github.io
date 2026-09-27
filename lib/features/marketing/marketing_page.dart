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
    final experience = MarketingData.enlightenExperience;
    final pillars = MarketingData.pillars;
    final archiveItems = MarketingData.archivePlaceholders;

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
            "CREATIVE, CONTENT & CAMPAIGNS",
            style: GoogleFonts.syne(
              fontSize: isMobile ? 28 : 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Graphic design, short-form video editing, Meta paid ads, social media management, email/SMS campaigns, and KPI analytics.",
            style: GoogleFonts.outfit(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 40),

          // 1. PROFESSIONAL EXPERIENCE CARD
          _buildProfessionalExperienceCard(context, experience, isMobile),

          const SizedBox(height: 50),

          // 2. VISUAL GROWTH PIPELINE: CREATE -> PUBLISH -> PROMOTE -> MEASURE
          Text(
            "GROWTH FRAMEWORK & CAPABILITIES",
            style: GoogleFonts.robotoMono(
              color: AppColors.textMuted,
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),

          _buildPipelineHeader(context, isMobile),

          const SizedBox(height: 20),

          // 3. MEDIA & CAPABILITY CARDS
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
                    crossAxisCount: 3,
                    childAspectRatio: 1.15,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: pillars.length,
                  itemBuilder: (context, index) =>
                      _PillarCard(pillar: pillars[index]),
                ),

          const SizedBox(height: 60),

          // 4. CREATIVE ARCHIVE / MARKETING GALLERY STRUCTURE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "CREATIVE ARCHIVE & GALLERY",
                style: GoogleFonts.robotoMono(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.purple.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.purple.withValues(alpha: 0.3)),
                ),
                child: Text(
                  "ARCHITECTURE READY FOR MEDIA",
                  style: GoogleFonts.robotoMono(
                    color: AppColors.purple,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildCreativeArchiveSection(context, archiveItems, isMobile),

          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildProfessionalExperienceCard(
      BuildContext context, ProfessionalExperienceModel exp, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 32),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.purple.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: AppColors.purple.withValues(alpha: 0.08),
            blurRadius: 30,
            spreadRadius: -5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.purple.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.purple),
                ),
                child: Text(
                  "PROFESSIONAL EXPERIENCE",
                  style: GoogleFonts.robotoMono(
                    color: AppColors.purple,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                exp.period,
                style: GoogleFonts.robotoMono(
                  color: AppColors.purple,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            exp.role,
            style: GoogleFonts.syne(
              color: Colors.white,
              fontSize: isMobile ? 22 : 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            exp.company,
            style: GoogleFonts.robotoMono(
              color: AppColors.cyan,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            exp.overview,
            style: GoogleFonts.outfit(
              color: AppColors.textSecondary,
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),

          // Capabilities Breakdown Grid
          isMobile
              ? Column(
                  children: exp.capabilities.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _CapabilityBlock(
                        title: entry.key,
                        items: entry.value,
                      ),
                    );
                  }).toList(),
                )
              : Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: exp.capabilities.entries.map((entry) {
                    return SizedBox(
                      width: (MediaQuery.of(context).size.width - 200) / 3,
                      child: _CapabilityBlock(
                        title: entry.key,
                        items: entry.value,
                      ),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildPipelineHeader(BuildContext context, bool isMobile) {
    final stages = ["CREATE", "PUBLISH", "PROMOTE", "MEASURE"];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.purple.withValues(alpha: 0.3)),
      ),
      child: isMobile
          ? Column(
              children: stages
                  .map((s) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          s,
                          style: GoogleFonts.robotoMono(
                            color: AppColors.purple,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ))
                  .toList(),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(stages.length, (index) {
                return Row(
                  children: [
                    Text(
                      stages[index],
                      style: GoogleFonts.robotoMono(
                        color: AppColors.purple,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    if (index < stages.length - 1)
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Icon(Icons.arrow_forward_rounded,
                            color: AppColors.purple.withValues(alpha: 0.5), size: 16),
                      ),
                  ],
                );
              }),
            ),
    );
  }

  Widget _buildCreativeArchiveSection(BuildContext context,
      List<CreativeArchiveItem> items, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 32),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.collections_outlined,
                  color: AppColors.purple, size: 20),
              const SizedBox(width: 10),
              Text(
                "CREATIVE ARCHIVE",
                style: GoogleFonts.syne(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "Marketing media assets, video reel edits, and ad design creatives will appear here as portfolio media is updated.",
            style: GoogleFonts.outfit(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (c, i) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.02),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.purple.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        item.category == CreativeCategory.reels
                            ? Icons.videocam_outlined
                            : item.category == CreativeCategory.metaAds
                                ? Icons.campaign_outlined
                                : Icons.image_outlined,
                        color: AppColors.purple,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.purple.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item.categoryLabel,
                                  style: GoogleFonts.robotoMono(
                                    color: AppColors.purple,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                item.tool,
                                style: GoogleFonts.robotoMono(
                                  color: AppColors.textMuted,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.title,
                            style: GoogleFonts.syne(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${item.contextCampaign} • ${item.role}",
                            style: GoogleFonts.outfit(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CapabilityBlock extends StatelessWidget {
  final String title;
  final List<String> items;

  const _CapabilityBlock({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.robotoMono(
            color: AppColors.cyan,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((i) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("• ", style: TextStyle(color: AppColors.cyan)),
                  Expanded(
                    child: Text(
                      i,
                      style: GoogleFonts.outfit(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
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
        padding: const EdgeInsets.all(20),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.purple.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(p.icon,
                          color: isHovered ? AppColors.purple : Colors.white70,
                          size: 20),
                    ),
                    Text(
                      p.stageLabel,
                      style: GoogleFonts.robotoMono(
                        color: AppColors.purple,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  p.title,
                  style: GoogleFonts.syne(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  p.subtitle,
                  style: GoogleFonts.outfit(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: p.toolsAndSkills
                  .map((s) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Text(
                          s,
                          style: GoogleFonts.robotoMono(
                            color: Colors.white70,
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
