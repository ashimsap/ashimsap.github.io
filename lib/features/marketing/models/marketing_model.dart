import 'package:flutter/material.dart';

enum GrowthStage { create, publish, promote, measure }

enum CreativeCategory {
  graphics,
  socialPosts,
  reels,
  videoEditing,
  colorGrading,
  metaAds,
  email,
  sms,
}

class ProfessionalExperienceModel {
  final String role;
  final String company;
  final String period; // "May 2026 – Present"
  final String overview;
  final Map<String, List<String>> capabilities;

  const ProfessionalExperienceModel({
    required this.role,
    required this.company,
    required this.period,
    required this.overview,
    required this.capabilities,
  });
}

class MarketingPillar {
  final String title;
  final String categoryCode; // e.g. "DESIGN", "VIDEO", "SOCIAL", "PAID", "CAMPAIGNS", "ANALYTICS"
  final GrowthStage stage;
  final String subtitle;
  final IconData icon;
  final List<String> toolsAndSkills;

  const MarketingPillar({
    required this.title,
    required this.categoryCode,
    required this.stage,
    required this.subtitle,
    required this.icon,
    required this.toolsAndSkills,
  });

  String get stageLabel {
    switch (stage) {
      case GrowthStage.create:
        return "CREATE";
      case GrowthStage.publish:
        return "PUBLISH";
      case GrowthStage.promote:
        return "PROMOTE";
      case GrowthStage.measure:
        return "MEASURE";
    }
  }
}

class CreativeArchiveItem {
  final String id;
  final String title;
  final CreativeCategory category;
  final String tool;
  final String date;
  final String contextCampaign;
  final String role;
  final String? previewAsset;
  final String? kpiResults;

  const CreativeArchiveItem({
    required this.id,
    required this.title,
    required this.category,
    required this.tool,
    required this.date,
    required this.contextCampaign,
    required this.role,
    this.previewAsset,
    this.kpiResults,
  });

  String get categoryLabel {
    switch (category) {
      case CreativeCategory.graphics:
        return "GRAPHICS";
      case CreativeCategory.socialPosts:
        return "SOCIAL POST";
      case CreativeCategory.reels:
        return "REELS / SHORT VIDEO";
      case CreativeCategory.videoEditing:
        return "VIDEO EDITING";
      case CreativeCategory.colorGrading:
        return "COLOR GRADING";
      case CreativeCategory.metaAds:
        return "META ADS";
      case CreativeCategory.email:
        return "EMAIL CAMPAIGN";
      case CreativeCategory.sms:
        return "SMS MARKETING";
    }
  }
}
