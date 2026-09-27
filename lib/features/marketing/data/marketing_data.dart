import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/marketing_model.dart';

class MarketingData {
  static const List<MarketingPillar> pillars = [
    MarketingPillar(
      title: "SEO & Search Strategy",
      subtitle: "Organic search optimization, technical SEO & keyword research",
      icon: Icons.search_rounded,
      skills: [
        "Technical SEO Audits",
        "On-Page Optimization",
        "Keyword Research",
        "Search Intent Mapping",
        "Site Speed Optimization",
      ],
    ),
    MarketingPillar(
      title: "Content Strategy & Copywriting",
      subtitle: "Valuable content distribution that attracts and retains audiences",
      icon: Icons.article_outlined,
      skills: [
        "Content Funnel Architecture",
        "Technical Writing",
        "Social Media Planning",
        "Editorial Calendar Management",
        "Brand Messaging",
      ],
    ),
    MarketingPillar(
      title: "Analytics & Conversion Strategy",
      subtitle: "Data-informed decision making and funnel optimization",
      icon: Icons.insights_rounded,
      skills: [
        "Google Analytics (GA4)",
        "User Funnel Analysis",
        "A/B Testing Methodologies",
        "Conversion Rate Optimization (CRO)",
        "UTM Tracking & Attribution",
      ],
    ),
    MarketingPillar(
      title: "Audience & Community Growth",
      subtitle: "Building long-term user retention and engagement loops",
      icon: Icons.groups_rounded,
      skills: [
        "Community Management",
        "Email Marketing Loops",
        "User Onboarding UX",
        "Social Media Growth Strategy",
        "Feedback Loops & Surveys",
      ],
    ),
  ];

  static const List<MarketingCaseStudy> caseStudies = [
    MarketingCaseStudy(
      id: "app-launch-seo",
      title: "Developer Brand & Digital Footprint Strategy",
      category: MarketingCategory.seo,
      objective: "Establish a search-engine optimized digital identity and portfolio ecosystem.",
      approach: "Engineered performant, accessible web architecture with structured metadata, optimized assets, semantic HTML tags, and search index submission.",
      channels: ["Organic Search (Google)", "GitHub Showcase", "LinkedIn Professional Network"],
      tools: ["Google Search Console", "Google Analytics (GA4)", "Lighthouse CI", "Flutter Web"],
      keyLearnings: [
        "Technical web performance (Core Web Vitals) directly impacts search engine indexing.",
        "Semantic structure and fast load times build organic domain authority over time.",
      ],
      metrics: [
        "Lighthouse Performance: 90+",
        "Index Status: Fully Indexed",
        "Organic Footprint: Established",
      ],
      accentColor: AppColors.purple,
    ),
    MarketingCaseStudy(
      id: "product-growth-experiment",
      title: "App Store & Web Funnel Optimization",
      category: MarketingCategory.analytics,
      objective: "Optimize conversion rate from discovery to app engagement for mobile software products.",
      approach: "Analyzed landing page user drop-offs, streamlined primary CTA placement, and implemented clear product screenshots showcasing core value.",
      channels: ["Web Landing Pages", "Social Previews", "Direct Referral Links"],
      tools: ["Hotjar Heatmaps", "GA4 Event Tracking", "Figma Design Mockups"],
      keyLearnings: [
        "Interactive previews and live demos reduce bounce rate by over 30% compared to static text.",
        "Clear call-to-action (CTA) positioning dramatically improves click-through rate.",
      ],
      metrics: [
        "Funnel Stage: Active Architecture",
        "A/B Testing: Continuous Iteration",
      ],
      accentColor: Color(0xFF9D00FF),
    ),
  ];
}
