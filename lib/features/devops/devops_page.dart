import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/responsive/responsive_layout.dart';
import '../../core/theme/app_colors.dart';
import 'data/devops_data.dart';
import 'models/devops_model.dart';

class DevOpsPage extends StatelessWidget {
  const DevOpsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final jellyfin = DevOpsData.jellyfinProject;
    final topics = DevOpsData.topics;

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
            "OPERATE // DEVOPS & INFRASTRUCTURE",
            style: GoogleFonts.robotoMono(
              color: AppColors.green,
              fontSize: 13,
              letterSpacing: 3,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "SYSTEMS, NETWORKING & SELF-HOSTING",
            style: GoogleFonts.syne(
              fontSize: isMobile ? 28 : 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Building toward DevOps through hands-on personal infrastructure projects, Linux server administration, Nginx reverse proxies, and CI/CD pipelines.",
            style: GoogleFonts.outfit(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 40),

          // 1. SELF-HOSTED INFRASTRUCTURE CASE STUDY (Jellyfin Server)
          _buildJellyfinCard(context, jellyfin, isMobile),

          const SizedBox(height: 40),

          // 2. PORTFOLIO CI/CD PIPELINE CARD
          _buildPipelineCard(context, isMobile),

          const SizedBox(height: 50),

          // 3. INFRASTRUCTURE & LEARNING ROADMAP
          Text(
            "SYSTEMS & LEARNING ROADMAP",
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
            itemCount: topics.length,
            separatorBuilder: (c, i) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return _JourneyCard(topic: topics[index]);
            },
          ),

          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildJellyfinCard(
      BuildContext context, SelfHostedProjectModel project, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 32),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.green.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.green.withValues(alpha: 0.08),
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
                  color: AppColors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.green),
                ),
                child: Text(
                  "SELF-HOSTED INFRASTRUCTURE PROJECT",
                  style: GoogleFonts.robotoMono(
                    color: AppColors.green,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Icon(Icons.dns_outlined, color: AppColors.green, size: 18),
              const SizedBox(width: 6),
              Text(
                "PERSONAL HOME SERVER",
                style: GoogleFonts.robotoMono(
                  color: AppColors.green,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            project.title,
            style: GoogleFonts.syne(
              color: Colors.white,
              fontSize: isMobile ? 22 : 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            project.subtitle,
            style: GoogleFonts.robotoMono(
              color: AppColors.cyan,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            project.description,
            style: GoogleFonts.outfit(
              color: AppColors.textSecondary,
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),

          // Tech Badge Pills
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: project.technologies
                .map((t) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppColors.green.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        t,
                        style: GoogleFonts.robotoMono(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ))
                .toList(),
          ),

          const SizedBox(height: 24),

          // Architecture Diagram Visualization
          Text(
            "INFRASTRUCTURE TRAFFIC FLOW",
            style: GoogleFonts.robotoMono(
              color: AppColors.green,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),

          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(project.architectureSteps.length, (i) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DiagramNode(label: project.architectureSteps[i]),
                        if (i < project.architectureSteps.length - 1)
                          Padding(
                            padding: const EdgeInsets.only(left: 18),
                            child: Icon(Icons.arrow_downward_rounded,
                                color: AppColors.green, size: 16),
                          ),
                      ],
                    );
                  }),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        List.generate(project.architectureSteps.length, (i) {
                      return Row(
                        children: [
                          _DiagramNode(label: project.architectureSteps[i]),
                          if (i < project.architectureSteps.length - 1)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Icon(Icons.arrow_forward_rounded,
                                  color: AppColors.green, size: 16),
                            ),
                        ],
                      );
                    }),
                  ),
                ),

          const SizedBox(height: 20),

          // Workflow OS Note
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                Icon(Icons.computer_outlined, color: AppColors.cyan, size: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    project.workflowNote,
                    style: GoogleFonts.outfit(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPipelineCard(BuildContext context, bool isMobile) {
    final steps = [
      "GitHub Commit",
      "GitHub Actions",
      "Flutter Analyze",
      "Flutter Build Web",
      "GitHub Pages",
    ];

    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 32),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.green.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.green.withValues(alpha: 0.4)),
                ),
                child: Text(
                  "PORTFOLIO CI/CD ARCHITECTURE",
                  style: GoogleFonts.robotoMono(
                    color: AppColors.green,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Icon(Icons.check_circle_outline, color: AppColors.green, size: 18),
              const SizedBox(width: 6),
              Text(
                "DEPLOYED & LIVE",
                style: GoogleFonts.robotoMono(
                  color: AppColors.green,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Self-Deploying Web Ecosystem",
            style: GoogleFonts.syne(
              color: Colors.white,
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Every push to the main branch triggers an automated GitHub Actions runner that builds the release target and deploys directly to GitHub Pages.",
            style: GoogleFonts.outfit(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),

          // Pipeline Visualization Diagram
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(steps.length, (i) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DiagramNode(label: steps[i]),
                        if (i < steps.length - 1)
                          Padding(
                            padding: const EdgeInsets.only(left: 18),
                            child: Icon(Icons.arrow_downward_rounded,
                                color: AppColors.green, size: 16),
                          ),
                      ],
                    );
                  }),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(steps.length, (i) {
                      return Row(
                        children: [
                          _DiagramNode(label: steps[i]),
                          if (i < steps.length - 1)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Icon(Icons.arrow_forward_rounded,
                                  color: AppColors.green, size: 16),
                            ),
                        ],
                      );
                    }),
                  ),
                ),
        ],
      ),
    );
  }
}

class _DiagramNode extends StatelessWidget {
  final String label;
  const _DiagramNode({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.green.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: GoogleFonts.robotoMono(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _JourneyCard extends StatefulWidget {
  final DevOpsTopic topic;
  const _JourneyCard({required this.topic});

  @override
  State<_JourneyCard> createState() => _JourneyCardState();
}

class _JourneyCardState extends State<_JourneyCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.topic;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isHovered
              ? t.statusColor.withValues(alpha: 0.05)
              : AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isHovered
                ? t.statusColor.withValues(alpha: 0.5)
                : AppColors.border,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: t.statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(t.icon, color: t.statusColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        t.title,
                        style: GoogleFonts.syne(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: t.statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: t.statusColor, width: 1),
                        ),
                        child: Text(
                          t.statusLabel,
                          style: GoogleFonts.robotoMono(
                            color: t.statusColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    t.category,
                    style: GoogleFonts.robotoMono(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    t.description,
                    style: GoogleFonts.outfit(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: t.keyConcepts
                        .map((c) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.04),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.white12),
                              ),
                              child: Text(
                                c,
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
          ],
        ),
      ),
    );
  }
}
