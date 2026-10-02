import 'package:flutter/material.dart';
import '../../../core/widgets/device_frame.dart';

class ProjectModel {
  final String title;
  final List<String> tags;
  final String description;
  final String details;
  final List<String>? highlights;
  final Color color;
  final String? url;
  final List<String>? imageAssets;
  final DeviceFrameType deviceType;
  final bool isIconMode;
  final String status; // "GitHub Repository", "Prototype", "Development Project", "Source"
  final bool isMainFeatured;

  const ProjectModel({
    required this.title,
    required this.tags,
    required this.description,
    required this.details,
    this.highlights,
    required this.color,
    this.url,
    this.imageAssets,
    this.deviceType = DeviceFrameType.mobile,
    this.isIconMode = false,
    required this.status,
    this.isMainFeatured = false,
  });
}
