import 'package:flutter/material.dart';
import '../models/lab_model.dart';

class LabData {
  static const List<LabItem> items = [
    LabItem(
      title: "Embedded Mobile HTTP Server",
      category: "Server-Side Dart",
      status: LabStatus.completed,
      description:
          "Embedded a lightweight HTTP server inside a Dart mobile process to serve code snippet vaults to local LAN web browsers without external cloud hosting.",
      technologies: ["Dart Shelf", "HTTP", "LAN Sockets", "Flutter"],
      link: "https://github.com/ashimsap/code_vault",
      date: "2025-10",
      accentColor: Color(0xFF00FF9D),
    ),
    LabItem(
      title: "Linux Remote Controller via WebSockets",
      category: "Networking / Automation",
      status: LabStatus.completed,
      description:
          "Developed a bidirectional WebSocket bridge allowing a Flutter mobile app to act as a custom hardware Stream Deck for controlling Manjaro Linux shortcuts.",
      technologies: ["WebSocket", "Linux Shell", "Dart", "Manjaro"],
      link: "https://github.com/ashimsap/deck",
      date: "2025-11",
      accentColor: Color(0xFF7000FF),
    ),
    LabItem(
      title: "Cyberpunk Custom Canvas Painters",
      category: "UI/UX Experiment",
      status: LabStatus.inProgress,
      description:
          "R&D into hardware-accelerated CustomPainter visual effects including radial spotlight gradients, perspective grid lines, and scanline shader passes.",
      technologies: ["Flutter Canvas", "CustomPainter", "Shaders"],
      date: "2026-01",
      accentColor: Color(0xFF00F0FF),
    ),
    LabItem(
      title: "GitHub Actions CI/CD Pipeline Docs & Automation",
      category: "DevOps Pipeline",
      status: LabStatus.inProgress,
      description:
          "Designing automated linting (`flutter analyze`), unit testing, and web distribution scripts for GitHub Actions to demonstrate continuous delivery.",
      technologies: ["GitHub Actions", "YAML", "Bash", "Flutter Web"],
      date: "2026-02",
      accentColor: Color(0xFFFFB000),
    ),
  ];
}
