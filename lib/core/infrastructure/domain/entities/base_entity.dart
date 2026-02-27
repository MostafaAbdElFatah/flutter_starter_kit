import 'package:equatable/equatable.dart';

class BaseEntity<T> extends Equatable {
  final T id;
  final String name;

  const BaseEntity({
    required this.id,
    required this.name,
  });

  BaseEntity copyWith({
    T? id,
    String? name,
  }) =>
      BaseEntity(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  @override
  List<Object?> get props => [id, name];
}

// class BaseEntity extends Equatable {
//   final int id;
//   final String name;
//
//   const BaseEntity({
//     required this.id,
//     required this.name,
//   });
//
//   BaseEntity copyWith({
//     int? id,
//     String? name,
//   }) =>
//       BaseEntity(
//         id: id ?? this.id,
//         name: name ?? this.name,
//       );
//
//   @override
//   List<Object?> get props => [id, name];
// }
