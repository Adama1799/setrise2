import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:setrise/core/theme/app_colors.dart';

Future<Color> getDominantColor(String imageUrl) async {
  try {
    final image = NetworkImage(imageUrl);
    final completer = Completer<ui.Image>();
    final stream = image.resolve(ImageConfiguration.empty);
    stream.addListener(ImageStreamListener((info, _) => completer.complete(info.image)));
    final ui.Image img = await completer.future;
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return AppColors.mediumGray;

    final buffer = byteData.buffer;
    final width = img.width;
    final height = img.height;
    final x = (width / 2).floor();
    final y = (height / 2).floor();
    final index = (y * width + x) * 4;
    final r = buffer.asUint8List()[index];
    final g = buffer.asUint8List()[index + 1];
    final b = buffer.asUint8List()[index + 2];
    return Color.fromARGB(255, r, g, b);
  } catch (e) {
    return AppColors.mediumGray;
  }
}
