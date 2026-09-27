import 'package:flutter/material.dart';

enum DevOpsStatus { active, learning, exploring, built, inProgress, planned }

class DevOpsTopic {
  final String title;
  final String category; // e.g. "Infrastructure", "CI/CD", "OS & Terminal", "Networking"
  final DevOpsStatus status;
  final String description;
  final IconData icon;
  final Color accentColor;
  final List<String> keyConcepts;

  const DevOpsTopic({
    required this.title,
    required this.category,
    required this.status,
    required this.description,
    required this.icon,
    this.accentColor = const Color(0xFF28C840),
    required this.keyConcepts,
  });

  String get statusLabel {
    switch (status) {
      case DevOpsStatus.active:
        return "ACTIVE";
      case DevOpsStatus.learning:
        return "LEARNING";
      case DevOpsStatus.exploring:
        return "EXPLORING";
      case DevOpsStatus.built:
        return "BUILT";
      case DevOpsStatus.inProgress:
        return "IN PROGRESS";
      case DevOpsStatus.planned:
        return "PLANNED";
    }
  }

  Color get statusColor {
    switch (status) {
      case DevOpsStatus.active:
      case DevOpsStatus.built:
        return const Color(0xFF28C840); // Green
      case DevOpsStatus.learning:
      case DevOpsStatus.inProgress:
        return const Color(0xFF00F0FF); // Cyan
      case DevOpsStatus.exploring:
        return const Color(0xFF7000FF); // Purple
      case DevOpsStatus.planned:
        return const Color(0xFFFFB000); // Amber
    }
  }
}
