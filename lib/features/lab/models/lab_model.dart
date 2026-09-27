import 'package:flutter/material.dart';

enum LabStatus { experiment, prototype, inProgress, archived, completed }

class LabItem {
  final String title;
  final String category; // e.g. "Networking", "UI/UX", "Automation", "Embedded Server"
  final LabStatus status;
  final String description;
  final List<String> technologies;
  final String? link;
  final String date;
  final Color accentColor;

  const LabItem({
    required this.title,
    required this.category,
    required this.status,
    required this.description,
    required this.technologies,
    this.link,
    required this.date,
    this.accentColor = const Color(0xFFFFB000), // Amber
  });

  String get statusLabel {
    switch (status) {
      case LabStatus.experiment:
        return "EXPERIMENT";
      case LabStatus.prototype:
        return "PROTOTYPE";
      case LabStatus.inProgress:
        return "IN PROGRESS";
      case LabStatus.archived:
        return "ARCHIVED";
      case LabStatus.completed:
        return "COMPLETED";
    }
  }

  Color get statusColor {
    switch (status) {
      case LabStatus.experiment:
        return const Color(0xFFFFB000); // Amber
      case LabStatus.prototype:
        return const Color(0xFF00F0FF); // Cyan
      case LabStatus.inProgress:
        return const Color(0xFF7000FF); // Purple
      case LabStatus.archived:
        return Colors.grey;
      case LabStatus.completed:
        return const Color(0xFF28C840); // Green
    }
  }
}
