// lib/data/models/category_model.dart

import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final Color color;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}
