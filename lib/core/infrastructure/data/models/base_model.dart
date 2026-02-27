import 'dart:convert';

import '../../domain/entities/base_entity.dart';

class BaseModel extends BaseEntity {
  const BaseModel({
    required super.id,
    required super.name,
  });

  factory BaseModel.fromJson(Map<String, dynamic> json) => BaseModel(
        id: json["id"],
        name: json["name"].trim(),
      );

  /// Creates a [UserModel] instance from a domain [User].
  factory BaseModel.fromEntity(BaseEntity entity) => BaseModel(
        id: entity.id,
        name: entity.name,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  BaseEntity toEntity() => BaseEntity(id: id, name: name);

  @override
  String toString() => jsonEncode(toJson());
}
