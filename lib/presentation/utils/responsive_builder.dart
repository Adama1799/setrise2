// lib/presentation/utils/responsive_builder.dart
import 'package:flutter/material.dart';
import 'universal_platform.dart';

class ResponsiveBuilder {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  static DeviceType getDeviceType(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    
    if (size < mobileBreakpoint) {
      return DeviceType.mobile;
    } else if (size < tabletBreakpoint) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  static bool isMobile(BuildContext context) =>
      getDeviceType(context) == DeviceType.mobile;

  static bool isTablet(BuildContext context) =>
      getDeviceType(context) == DeviceType.tablet;

  static bool isDesktop(BuildContext context) =>
      getDeviceType(context) == DeviceType.desktop;

  static double getMaxWidth(BuildContext context) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return MediaQuery.of(context).size.width;
      case DeviceType.tablet:
        return 600;
      case DeviceType.desktop:
        return 900;
    }
  }
}

enum DeviceType { mobile, tablet, desktop }

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveWidget({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveBuilder.getDeviceType(context);

    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }
}
