import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/device_frame.dart';
import '../models/project_model.dart';

class ProjectsData {
  // Top 3 Main Elaborated Featured Projects
  static const List<ProjectModel> mainFeaturedProjects = [
    ProjectModel(
      title: "Basobaas Map",
      tags: ["Flutter", "Firebase", "Mapbox", "Geo-Location", "OTP Verification"],
      description: "Nepal's Premier Map-Based Rental & Housing Discovery Platform",
      details:
          "A completed Flutter + Firebase mobile application engineered specifically for Nepal's real estate and rental market. Solves location-based room and apartment discovery by embedding Mapbox for real-time map browsing, geolocation radius filtering, and interactive property pins. Features a trust-based verification workflow with owner phone OTP validation, structured Cloud Firestore database schema, and custom responsive UI cards.",
      highlights: [
        "Mapbox SDK integration for smooth real-time map browsing & location pins",
        "Firebase Firestore real-time geo-querying & listing management",
        "Trust-based owner phone verification workflow with OTP authentication",
        "Optimized image asset caching for high-speed listing loads on mobile data",
      ],
      color: AppColors.cyan,
      url: "https://github.com/ashimsap/basobaas_map",
      deviceType: DeviceFrameType.mobile,
      imageAssets: ["assets/ss/basobas1.jpg", "assets/ss/basobas2.jpg"],
      status: "GitHub Repository",
      isMainFeatured: true,
    ),
    ProjectModel(
      title: "Code Vault",
      tags: ["Server-Side Dart", "Dart Shelf", "Local LAN", "Flutter", "Micro-Server"],
      description: "Mobile-Hosted Code Snippet Manager with Embedded Local LAN HTTP Server",
      details:
          "An innovative software project where the Flutter mobile app itself embeds a lightweight HTTP web server built in Dart (using Dart Shelf). You can connect to your mobile phone over local Wi-Fi / LAN from any desktop browser to view, copy, create, and manage code snippets. Demonstrates creative system architecture by transforming a mobile device into an accessible local network micro-server without cloud hosting dependencies.",
      highlights: [
        "Embedded Dart Shelf HTTP server running inside the mobile app process",
        "Local LAN cross-device communication between desktop browsers and mobile",
        "Offline-first snippet persistence with zero external cloud dependencies",
        "REST API endpoints exposed directly from mobile phone over Wi-Fi",
      ],
      color: Color(0xFF00FF9D),
      url: "https://github.com/ashimsap/code_vault",
      deviceType: DeviceFrameType.mobile,
      imageAssets: ["assets/ss/codevault1.jpg", "assets/ss/codevault2.jpg"],
      status: "GitHub Repository",
      isMainFeatured: true,
    ),
    ProjectModel(
      title: "Stream Deck",
      tags: ["Flutter", "Arch Linux", "WebSockets", "Dart", "System Automation"],
      description: "Custom Hardware Interface & Linux Desktop Remote Control",
      details:
          "A custom Stream Deck alternative engineered for Linux power users. Features a WebSocket daemon server running on Arch Linux and a Flutter mobile client. Allows users to trigger desktop keyboard shortcuts, system commands, application launchers, media controls, and custom shell scripts in real-time over WebSockets with sub-millisecond low-latency response.",
      highlights: [
        "Bidirectional WebSocket daemon server on Arch Linux built with Dart",
        "Sub-millisecond low-latency mobile-to-desktop command execution",
        "Customizable grid keypad UI with real-time feedback & tactile haptics",
        "Linux desktop automation, media controls, and script triggers",
      ],
      color: AppColors.purple,
      url: "https://github.com/ashimsap/deck",
      deviceType: DeviceFrameType.mobileLandscape,
      imageAssets: ["assets/ss/deck1.jpg", "assets/ss/deck2.jpg"],
      status: "GitHub Repository",
      isMainFeatured: true,
    ),
  ];

  // Secondary Other Projects (Compact cards, concise descriptions)
  static const List<ProjectModel> otherProjects = [
    ProjectModel(
      title: "To-Do App",
      tags: ["Flutter", "Hive", "Local Persistence"],
      description: "Everyday productivity task manager.",
      details:
          "A task manager application built using Flutter and Hive local database for offline persistence with zero network latency.",
      color: Color(0xFFFF0055),
      url: "https://github.com/ashimsap/to_do",
      deviceType: DeviceFrameType.mobile,
      status: "Development Project",
    ),
    ProjectModel(
      title: "Dummy App",
      tags: ["R&D", "Flutter Sandbox", "Animations"],
      description: "Experimental framework sandbox.",
      details:
          "A sandbox project dedicated to rapid prototyping of novel Flutter widgets, micro-interactions, and layout constraint evaluations.",
      color: Colors.amberAccent,
      url: "https://github.com/ashimsap/dummy_app",
      deviceType: DeviceFrameType.mobile,
      isIconMode: true,
      status: "Prototype",
    ),
    ProjectModel(
      title: "Pasal",
      tags: ["Flutter", "Firebase", "eCommerce"],
      description: "eCommerce mobile application with real-time sync.",
      details:
          "A Flutter eCommerce mobile app targeting local retail with real-time product catalogs, cart management, and Firebase backend integration.",
      color: Color(0xFF00FF9D),
      url: "https://github.com/ashimsap/pasal",
      deviceType: DeviceFrameType.mobile,
      imageAssets: [
        "assets/ss/pasal1.jpg",
        "assets/ss/pasal2.jpg",
        "assets/ss/pasal3.jpg"
      ],
      status: "GitHub Repository",
    ),
  ];

  static List<ProjectModel> get projects => [
        ...mainFeaturedProjects,
        ...otherProjects,
      ];
}
