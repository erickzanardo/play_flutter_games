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
}
