// lib/data/models/base_model.dart
abstract class BaseModel<T> {
  T toEntity();
  Map<String, dynamic> toJson();
}
