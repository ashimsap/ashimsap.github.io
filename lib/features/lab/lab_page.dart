import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/responsive/responsive_layout.dart';
import '../../core/theme/app_colors.dart';
import 'data/lab_data.dart';
import 'models/lab_model.dart';

class LabPage extends StatelessWidget {
  const LabPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final items = LabData.items;

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
            "LAB // EXPERIMENTS & PROTOTYPES",
            style: GoogleFonts.robotoMono(
              color: AppColors.amber,
              fontSize: 12,
              letterSpacing: 3,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "SANDBOX & UNFINISHED IDEAS",
            style: GoogleFonts.syne(
              fontSize: screenWidth < 360 ? 24 : (isMobile ? 28 : 42),
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "A dedicated workspace for technical experiments, UI canvas explorations, networking bridges, and early-stage prototypes.",
            style: GoogleFonts.outfit(
              color: AppColors.textSecondary,
              fontSize: screenWidth < 360 ? 14 : 16,
            ),
          ),
          const SizedBox(height: 36),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (c, i) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return _LabCard(item: items[index]);
            },
          ),

          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

class _LabCard extends StatefulWidget {
  final LabItem item;
  const _LabCard({required this.item});

  @override
  State<_LabCard> createState() => _LabCardState();
}

class _LabCardState extends State<_LabCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isHovered
              ? item.statusColor.withValues(alpha: 0.05)
              : AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isHovered
                ? item.statusColor.withValues(alpha: 0.5)
                : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 6,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: item.statusColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: item.statusColor),
                      ),
                      child: Text(
                        item.statusLabel,
                        style: GoogleFonts.robotoMono(
                          color: item.statusColor,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.category,
                      style: GoogleFonts.robotoMono(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                Text(
                  item.date,
                  style: GoogleFonts.robotoMono(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item.title,
              style: GoogleFonts.syne(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.description,
              style: GoogleFonts.outfit(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: item.technologies
                        .map((tech) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.04),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.white12),
                              ),
                              child: Text(
                                tech,
                                style: GoogleFonts.robotoMono(
                                  color: Colors.white70,
                                  fontSize: 10,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                if (item.link != null)
                  IconButton(
                    onPressed: () => launchUrl(Uri.parse(item.link!)),
                    icon: Icon(
                      Icons.arrow_outward,
                      color: item.accentColor,
                      size: 18,
                    ),
                    tooltip: "Open Experiment Source",
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
