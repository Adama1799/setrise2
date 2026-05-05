import 'package:flutter/material.dart';

extension ResponsiveContext on BuildContext {
  double get horizontalPadding {
    final width = MediaQuery.of(this).size.width;
    if (width > 1200) return 32.0;
    if (width > 800) return 24.0;
    return 16.0;
  }

  int get gridColumns {
    final width = MediaQuery.of(this).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    return 2;
  }
}
