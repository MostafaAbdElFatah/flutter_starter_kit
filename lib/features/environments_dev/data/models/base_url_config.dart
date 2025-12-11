import 'package:equatable/equatable.dart';

import '../../domain/entities/base_url_config.dart';
import '../../domain/entities/base_url_type.dart';

/// Manages the base URL configuration.
///
/// This class is immutable and supports serialization to/from JSON, allowing it
/// to be persisted locally. It uses [Equatable] for value-based comparison.
class BaseUrlConfigModel extends BaseUrlConfig {
  /// Creates a [BaseUrlConfigModel] with the URL setting and custom URL.
  const BaseUrlConfigModel({required super.type, super.customUrl});

  /// Creates a [BaseUrlConfig] with the default URL setting.
  const BaseUrlConfigModel.defaultUrl() : super.defaultUrl();

  /// Creates a [BaseUrlConfig] with a custom URL.
  const BaseUrlConfigModel.custom(super.url) : super.custom();

  /// Creates a [BaseUrlConfig] from a Entity.
  static BaseUrlConfigModel? fromEntity(BaseUrlConfig? entity) => entity == null
      ? null
      : BaseUrlConfigModel(type: entity.type, customUrl: entity.customUrl);

  /// Creates a [BaseUrlConfig] from a JSON map.
  factory BaseUrlConfigModel.fromJson(Map<String, dynamic> json) {
    final type = BaseUrlType.values.byName(json['type']);
    //return const BaseUrlConfigModel.defaultUrl();
    return BaseUrlConfigModel(type: type, customUrl: json['customUrl']);
  }

  /// Converts this [BaseUrlConfig] instance into a JSON map for persistence.
  Map<String, dynamic> toJson() => {'type': type.name, 'customUrl': customUrl};

  @override
  List<Object?> get props => [type, customUrl];

  /// Converts this data transfer object into a [BaseUrlConfig] domain entity.
  ///
  /// This is useful for mapping data from the data layer to the domain layer.
  BaseUrlConfig toEntity() => BaseUrlConfig(type: type, customUrl: customUrl);
}
