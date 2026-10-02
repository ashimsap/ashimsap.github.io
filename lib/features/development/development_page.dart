import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/responsive/responsive_layout.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/device_frame.dart';
import 'data/projects_data.dart';
import 'models/project_model.dart';

class DevelopmentPage extends StatelessWidget {
  const DevelopmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final screenWidth = MediaQuery.of(context).size.width;

    final mainProjects = ProjectsData.mainFeaturedProjects;
    final otherProjects = ProjectsData.otherProjects;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 60,
        vertical: isMobile ? 24 : 60,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "BUILD // DEVELOPMENT",
            style: GoogleFonts.robotoMono(
              color: AppColors.cyan,
              fontSize: 12,
              letterSpacing: 3,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "PRIMARY FEATURED CASE STUDIES",
            style: GoogleFonts.syne(
              fontSize: screenWidth < 360 ? 24 : (isMobile ? 28 : 42),
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "In-depth technical breakdown of core software projects: real estate mapping engine, embedded local server architecture, and Linux desktop automation.",
            style: GoogleFonts.outfit(
              color: AppColors.textSecondary,
              fontSize: screenWidth < 360 ? 14 : 16,
            ),
          ),
          const SizedBox(height: 40),

          // 1. TOP 3 MAIN ELABORATED CASE STUDIES
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mainProjects.length,
            separatorBuilder: (c, i) => SizedBox(height: isMobile ? 40 : 60),
            itemBuilder: (context, index) {
              return _ElaboratedCaseStudyCard(
                project: mainProjects[index],
                index: index,
                isReversed: !isMobile && (index % 2 != 0),
              );
            },
          ),

          const SizedBox(height: 60),

          // 2. OTHER PROJECTS & PROTOTYPES (COMPACT SECTION)
          Text(
            "OTHER PROJECTS & PROTOTYPES",
            style: GoogleFonts.robotoMono(
              color: AppColors.textMuted,
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),

          isMobile
              ? Column(
                  children: otherProjects
                      .map((p) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _CompactProjectCard(project: p),
                          ))
                      .toList(),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: screenWidth < 900 ? 2 : 3,
                    childAspectRatio: screenWidth < 900 ? 1.25 : 1.15,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: otherProjects.length,
                  itemBuilder: (context, index) =>
                      _CompactProjectCard(project: otherProjects[index]),
                ),

          const SizedBox(height: 60),
        ],
      ),
    );
  }
}

class _ElaboratedCaseStudyCard extends StatefulWidget {
  final ProjectModel project;
  final int index;
  final bool isReversed;

  const _ElaboratedCaseStudyCard({
    required this.project,
    required this.index,
    required this.isReversed,
  });

  @override
  State<_ElaboratedCaseStudyCard> createState() =>
      _ElaboratedCaseStudyCardState();
}

class _ElaboratedCaseStudyCardState extends State<_ElaboratedCaseStudyCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final project = widget.project;

    final infoColumn = Column(
      crossAxisAlignment: widget.isReversed
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: widget.isReversed
              ? WrapAlignment.end
              : WrapAlignment.start,
          spacing: 12,
          runSpacing: 6,
          children: [
            Text(
              "0${widget.index + 1}",
              style: GoogleFonts.robotoMono(
                color: project.color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: project.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: project.color.withValues(alpha: 0.3), width: 1),
              ),
              child: Text(
                project.status,
                style: GoogleFonts.robotoMono(
                  color: project.color,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          project.title,
          style: GoogleFonts.syne(
            fontSize: isMobile ? 26 : 34,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.1,
          ),
          textAlign: widget.isReversed ? TextAlign.right : TextAlign.left,
        ),
        const SizedBox(height: 10),
        Text(
          project.description,
          style: GoogleFonts.outfit(
            color: AppColors.cyan,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          textAlign: widget.isReversed ? TextAlign.right : TextAlign.left,
        ),
        const SizedBox(height: 12),
        Text(
          project.details,
          style: GoogleFonts.outfit(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.6,
          ),
          textAlign: widget.isReversed ? TextAlign.right : TextAlign.left,
        ),
        const SizedBox(height: 16),

        // Key Technical Highlights
        if (project.highlights != null) ...[
          Text(
            "KEY TECHNICAL HIGHLIGHTS",
            style: GoogleFonts.robotoMono(
              color: project.color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          ...project.highlights!.map((h) => Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("• ", style: TextStyle(color: project.color)),
                    Expanded(
                      child: Text(
                        h,
                        style: GoogleFonts.outfit(
                          color: Colors.white70,
                          fontSize: 13,
                          height: 1.4,
                        ),
                        textAlign:
                            widget.isReversed ? TextAlign.right : TextAlign.left,
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 16),
        ],

        Wrap(
          alignment:
              widget.isReversed ? WrapAlignment.end : WrapAlignment.start,
          spacing: 6,
          runSpacing: 6,
          children: project.tags
              .map((t) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white12),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withValues(alpha: 0.02),
                    ),
                    child: Text(
                      t,
                      style: GoogleFonts.robotoMono(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 20),
        if (project.url != null)
          OutlinedButton.icon(
            onPressed: () => launchUrl(Uri.parse(project.url!)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: project.color),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            icon: Icon(Icons.arrow_outward, size: 15, color: project.color),
            label: Text(
              "VIEW REPOSITORY",
              style: GoogleFonts.robotoMono(
                color: project.color,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );

    final visualFrame = Center(
      child: DeviceFrame(
        assets: project.imageAssets ?? [],
        type: project.deviceType,
        accentColor: project.color,
        isIconMode: project.isIconMode,
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: 200.ms,
        padding: EdgeInsets.all(isMobile ? 18 : 32),
        decoration: BoxDecoration(
          color: isHovered
              ? project.color.withValues(alpha: 0.03)
              : AppColors.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isHovered
                ? project.color.withValues(alpha: 0.4)
                : AppColors.border,
          ),
        ),
        child: isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  visualFrame,
                  const SizedBox(height: 24),
                  infoColumn,
                ],
              )
            : Row(
                textDirection: widget.isReversed
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: visualFrame),
                  const SizedBox(width: 32),
                  Expanded(flex: 6, child: infoColumn),
                ],
              ),
      ),
    );
  }
}

class _CompactProjectCard extends StatefulWidget {
  final ProjectModel project;
  const _CompactProjectCard({required this.project});

  @override
  State<_CompactProjectCard> createState() => _CompactProjectCardState();
}

class _CompactProjectCardState extends State<_CompactProjectCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.project;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isHovered
              ? p.color.withValues(alpha: 0.05)
              : AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isHovered
                ? p.color.withValues(alpha: 0.4)
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
                    Text(
                      p.title,
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
                        color: p.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: p.color.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        p.status,
                        style: GoogleFonts.robotoMono(
                          color: p.color,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  p.description,
                  style: GoogleFonts.outfit(
                    color: AppColors.cyan,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  p.details,
                  style: GoogleFonts.outfit(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: p.tags
                      .map((t) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.04),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Text(
                              t,
                              style: GoogleFonts.robotoMono(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
                          ))
                      .toList(),
                ),
                if (p.url != null) ...[
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => launchUrl(Uri.parse(p.url!)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "VIEW REPOSITORY",
                          style: GoogleFonts.robotoMono(
                            color: p.color,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_outward, size: 12, color: p.color),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
