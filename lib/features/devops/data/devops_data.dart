import 'package:flutter/material.dart';
import '../models/devops_model.dart';

class DevOpsData {
  static const SelfHostedProjectModel jellyfinProject = SelfHostedProjectModel(
    title: "Self-Hosted Jellyfin Media Server",
    subtitle: "Personal Home Server Infrastructure",
    description:
        "Designed and configured a personal media server on Linux. Utilizes Nginx as a reverse proxy, DuckDNS for dynamic domain resolution over IPv6, and secure network routing.",
    technologies: [
      "Linux",
      "Jellyfin",
      "Nginx",
      "DuckDNS",
      "IPv6",
      "Reverse Proxy",
      "Networking",
      "Self-Hosting",
    ],
    architectureSteps: [
      "Internet / Domain",
      "DuckDNS DDNS",
      "IPv6 Networking",
      "Nginx Reverse Proxy",
      "Jellyfin Service",
      "Media Streaming",
    ],
    workflowNote:
        "Primary development and server operations are performed on Linux (Arch Linux). Windows is maintained in dual-boot for marketing tool compatibility.",
  );

  static const List<DevOpsTopic> topics = [
    DevOpsTopic(
      title: "Linux Environment & Workstation",
      category: "Primary Operating System",
      status: DevOpsStatus.active,
      description:
          "Daily driver setup on Arch Linux for software development and server self-hosting. Utilizes Windows as a secondary environment for specific marketing software tools.",
      icon: Icons.terminal_rounded,
      keyConcepts: [
        "Primary Linux (Arch)",
        "Secondary Windows Setup",
        "Bash Scripting",
        "Systemd Services",
        "SSH Key Auth",
      ],
    ),
    DevOpsTopic(
      title: "GitHub Actions CI/CD Pipeline",
      category: "Continuous Integration",
      status: DevOpsStatus.built,
      description:
          "Configured automated GitHub Actions workflows that compile Flutter Web releases and deploy directly to GitHub Pages.",
      icon: Icons.account_tree_rounded,
      keyConcepts: [
        "GitHub Actions",
        "YAML Workflows",
        "Build Automation",
        "GitHub Pages Deployment",
      ],
    ),
    DevOpsTopic(
      title: "Nginx & Reverse Proxies",
      category: "Web Infrastructure",
      status: DevOpsStatus.built,
      description:
          "Configured Nginx reverse proxying for local self-hosted services, managing virtual hosts, SSL/TLS certs, and IPv6 traffic routing.",
      icon: Icons.dns_rounded,
      keyConcepts: [
        "Nginx Config",
        "Reverse Proxying",
        "Virtual Hosts",
        "SSL Certificates",
        "IPv6 Routing",
      ],
    ),
    DevOpsTopic(
      title: "Docker & Containerization",
      category: "Infrastructure Learning",
      status: DevOpsStatus.learning,
      description:
          "Exploring Docker containerization, Dockerfiles, volume mounts, and running containerized local services.",
      icon: Icons.view_in_ar_rounded,
      keyConcepts: [
        "Dockerfiles",
        "Container Lifecycle",
        "Docker Compose",
        "Local Service Isolation",
      ],
    ),
    DevOpsTopic(
      title: "Networking & LAN Communication",
      category: "Networking Fundamentals",
      status: DevOpsStatus.active,
      description:
          "Implemented LAN device-to-device streaming using WebSockets and embedded HTTP servers in Dart for custom hardware control.",
      icon: Icons.lan_rounded,
      keyConcepts: [
        "IPv6 & IPv4",
        "WebSockets",
        "Embedded HTTP Servers",
        "Port Management",
      ],
    ),
    DevOpsTopic(
      title: "Git & Source Control",
      category: "Version Control",
      status: DevOpsStatus.active,
      description:
          "Version control hygiene, feature branching, rebase vs merge, commit history maintenance, and multi-repository management.",
      icon: Icons.merge_type_rounded,
      keyConcepts: [
        "Feature Branching",
        "Interactive Rebase",
        "Git Hooks",
        "Clean Commit History",
      ],
    ),
    DevOpsTopic(
      title: "Cloud Services (AWS / GCP)",
      category: "Cloud Learning Roadmap",
      status: DevOpsStatus.planned,
      description:
          "Planned learning path covering cloud compute instances, object storage, IAM access roles, and cloud networking basics.",
      icon: Icons.cloud_queue_rounded,
      keyConcepts: [
        "Compute Instances",
        "Object Storage",
        "IAM Access Control",
        "Cloud Security Basics",
      ],
    ),
  ];
}
