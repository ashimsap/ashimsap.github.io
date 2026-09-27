import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/responsive/responsive_layout.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/cyber_background.dart';
import '../core/widgets/custom_navigation.dart';
import '../features/development/development_page.dart';
import '../features/devops/devops_page.dart';
import '../features/home/home_page.dart';
import '../features/lab/lab_page.dart';
import '../features/marketing/marketing_page.dart';
import 'navigation_provider.dart';

class MainAppShell extends ConsumerWidget {
  const MainAppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationIndexProvider);
    final isMobile = ResponsiveLayout.isMobile(context);

    // Accent color switches according to active section (Rule 13)
    final sectionColors = [
      AppColors.cyan, // HOME
      AppColors.cyan, // BUILD
      AppColors.purple, // GROW
      AppColors.green, // OPERATE
      AppColors.amber, // LAB
    ];

    final pages = const [
      HomePage(),
      DevelopmentPage(),
      MarketingPage(),
      DevOpsPage(),
      LabPage(),
    ];

    final currentAccentColor = sectionColors[selectedIndex.clamp(0, 4)];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CyberBackground(
        accentColor: currentAccentColor,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  // Desktop / Tablet Persistent Side Navigation Rail
                  if (!isMobile) const CustomSideNavRail(),

                  // Active Section Page Content
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: 300.ms,
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      child: Container(
                        key: ValueKey<int>(selectedIndex),
                        child: pages[selectedIndex.clamp(0, pages.length - 1)],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Mobile Bottom Navigation Bar
            if (isMobile) const CustomBottomNavBar(),
          ],
        ),
      ),
    );
  }
}
