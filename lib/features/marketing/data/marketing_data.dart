import 'package:flutter/material.dart';
import '../models/marketing_model.dart';

class MarketingData {
  static const ProfessionalExperienceModel enlightenExperience =
      ProfessionalExperienceModel(
    role: "Digital Marketing",
    company: "Enlighten Infosys",
    period: "May 2026 – Present",
    overview:
        "Managing multi-channel digital presence, creative content creation, paid advertising campaigns, and direct customer engagement channels.",
    capabilities: {
      "Graphic Design": [
        "Canva",
        "Adobe Photoshop",
        "Social Media Graphics",
        "Promotional & Campaign Creatives",
        "Marketing Visual Assets",
      ],
      "Video & Editing": [
        "Reel & Short-Form Content Preparation",
        "Video Editing",
        "Color Grading Camera Footage",
      ],
      "Paid Advertising": [
        "Meta Ads Manager",
        "Campaign Planning & Execution",
      ],
      "Social Media Management": [
        "Multi-Platform Management",
        "Content Scheduling",
        "Consistency & Publishing",
      ],
      "Analytics & Reporting": [
        "KPI Tracking",
        "Social & Marketing Performance Monitoring",
      ],
      "Direct Marketing": [
        "Email Marketing Campaigns",
        "SMS Marketing Outbound",
      ],
    },
  );

  static const List<MarketingPillar> pillars = [
    MarketingPillar(
      title: "Graphic Design & Branding",
      categoryCode: "DESIGN",
      stage: GrowthStage.create,
      subtitle: "Visual creative design, promotional assets, and brand storytelling.",
      icon: Icons.palette_outlined,
      toolsAndSkills: [
        "Canva",
        "Adobe Photoshop",
        "Social Media Graphics",
        "Campaign Creatives",
        "Brand Assets",
      ],
    ),
    MarketingPillar(
      title: "Short-Form Video & Editing",
      categoryCode: "VIDEO",
      stage: GrowthStage.create,
      subtitle: "Reels production, camera footage editing, and color grading.",
      icon: Icons.movie_creation_outlined,
      toolsAndSkills: [
        "Reel Content Prep",
        "Video Editing",
        "Camera Footage Color Grading",
        "Short-Form Video Production",
      ],
    ),
    MarketingPillar(
      title: "Social Media Operations",
      categoryCode: "SOCIAL",
      stage: GrowthStage.publish,
      subtitle: "Platform management, publishing consistency, and content scheduling.",
      icon: Icons.share_rounded,
      toolsAndSkills: [
        "Social Media Management",
        "Posting & Scheduling",
        "Content Consistency",
        "Audience Engagement",
      ],
    ),
    MarketingPillar(
      title: "Paid Advertising",
      categoryCode: "PAID",
      stage: GrowthStage.promote,
      subtitle: "Targeted Meta ad campaigns and paid audience acquisition.",
      icon: Icons.campaign_outlined,
      toolsAndSkills: [
        "Meta Ads Manager",
        "Paid Campaign Setup",
        "Audience Targeting",
        "Creative Ad Formats",
      ],
    ),
    MarketingPillar(
      title: "Direct Channels",
      categoryCode: "CAMPAIGNS",
      stage: GrowthStage.promote,
      subtitle: "Outbound customer retention via targeted Email & SMS campaigns.",
      icon: Icons.mark_email_read_outlined,
      toolsAndSkills: [
        "Email Marketing",
        "SMS Marketing Outbound",
        "Customer Broadcasts",
      ],
    ),
    MarketingPillar(
      title: "Performance & Analytics",
      categoryCode: "ANALYTICS",
      stage: GrowthStage.measure,
      subtitle: "Monitoring campaign KPIs and tracking marketing performance.",
      icon: Icons.insights_rounded,
      toolsAndSkills: [
        "KPI Tracking",
        "Marketing Performance Monitoring",
        "Social Performance Insights",
      ],
    ),
  ];

  // Reusable structure for Creative Archive.
  // Real assets will be added here as images/videos become available.
  static const List<CreativeArchiveItem> archivePlaceholders = [
    CreativeArchiveItem(
      id: "enlighten-social-graphics",
      title: "Social Media Promotional Campaign Creatives",
      category: CreativeCategory.graphics,
      tool: "Canva / Adobe Photoshop",
      date: "2026",
      contextCampaign: "Enlighten Infosys Brand Campaign",
      role: "Graphic Designer & Marketer",
    ),
    CreativeArchiveItem(
      id: "enlighten-reels-editing",
      title: "Short-Form Reel Content & Color Grading",
      category: CreativeCategory.reels,
      tool: "Video Editing & Color Grading Tools",
      date: "2026",
      contextCampaign: "Social Media Video Outreach",
      role: "Video Editor & Content Creator",
    ),
    CreativeArchiveItem(
      id: "enlighten-meta-ads",
      title: "Meta Paid Advertising Campaigns",
      category: CreativeCategory.metaAds,
      tool: "Meta Ads Manager",
      date: "2026",
      contextCampaign: "Paid Audience Acquisition",
      role: "Ad Campaign Manager",
    ),
    CreativeArchiveItem(
      id: "enlighten-direct-marketing",
      title: "Customer Engagement Email & SMS Outbound",
      category: CreativeCategory.email,
      tool: "Direct Marketing Tools",
      date: "2026",
      contextCampaign: "Direct Communication Stream",
      role: "Direct Marketer",
    ),
  ];
}
