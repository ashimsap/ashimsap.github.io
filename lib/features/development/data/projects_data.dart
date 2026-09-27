import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/device_frame.dart';
import '../models/project_model.dart';

class ProjectsData {
  static const List<ProjectModel> projects = [
    ProjectModel(
      title: "Basobaas Map",
      tags: ["Flutter", "Firebase", "Mapbox"],
      description: "Nepal's premier map-based rental platform.",
      details:
          "A completed Flutter + Firebase project for the Nepali market. Users can browse listings on a map, see rental places around them, and use a trust-based verification workflow (Phone + optional owner consent/OTP). It uses Mapbox for maps & location.",
      color: AppColors.cyan,
      url: "https://github.com/ashimsap/basobaas_map",
      deviceType: DeviceFrameType.mobile,
      imageAssets: ["assets/ss/basobas1.jpg", "assets/ss/basobas2.jpg"],
      status: "GitHub Repository",
    ),
    ProjectModel(
      title: "Code Vault",
      tags: ["Server-Side Dart", "LAN"],
      description: "Mobile-hosted snippet manager.",
      details:
          "A code snippet vault where the mobile app itself hosts a local HTTP server. You can connect over the local LAN from any desktop browser and access your saved code snippets, demonstrating embedded local server capabilities inside a mobile app.",
      color: Color(0xFF00FF9D),
      url: "https://github.com/ashimsap/code_vault",
      deviceType: DeviceFrameType.mobile,
      imageAssets: ["assets/ss/codevault1.jpg", "assets/ss/codevault2.jpg"],
      status: "GitHub Repository",
    ),
    ProjectModel(
      title: "Stream Deck",
      tags: ["Linux", "WebSocket", "Dart"],
      description: "Custom hardware interface control.",
      details:
          "A custom Stream Deck alternative where the server runs on Arch Linux and the UI is controlled by a Flutter mobile client. It lets you trigger commands/actions on your computer from your phone using real-time WebSocket communication.",
      color: AppColors.purple,
      url: "https://github.com/ashimsap/deck",
      deviceType: DeviceFrameType.mobileLandscape,
      imageAssets: ["assets/ss/deck1.jpg", "assets/ss/deck2.jpg"],
      status: "GitHub Repository",
    ),
    ProjectModel(
      title: "To-Do App",
      tags: ["Flutter", "Hive"],
      description: "Everyday productivity task manager.",
      details:
          "A sleek task manager built with Flutter and Hive local storage. Features task creation, inline editing, completion toggles, and persistent local storage with zero network dependency.",
      color: Color(0xFFFF0055),
      url: "https://github.com/ashimsap/to_do",
      deviceType: DeviceFrameType.mobile,
      status: "Development Project",
    ),
    ProjectModel(
      title: "Dummy App",
      tags: ["R&D", "Packages", "Animations"],
      description: "Experimental framework sandbox.",
      details:
          "A sandbox project dedicated to rapid prototyping of novel Flutter widgets, micro-interactions, layout constraints, and third-party library evaluations.",
      color: Colors.amberAccent,
      url: "https://github.com/ashimsap/dummy_app",
      deviceType: DeviceFrameType.mobile,
      isIconMode: true,
      status: "Prototype",
    ),
    ProjectModel(
      title: "Pasal",
      tags: ["Flutter", "Firebase"],
      description: "eCommerce application with real-time sync.",
      details:
          "A Flutter-based eCommerce app targeting local online retail. Users can browse product categories, manage shopping cart state, and complete checkout flows with real-time data sync powered by Firebase.",
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
}
