import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:hub_domain/hub_domain.dart';

/// Exception thrown when there is no authenticated user.
class AuthenticationFailure implements Exception {}

/// {@template studio_information_failure}
///  Exception thrown when there is an error getting studio information.
/// {@endtemplate}
class StudioInformationFailure implements Exception {
  /// {@macro studio_information_failure}
  const StudioInformationFailure({
    required this.message,
    required this.stackTrace,
  });

  /// Message describing the error.
  final String message;

  /// Stack trace of the error.
  final StackTrace stackTrace;
}

/// Exception thrown when a studio already exists.
class StudioAlreadyExistsFailure implements Exception {}

/// {@template studio_creation_failed}
/// Exception thrown when creating a studio fails.
/// {@endtemplate}
class StudioCreationFailed implements Exception {
  /// {@macro studio_creation_failed}
  const StudioCreationFailed({
    required this.message,
    required this.stackTrace,
  });

  /// Message describing the error.
  final String message;

  /// Stack trace of the error.
  final StackTrace stackTrace;
}

/// {@template studio_repository}
/// Repository with access to studio features
/// {@endtemplate}
class StudioRepository {
  /// {@macro studio_repository}
  const StudioRepository({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  /// Returns a list of studios from the authenticated user.
  Future<List<Studio>> getUserStudios() async {
    final response = await _apiClient.authenticatedGet('hub/studios');

    if (response.statusCode == HttpStatus.unauthorized) {
      throw AuthenticationFailure();
    } else if (response.statusCode != HttpStatus.ok) {
      throw StudioInformationFailure(
        message: 'Error getting user studios:\n${response.statusCode}'
            '\n${response.body}',
        stackTrace: StackTrace.current,
      );
    } else {
      final json = jsonDecode(response.body) as List<dynamic>;
      return json
          .map((json) => Studio.fromJson(json as Map<String, dynamic>))
          .toList();
    }
  }

  /// Creates a studio for the authenticated user.
  Future<Studio> createStudio({
    required String name,
    required String description,
    String? website,
  }) async {
    final response = await _apiClient.authenticatedPost(
      'hub/studios',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
        'website': website,
      }),
    );

    if (response.statusCode == HttpStatus.unauthorized) {
      throw AuthenticationFailure();
    } else if (response.statusCode == HttpStatus.conflict) {
      throw StudioAlreadyExistsFailure();
    } else if (response.statusCode != HttpStatus.ok) {
      throw StudioCreationFailed(
        message: 'Error creating studio:\n${response.statusCode}'
            '\n${response.body}',
        stackTrace: StackTrace.current,
      );
    } else {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Studio.fromJson(json);
    }
  }
}
