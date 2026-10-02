import 'package:flutter/material.dart';
import '../models/marketing_model.dart';

class MarketingData {
  static const ProfessionalExperienceModel enlightenExperience =
      ProfessionalExperienceModel(
    role: "Digital Marketing",
    company: "Enlighten Infosys",
    period: "May 2026 – Present",
    overview:
        "Executing end-to-end digital marketing workflows across visual design, short-form reel video production, Meta ad campaigns, multi-platform publishing, and direct Email/SMS channels.",
    capabilities: {
      "Graphic Design": [
        "Canva",
        "Adobe Photoshop",
        "Social Media Graphics",
        "Promotional & Campaign Creatives",
        "Marketing Visual Assets",
      ],
      "Video & Color Grading": [
        "Reel Content Prep",
        "Short-Form Video Editing",
        "Color Grading Camera Footage",
      ],
      "Paid Advertising": [
        "Meta Ads Manager",
        "Campaign Setup & Optimizations",
      ],
      "Social Media Management": [
        "Multi-Platform Management",
        "Content Scheduling",
        "Publishing Consistency",
      ],
      "Analytics & Insights": [
        "KPI Tracking",
        "Performance Monitoring",
      ],
      "Direct Marketing": [
        "Email Marketing Campaigns",
        "SMS Marketing Outbound",
      ],
    },
  );

  static const List<MarketingPillar> pillars = [
    MarketingPillar(
      title: "Graphic Design",
      categoryCode: "DESIGN",
      stage: GrowthStage.create,
      subtitle: "Canva · Adobe Photoshop · Brand Assets",
      icon: Icons.palette_outlined,
      toolsAndSkills: [
        "Canva",
        "Adobe Photoshop",
        "Social Media Graphics",
        "Campaign Creatives",
      ],
    ),
    MarketingPillar(
      title: "Video & Color Grading",
      categoryCode: "VIDEO",
      stage: GrowthStage.create,
      subtitle: "Reels · Video Editing · Color Grading",
      icon: Icons.movie_creation_outlined,
      toolsAndSkills: [
        "Reel Editing",
        "Video Editing",
        "Camera Color Grading",
        "Short-Form Production",
      ],
    ),
    MarketingPillar(
      title: "Social Media Operations",
      categoryCode: "SOCIAL",
      stage: GrowthStage.publish,
      subtitle: "Publishing · Scheduling · Platform Ops",
      icon: Icons.share_rounded,
      toolsAndSkills: [
        "Social Media Management",
        "Posting & Scheduling",
        "Content Consistency",
      ],
    ),
    MarketingPillar(
      title: "Paid Advertising",
      categoryCode: "PAID",
      stage: GrowthStage.promote,
      subtitle: "Meta Ads · Target Audiences · Campaigns",
      icon: Icons.campaign_outlined,
      toolsAndSkills: [
        "Meta Ads",
        "Campaign Management",
        "Ad Creatives",
      ],
    ),
    MarketingPillar(
      title: "Direct Campaigns",
      categoryCode: "CAMPAIGNS",
      stage: GrowthStage.promote,
      subtitle: "Email Marketing · SMS Outbound",
      icon: Icons.mark_email_read_outlined,
      toolsAndSkills: [
        "Email Marketing",
        "SMS Outbound",
        "Customer Retention",
      ],
    ),
    MarketingPillar(
      title: "Analytics & Monitoring",
      categoryCode: "ANALYTICS",
      stage: GrowthStage.measure,
      subtitle: "KPI Tracking · Campaign Insights",
      icon: Icons.insights_rounded,
      toolsAndSkills: [
        "KPI Tracking",
        "Performance Insights",
        "Social Monitoring",
      ],
    ),
  ];

  static const List<CreativeArchiveItem> archiveItems = [
    CreativeArchiveItem(
      id: "social-campaign-design",
      title: "Social Media Promotional Campaign Creatives",
      category: CreativeCategory.graphics,
      tool: "Canva / Adobe Photoshop",
      date: "2026",
      contextCampaign: "Brand Awareness & Promotional Visuals",
      role: "Graphic Designer",
    ),
    CreativeArchiveItem(
      id: "reel-content-editing",
      title: "Short-Form Reel Production & Camera Color Grading",
      category: CreativeCategory.visualContent,
      tool: "Video Editing & Color Grading Tools",
      date: "2026",
      contextCampaign: "Social Video Outreach",
      role: "Video Editor & Colorist",
    ),
    CreativeArchiveItem(
      id: "meta-ad-campaigns",
      title: "Meta Paid Advertising Creatives & Campaign Setup",
      category: CreativeCategory.campaigns,
      tool: "Meta Ads Manager",
      date: "2026",
      contextCampaign: "Targeted Paid Acquisition",
      role: "Campaign Manager",
    ),
    CreativeArchiveItem(
      id: "direct-outbound-marketing",
      title: "Direct Customer Email & SMS Broadcast Campaigns",
      category: CreativeCategory.social,
      tool: "Email & SMS Marketing Platforms",
      date: "2026",
      contextCampaign: "Customer Retention & Announcements",
      role: "Direct Marketer",
    ),
  ];
}
