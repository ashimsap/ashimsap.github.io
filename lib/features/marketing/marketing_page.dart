import 'package:flutter/material.dart';
import '../../core/responsive/responsive_layout.dart';
import 'data/marketing_data.dart';
import 'widgets/creative_gallery.dart';
import 'widgets/experience_card.dart';
import 'widgets/graphics_slider_showcase.dart';
import 'widgets/grow_hero.dart';
import 'widgets/marketing_capabilities.dart';
import 'widgets/marketing_workflow.dart';
import 'widgets/video_comparison_player.dart';

class MarketingPage extends StatelessWidget {
  const MarketingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final experience = MarketingData.enlightenExperience;
    final pillars = MarketingData.pillars;
    final archiveItems = MarketingData.archiveItems;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 60,
        vertical: isMobile ? 24 : 60,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. EDITORIAL LIGHT HERO
          const GrowHero(),

          const SizedBox(height: 40),

          // 2. MEDIA SHOWCASE ROW (Color Grading Video + Graphics Auto-Slider)
          screenWidth >= 900
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(child: VideoComparisonPlayer()),
                    SizedBox(width: 24),
                    Expanded(child: GraphicsSliderShowcase()),
                  ],
                )
              : Column(
                  children: const [
                    VideoComparisonPlayer(),
                    SizedBox(height: 24),
                    GraphicsSliderShowcase(),
                  ],
                ),

          const SizedBox(height: 40),

          // 3. CREATIVE ARCHIVE / GALLERY
          CreativeGallery(items: archiveItems),

          const SizedBox(height: 40),

          // 4. MARKETING WORKFLOW (CREATE -> PUBLISH -> PROMOTE -> MEASURE)
          const MarketingWorkflow(),

          const SizedBox(height: 40),

          // 5. CAPABILITIES GRID
          MarketingCapabilities(pillars: pillars),

          const SizedBox(height: 40),

          // 6. PROFESSIONAL EXPERIENCE (ENLIGHTEN INFOSYS)
          ExperienceCard(experience: experience),

          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
