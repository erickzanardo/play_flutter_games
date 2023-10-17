import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'studio.g.dart';

/// {@template studio}
/// Studio model.
/// {@endtemplate}
@JsonSerializable()
class Studio extends Equatable {
  /// {@macro studio}
  const Studio({
    required this.id,
    required this.name,
    required this.description,
    required this.userId,
    required this.website,
  });

  /// {@macro studio}
  factory Studio.fromJson(Map<String, dynamic> json) => _$StudioFromJson(json);

  /// Studio id.
  final String id;

  /// Studio name.
  final String name;

  /// Studio description.
  final String description;

  /// Studio owner id.
  final String userId;

  /// Studio website
  final String? website;

  /// Returns this instance as a JSON map.
  Map<String, dynamic> toJson() => _$StudioToJson(this);

  @override
  List<Object?> get props => [id, name, description, website, userId];
}
