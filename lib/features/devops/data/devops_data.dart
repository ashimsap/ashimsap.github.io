import 'package:flutter/material.dart';
import '../models/devops_model.dart';

class DevOpsData {
  static const List<DevOpsTopic> topics = [
    DevOpsTopic(
      title: "Linux Workstation & Terminal",
      category: "OS & Systems",
      status: DevOpsStatus.active,
      description:
          "Daily driver setup using Manjaro Linux. Proficient in bash shell automation, process management, SSH key configurations, and system troubleshooting.",
      icon: Icons.terminal_rounded,
      keyConcepts: ["Bash Scripting", "Systemd Services", "File Permissions", "SSH & Security", "Package Managers"],
    ),
    DevOpsTopic(
      title: "GitHub Actions & Automation",
      category: "CI/CD Pipelines",
      status: DevOpsStatus.built,
      description:
          "Configured automated deployment workflows for Flutter Web applications to GitHub Pages using custom GitHub Action runners and release pipelines.",
      icon: Icons.account_tree_rounded,
      keyConcepts: ["YAML Workflows", "Build Automation", "Secrets Management", "GitHub Pages Deployment"],
    ),
    DevOpsTopic(
      title: "Git & Source Control Workflows",
      category: "Version Control",
      status: DevOpsStatus.active,
      description:
          "Branching strategies, rebase vs merge, commit hygiene, pull request reviews, and multi-repo project management.",
      icon: Icons.merge_type_rounded,
      keyConcepts: ["Feature Branching", "Interactive Rebase", "Git Hooks", "Conflict Resolution"],
    ),
    DevOpsTopic(
      title: "Docker & Containerization",
      category: "Infrastructure",
      status: DevOpsStatus.learning,
      description:
          "Exploring Docker container creation, Dockerfiles, volume persistence, multi-stage builds, and running containerized web applications locally.",
      icon: Icons.view_in_ar_rounded,
      keyConcepts: ["Dockerfiles", "Container Lifecycle", "Docker Compose", "Image Optimization"],
    ),
    DevOpsTopic(
      title: "Networking & LAN Services",
      category: "Networking",
      status: DevOpsStatus.exploring,
      description:
          "Built custom LAN communication projects using WebSockets and embedded HTTP servers in Dart for device-to-device streaming and control.",
      icon: Icons.lan_rounded,
      keyConcepts: ["TCP/UDP Basics", "HTTP Protocols", "WebSockets", "LAN Server Hosting", "Port Forwarding"],
    ),
    DevOpsTopic(
      title: "Nginx & Reverse Proxies",
      category: "Web Servers",
      status: DevOpsStatus.learning,
      description:
          "Learning web server configuration, virtual host blocks, SSL/TLS certificate setups (Let's Encrypt), and reverse proxying static web builds.",
      icon: Icons.dns_rounded,
      keyConcepts: ["Nginx Config", "Reverse Proxying", "SSL/TLS Setup", "Static Asset Hosting"],
    ),
    DevOpsTopic(
      title: "Cloud Infrastructure (AWS/GCP)",
      category: "Cloud",
      status: DevOpsStatus.planned,
      description:
          "Planned exploration into cloud computing fundamentals, compute instances (EC2/GCE), S3 buckets, IAM roles, and cloud network security.",
      icon: Icons.cloud_queue_rounded,
      keyConcepts: ["Compute Instances", "Object Storage", "IAM Roles", "Basic Cloud Networking"],
    ),
  ];
}
