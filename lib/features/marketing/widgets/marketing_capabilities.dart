import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/marketing_model.dart';

class MarketingCapabilities extends StatelessWidget {
  final List<MarketingPillar> pillars;
  const MarketingCapabilities({super.key, required this.pillars});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "MARKETING CAPABILITIES & TOOLS",
          style: GoogleFonts.robotoMono(
            color: const Color(0xFF64748B),
            fontSize: 12,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        isMobile
            ? Column(
                children: pillars
                    .map((p) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _CapabilityPillarCard(pillar: p),
                        ))
                    .toList(),
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: screenWidth < 900 ? 2 : 3,
                  childAspectRatio: screenWidth < 900 ? 1.35 : 1.25,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: pillars.length,
                itemBuilder: (context, index) =>
                    _CapabilityPillarCard(pillar: pillars[index]),
              ),
      ],
    );
  }
}

class _CapabilityPillarCard extends StatefulWidget {
  final MarketingPillar pillar;
  const _CapabilityPillarCard({required this.pillar});

  @override
  State<_CapabilityPillarCard> createState() => _CapabilityPillarCardState();
}

class _CapabilityPillarCardState extends State<_CapabilityPillarCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.pillar;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isHovered ? const Color(0xFFF3E8FF) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isHovered
                ? const Color(0xFF7C3AED)
                : const Color(0xFFE2E8F0),
            width: 1.5,
          ),
          boxShadow: isHovered
              ? const [
                  BoxShadow(
                    color: Color(0x147C3AED),
                    blurRadius: 16,
                    offset: Offset(0, 4),
                  )
                ]
              : const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  )
                ],
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
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E8FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(p.icon,
                          color: const Color(0xFF7C3AED), size: 20),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        p.categoryCode,
                        style: GoogleFonts.robotoMono(
                          color: const Color(0xFF475569),
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  p.title,
                  style: GoogleFonts.syne(
                    color: const Color(0xFF0F172A),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  p.subtitle,
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF475569),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: p.toolsAndSkills
                  .map((s) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Text(
                          s,
                          style: GoogleFonts.robotoMono(
                            color: const Color(0xFF334155),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
