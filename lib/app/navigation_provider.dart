import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);

enum NavSection { home, build, grow, operate, lab }

extension NavSectionExtension on NavSection {
  int get index => NavSection.values.indexOf(this);
  String get label {
    switch (this) {
      case NavSection.home:
        return "HOME";
      case NavSection.build:
        return "BUILD";
      case NavSection.grow:
        return "GROW";
      case NavSection.operate:
        return "OPERATE";
      case NavSection.lab:
        return "LAB";
    }
  }
}
