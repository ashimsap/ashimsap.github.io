import 'package:flutter/material.dart';
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
    final isLight = selectedIndex == 2; // GROW / Marketing Section is Light Theme

    // Accent color switches according to active section
    final sectionColors = [
      AppColors.cyan, // HOME
      AppColors.cyan, // BUILD
      const Color(0xFF7C3AED), // GROW (Rich Purple)
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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
      color: isLight ? const Color(0xFFF8FAFC) : AppColors.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CyberBackground(
          accentColor: currentAccentColor,
          isLight: isLight,
          sectionIndex: selectedIndex,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    // Desktop / Tablet Persistent Side Navigation Rail
                    if (!isMobile) const CustomSideNavRail(),

                    // Active Section Page Content with Smooth Silky-Fade Cross Transition
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        switchInCurve: Curves.easeInOutCubic,
                        switchOutCurve: Curves.easeInOutCubic,
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
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
      ),
    );
  }
}
