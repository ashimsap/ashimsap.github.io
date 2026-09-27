import 'package:flutter/material.dart';
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
    final projects = ProjectsData.projects;

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
            "BUILD // DEVELOPMENT",
            style: GoogleFonts.robotoMono(
              color: AppColors.cyan,
              fontSize: 13,
              letterSpacing: 3,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "FEATURED SOFTWARE & CASE STUDIES",
            style: GoogleFonts.syne(
              fontSize: isMobile ? 28 : 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Mobile applications, server-side Dart utilities, embedded hardware controllers, and experimental sandboxes.",
            style: GoogleFonts.outfit(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 50),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: projects.length,
            separatorBuilder: (c, i) => SizedBox(height: isMobile ? 50 : 80),
            itemBuilder: (context, index) {
              return _ProjectCaseStudyCard(
                project: projects[index],
                index: index,
                isReversed: !isMobile && (index % 2 != 0),
              );
            },
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}

class _ProjectCaseStudyCard extends StatefulWidget {
  final ProjectModel project;
  final int index;
  final bool isReversed;

  const _ProjectCaseStudyCard({
    required this.project,
    required this.index,
    required this.isReversed,
  });

  @override
  State<_ProjectCaseStudyCard> createState() => _ProjectCaseStudyCardState();
}

class _ProjectCaseStudyCardState extends State<_ProjectCaseStudyCard> {
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
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "0${widget.index + 1}",
              style: GoogleFonts.robotoMono(
                color: project.color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 12),
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
            fontSize: isMobile ? 28 : 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.1,
          ),
          textAlign: widget.isReversed ? TextAlign.right : TextAlign.left,
        ),
        const SizedBox(height: 16),
        Text(
          project.description,
          style: GoogleFonts.outfit(
            color: AppColors.cyan,
            fontSize: 16,
            fontWeight: FontWeight.w400,
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
        const SizedBox(height: 20),
        Wrap(
          alignment:
              widget.isReversed ? WrapAlignment.end : WrapAlignment.start,
          spacing: 8,
          runSpacing: 8,
          children: project.tags
              .map((t) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white12),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withValues(alpha: 0.02),
                    ),
                    child: Text(
                      t,
                      style: GoogleFonts.robotoMono(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 24),
        if (project.url != null)
          OutlinedButton.icon(
            onPressed: () => launchUrl(Uri.parse(project.url!)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: project.color),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            icon: Icon(Icons.arrow_outward, size: 16, color: project.color),
            label: Text(
              project.status == "GitHub Repository" ? "VIEW REPOSITORY" : "VIEW SOURCE",
              style: GoogleFonts.robotoMono(
                color: project.color,
                fontSize: 12,
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
      child: Container(
        padding: EdgeInsets.all(isMobile ? 20 : 36),
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
                  const SizedBox(height: 30),
                  infoColumn,
                ],
              )
            : Row(
                textDirection: widget.isReversed
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 5, child: visualFrame),
                  const SizedBox(width: 40),
                  Expanded(flex: 6, child: infoColumn),
                ],
              ),
      ),
    );
  }
}
