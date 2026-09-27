import 'package:flutter/material.dart';

enum MarketingCategory { seo, content, analytics, strategy, audience }

class MarketingCaseStudy {
  final String id;
  final String title;
  final MarketingCategory category;
  final String objective;
  final String approach;
  final List<String> channels;
  final List<String> tools;
  final List<String> keyLearnings;
  final List<String> metrics; // Real or structured placeholder labels
  final Color accentColor;

  const MarketingCaseStudy({
    required this.id,
    required this.title,
    required this.category,
    required this.objective,
    required this.approach,
    required this.channels,
    required this.tools,
    required this.keyLearnings,
    required this.metrics,
    this.accentColor = const Color(0xFF7000FF),
  });
}

class MarketingPillar {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<String> skills;

  const MarketingPillar({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.skills,
  });
}
