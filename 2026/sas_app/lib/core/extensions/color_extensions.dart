import 'package:flutter/material.dart';

extension ColorExtensions on Color {
  Color withOpacityCompat(double opacity) {
    return withValues(alpha: opacity);
  }
}
