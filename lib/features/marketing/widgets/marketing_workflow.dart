import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MarketingWorkflow extends StatelessWidget {
  const MarketingWorkflow({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;

    final steps = [
      _WorkflowStep(
        number: "01",
        stage: "CREATE",
        title: "Visual & Content Prep",
        description: "Graphic design, short-form reel video editing & color grading.",
        color: const Color(0xFF7C3AED),
      ),
      _WorkflowStep(
        number: "02",
        stage: "PUBLISH",
        title: "Platform Scheduling",
        description: "Social media management, consistent scheduling & platform operations.",
        color: const Color(0xFF2563EB),
      ),
      _WorkflowStep(
        number: "03",
        stage: "PROMOTE",
        title: "Paid & Direct Outbound",
        description: "Meta ad campaigns, direct Email marketing, and SMS outreach.",
        color: const Color(0xFFD97706),
      ),
      _WorkflowStep(
        number: "04",
        stage: "MEASURE",
        title: "Analytics & Iteration",
        description: "Tracking KPIs, monitoring engagement performance, and optimizing creative output.",
        color: const Color(0xFF059669),
      ),
    ];

    return Container(
      padding: EdgeInsets.all(isMobile ? 18 : 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFFDDD6FE)),
                ),
                child: Text(
                  "GROWTH WORKFLOW",
                  style: GoogleFonts.robotoMono(
                    color: const Color(0xFF7E22CE),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Icon(Icons.alt_route_rounded,
                  color: const Color(0xFF7C3AED), size: 18),
              const SizedBox(width: 6),
              Text(
                "EXECUTION FRAMEWORK",
                style: GoogleFonts.robotoMono(
                  color: const Color(0xFF7C3AED),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            "MARKETING ENGINE & PROCESS",
            style: GoogleFonts.syne(
              color: const Color(0xFF0F172A),
              fontSize: isMobile ? 20 : 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "How digital marketing campaigns move from raw creative production to measurable audience growth.",
            style: GoogleFonts.outfit(
              color: const Color(0xFF475569),
              fontSize: isMobile ? 14 : 15,
            ),
          ),
          const SizedBox(height: 24),

          // Flow Grid
          isMobile
              ? Column(
                  children: steps
                      .map((s) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _WorkflowStepCard(step: s),
                          ))
                      .toList(),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: steps
                      .map((s) => Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: _WorkflowStepCard(step: s),
                            ),
                          ))
                      .toList(),
                ),
        ],
      ),
    );
  }
}

class _WorkflowStepCard extends StatelessWidget {
  final _WorkflowStep step;
  const _WorkflowStepCard({required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                step.number,
                style: GoogleFonts.syne(
                  color: step.color,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: step.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  step.stage,
                  style: GoogleFonts.robotoMono(
                    color: step.color,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            step.title,
            style: GoogleFonts.syne(
              color: const Color(0xFF0F172A),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            step.description,
            style: GoogleFonts.outfit(
              color: const Color(0xFF475569),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkflowStep {
  final String number;
  final String stage;
  final String title;
  final String description;
  final Color color;

  _WorkflowStep({
    required this.number,
    required this.stage,
    required this.title,
    required this.description,
    required this.color,
  });
}
