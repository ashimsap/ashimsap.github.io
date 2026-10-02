import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/marketing_model.dart';

class ExperienceCard extends StatelessWidget {
  final ProfessionalExperienceModel experience;
  const ExperienceCard({super.key, required this.experience});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 20,
            spreadRadius: -2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFFDDD6FE)),
                ),
                child: Text(
                  "PROFESSIONAL EXPERIENCE",
                  style: GoogleFonts.robotoMono(
                    color: const Color(0xFF7E22CE),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                experience.period,
                style: GoogleFonts.robotoMono(
                  color: const Color(0xFF7C3AED),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            experience.role,
            style: GoogleFonts.syne(
              color: const Color(0xFF0F172A),
              fontSize: isMobile ? 22 : 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            experience.company,
            style: GoogleFonts.robotoMono(
              color: const Color(0xFF2563EB),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            experience.overview,
            style: GoogleFonts.outfit(
              color: const Color(0xFF475569),
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),

          // Capabilities Breakdown Grid
          isMobile
              ? Column(
                  children: experience.capabilities.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _CapabilityBlock(
                        title: entry.key,
                        items: entry.value,
                      ),
                    );
                  }).toList(),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final itemWidth = (constraints.maxWidth - 40) / 3;
                    return Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: experience.capabilities.entries.map((entry) {
                        return SizedBox(
                          width: itemWidth,
                          child: _CapabilityBlock(
                            title: entry.key,
                            items: entry.value,
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
        ],
      ),
    );
  }
}

class _CapabilityBlock extends StatelessWidget {
  final String title;
  final List<String> items;

  const _CapabilityBlock({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.robotoMono(
            color: const Color(0xFF7C3AED),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        ...items.map((i) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("• ",
                      style: TextStyle(
                          color: Color(0xFF7C3AED),
                          fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Text(
                      i,
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF334155),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
