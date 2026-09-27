import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app/navigation_provider.dart';
import '../theme/app_colors.dart';

class CustomSideNavRail extends ConsumerWidget {
  const CustomSideNavRail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationIndexProvider);

    final navItems = [
      _NavItemData(icon: Icons.grid_view_rounded, label: "HOME", color: AppColors.cyan),
      _NavItemData(icon: Icons.code_rounded, label: "BUILD", color: AppColors.cyan),
      _NavItemData(icon: Icons.trending_up_rounded, label: "GROW", color: AppColors.purple),
      _NavItemData(icon: Icons.terminal_rounded, label: "OPERATE", color: AppColors.green),
      _NavItemData(icon: Icons.science_rounded, label: "LAB", color: AppColors.amber),
    ];

    return Container(
      width: 100,
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 30),
          // Brand Monogram
          Text(
            "AS",
            style: GoogleFonts.syne(
              color: AppColors.cyan,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 40),

          Expanded(
            child: ListView.separated(
              itemCount: navItems.length,
              separatorBuilder: (c, i) => const SizedBox(height: 24),
              itemBuilder: (context, index) {
                final item = navItems[index];
                final isSelected = selectedIndex == index;

                return _SideNavItem(
                  data: item,
                  isSelected: isSelected,
                  onTap: () =>
                      ref.read(navigationIndexProvider.notifier).state = index,
                );
              },
            ),
          ),

          // External Quick Links
          _SocialIconButton(
            icon: Icons.code,
            tooltip: "GitHub",
            url: "https://github.com/ashimsap",
          ),
          const SizedBox(height: 12),
          _SocialIconButton(
            icon: Icons.work_outline,
            tooltip: "LinkedIn",
            url: "https://www.linkedin.com/in/ashim-sapkota-7792552a4/",
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class CustomBottomNavBar extends ConsumerWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationIndexProvider);

    final navItems = [
      _NavItemData(icon: Icons.grid_view_rounded, label: "HOME", color: AppColors.cyan),
      _NavItemData(icon: Icons.code_rounded, label: "BUILD", color: AppColors.cyan),
      _NavItemData(icon: Icons.trending_up_rounded, label: "GROW", color: AppColors.purple),
      _NavItemData(icon: Icons.terminal_rounded, label: "OPERATE", color: AppColors.green),
      _NavItemData(icon: Icons.science_rounded, label: "LAB", color: AppColors.amber),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xF00A0A0A),
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(navItems.length, (index) {
            final item = navItems[index];
            final isSelected = selectedIndex == index;

            return GestureDetector(
              onTap: () =>
                  ref.read(navigationIndexProvider.notifier).state = index,
              child: AnimatedContainer(
                duration: 200.ms,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? item.color.withValues(alpha: 0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      size: 20,
                      color: isSelected ? item.color : Colors.white38,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.label,
                      style: GoogleFonts.robotoMono(
                        fontSize: 10,
                        color: isSelected ? item.color : Colors.white38,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _SideNavItem extends StatefulWidget {
  final _NavItemData data;
  final bool isSelected;
  final VoidCallback onTap;

  const _SideNavItem({
    required this.data,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_SideNavItem> createState() => _SideNavItemState();
}

class _SideNavItemState extends State<_SideNavItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.data.color;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: Tooltip(
        message: widget.data.label,
        waitDuration: const Duration(milliseconds: 300),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: 200.ms,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: widget.isSelected ? color : Colors.transparent,
                  width: 3,
                ),
              ),
              color: isHovered
                  ? color.withValues(alpha: 0.08)
                  : Colors.transparent,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.data.icon,
                  color: widget.isSelected
                      ? color
                      : (isHovered ? Colors.white70 : Colors.white24),
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.data.label,
                  style: GoogleFonts.robotoMono(
                    color: widget.isSelected
                        ? color
                        : (isHovered ? Colors.white70 : Colors.white24),
                    fontSize: 9,
                    fontWeight: widget.isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final String url;

  const _SocialIconButton({
    required this.icon,
    required this.tooltip,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, color: Colors.white38, size: 18),
        onPressed: () => launchUrl(Uri.parse(url)),
        hoverColor: AppColors.cyan.withValues(alpha: 0.1),
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final String label;
  final Color color;

  const _NavItemData({
    required this.icon,
    required this.label,
    required this.color,
  });
}
