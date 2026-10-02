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
    final isLight = selectedIndex == 2; // GROW section is Light Theme

    final navItems = [
      _NavItemData(icon: Icons.grid_view_rounded, label: "HOME", color: AppColors.cyan),
      _NavItemData(icon: Icons.code_rounded, label: "BUILD", color: AppColors.cyan),
      _NavItemData(icon: Icons.trending_up_rounded, label: "GROW", color: const Color(0xFF7C3AED)),
      _NavItemData(icon: Icons.terminal_rounded, label: "OPERATE", color: AppColors.green),
      _NavItemData(icon: Icons.science_rounded, label: "LAB", color: AppColors.amber),
    ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      width: 90,
      decoration: BoxDecoration(
        color: isLight ? const Color(0xF8FFFFFF) : Colors.transparent,
        border: Border(
          right: BorderSide(
            color: isLight ? const Color(0xFFE2E8F0) : AppColors.border,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          // Brand Monogram
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
            style: GoogleFonts.syne(
              color: isLight ? const Color(0xFF7C3AED) : AppColors.cyan,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
            child: const Text("AS"),
          ),
          const SizedBox(height: 30),

          Expanded(
            child: ListView.separated(
              itemCount: navItems.length,
              separatorBuilder: (c, i) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final item = navItems[index];
                final isSelected = selectedIndex == index;

                return _SideNavItem(
                  data: item,
                  isSelected: isSelected,
                  isLight: isLight,
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
            isLight: isLight,
          ),
          const SizedBox(height: 8),
          _SocialIconButton(
            icon: Icons.work_outline,
            tooltip: "LinkedIn",
            url: "https://www.linkedin.com/in/ashim-sapkota-7792552a4/",
            isLight: isLight,
          ),
          const SizedBox(height: 20),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isLight = selectedIndex == 2; // GROW section is Light Theme

    final navItems = [
      _NavItemData(icon: Icons.grid_view_rounded, label: "HOME", color: AppColors.cyan),
      _NavItemData(icon: Icons.code_rounded, label: "BUILD", color: AppColors.cyan),
      _NavItemData(icon: Icons.trending_up_rounded, label: "GROW", color: const Color(0xFF7C3AED)),
      _NavItemData(icon: Icons.terminal_rounded, label: "OPERATE", color: AppColors.green),
      _NavItemData(icon: Icons.science_rounded, label: "LAB", color: AppColors.amber),
    ];

    final itemPadding = screenWidth < 360 ? 4.0 : 8.0;
    final fontSize = screenWidth < 360 ? 9.0 : 10.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      decoration: BoxDecoration(
        color: isLight ? const Color(0xF8FFFFFF) : const Color(0xF00A0A0A),
        border: Border(
          top: BorderSide(
            color: isLight ? const Color(0xFFE2E8F0) : AppColors.border,
            width: 1,
          ),
        ),
        boxShadow: isLight
            ? const [
                BoxShadow(
                  color: Color(0x0F000000),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                )
              ]
            : [],
      ),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(navItems.length, (index) {
            final item = navItems[index];
            final isSelected = selectedIndex == index;

            final itemColor = isSelected
                ? item.color
                : (isLight ? const Color(0xFF64748B) : Colors.white38);

            final bgColor = isSelected
                ? (isLight
                    ? const Color(0xFFF3E8FF)
                    : item.color.withValues(alpha: 0.15))
                : Colors.transparent;

            return GestureDetector(
              onTap: () =>
                  ref.read(navigationIndexProvider.notifier).state = index,
              child: AnimatedContainer(
                duration: 300.ms,
                padding: EdgeInsets.symmetric(
                    horizontal: itemPadding, vertical: 5),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      size: 18,
                      color: itemColor,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.label,
                      style: GoogleFonts.robotoMono(
                        fontSize: fontSize,
                        color: itemColor,
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
  final bool isLight;
  final VoidCallback onTap;

  const _SideNavItem({
    required this.data,
    required this.isSelected,
    required this.isLight,
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

    final unselectedColor = widget.isLight
        ? (isHovered ? const Color(0xFF1E293B) : const Color(0xFF64748B))
        : (isHovered ? Colors.white70 : Colors.white24);

    final displayColor = widget.isSelected ? color : unselectedColor;

    final hoverBg = widget.isLight
        ? const Color(0xFFF3E8FF)
        : color.withValues(alpha: 0.08);

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
            duration: 300.ms,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: widget.isSelected ? color : Colors.transparent,
                  width: 3,
                ),
              ),
              color: isHovered ? hoverBg : Colors.transparent,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.data.icon,
                  color: displayColor,
                  size: 22,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.data.label,
                  style: GoogleFonts.robotoMono(
                    color: displayColor,
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
  final bool isLight;

  const _SocialIconButton({
    required this.icon,
    required this.tooltip,
    required this.url,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isLight ? const Color(0xFF64748B) : Colors.white38;
    final hoverBg = isLight
        ? const Color(0xFFF3E8FF)
        : AppColors.cyan.withValues(alpha: 0.1);

    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, color: iconColor, size: 18),
        onPressed: () => launchUrl(Uri.parse(url)),
        hoverColor: hoverBg,
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
