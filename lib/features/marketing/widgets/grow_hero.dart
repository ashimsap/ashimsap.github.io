import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class GrowHero extends StatelessWidget {
  const GrowHero({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final heroFontSize = screenWidth < 360
        ? 32.0
        : (screenWidth < 480 ? 40.0 : (isMobile ? 52.0 : 76.0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Responsive Light Badge Bar
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E8FF), // Light purple pill
                border: Border.all(color: const Color(0xFFDDD6FE)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                "DIGITAL MARKETING • CREATIVE & MEDIA",
                style: GoogleFonts.robotoMono(
                  color: const Color(0xFF7E22CE), // Rich dark purple
                  fontSize: screenWidth < 360 ? 9 : (isMobile ? 10 : 12),
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Enlighten Infosys Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981), // Emerald green active dot
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "ENLIGHTEN INFOSYS (MAY 2026 – PRESENT)",
                    style: GoogleFonts.robotoMono(
                      color: const Color(0xFF334155),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ).animate().fadeIn(duration: 400.ms),

        const SizedBox(height: 20),

        RichText(
          text: TextSpan(
            style: GoogleFonts.syne(
              fontSize: heroFontSize,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A), // Charcoal
              height: 0.95,
              letterSpacing: -1.5,
            ),
            children: [
              const TextSpan(text: "CREATIVE\n"),
              TextSpan(
                text: "CAMPAIGNS.",
                style: GoogleFonts.syne(
                  fontSize: heroFontSize,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF7C3AED), // Deep Purple
                  height: 0.95,
                  letterSpacing: -1.5,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 150.ms).moveY(begin: 15, end: 0),

        const SizedBox(height: 20),

        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Text(
            "Creative work that turns ideas into content, campaigns, and reach. Specialized in graphic design, short-form video editing, color grading camera footage, Meta ads, social operations, and email/SMS direct channels.",
            style: GoogleFonts.outfit(
              color: const Color(0xFF475569), // Dark slate text
              fontSize: screenWidth < 360 ? 14 : (isMobile ? 15 : 18),
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ),
        ).animate().fadeIn(delay: 300.ms),

        const SizedBox(height: 24),

        // Editorial Social Quick Chips
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: const [
            _GrowSocialChip(
              label: "LinkedIn Profile",
              icon: Icons.work_outline,
              url: "https://www.linkedin.com/in/ashim-sapkota-7792552a4/",
            ),
            _GrowSocialChip(
              label: "Email Contact",
              icon: Icons.email_outlined,
              url: "mailto:ashimsap@gmail.com",
            ),
          ],
        ).animate().fadeIn(delay: 400.ms),
      ],
    );
  }
}

class _GrowSocialChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final String url;

  const _GrowSocialChip({
    required this.label,
    required this.icon,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse(url)),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFFCBD5E1)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: const Color(0xFF7C3AED)),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.robotoMono(
                color: const Color(0xFF1E293B),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
