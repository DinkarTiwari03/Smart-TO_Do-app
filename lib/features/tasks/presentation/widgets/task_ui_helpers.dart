import 'package:flutter/material.dart';
import '../../domain/models/task.dart';

Color parseHexColor(String hexString, {Color defaultColor = const Color(0xFF1E3A5F)}) {
  try {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  } catch (_) {
    return defaultColor;
  }
}

Color getPriorityColor(TaskPriority priority) {
  switch (priority) {
    case TaskPriority.high:
      return const Color(0xFFDC2626); // Alert Red
    case TaskPriority.medium:
      return const Color(0xFFD97706); // Amber
    case TaskPriority.low:
      return const Color(0xFF2563EB); // Academic Blue
  }
}
