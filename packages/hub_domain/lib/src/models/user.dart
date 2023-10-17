import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// {@template user}
/// User model.
/// {@endtemplate}
@JsonSerializable()
class User extends Equatable {
  /// {@macro user}
  const User({
    required this.id,
    required this.username,
    required this.name,
    this.isDeveloper = false,
  });

  /// {@macro from_json}
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// User id.
  final String id;

  /// User username.
  final String username;

  /// User name.
  final String name;

  /// If the user is a developer.
  final bool isDeveloper;

  /// Returns this object as a JSON map.
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [id, username, name, isDeveloper];
}
