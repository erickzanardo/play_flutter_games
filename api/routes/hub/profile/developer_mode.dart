import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:play_flutter_games_api/models/models.dart';
import 'package:user_repository/user_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _onPost(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _onPost(RequestContext context) async {
  final apiSession = context.read<ApiSession>();
  final body = await context.request.json() as Map<String, dynamic>;

  final value = body['value'];

  if (value == null || value is! bool) {
    return Response(
      statusCode: HttpStatus.badRequest,
      body: 'Invalid request, expected: {"value": bool}',
    );
  }

  final userRepository = context.read<UserRepository>();
  await userRepository.setDeveloperMode(
    userId: apiSession.user.id,
    value: value,
  );

  return Response(statusCode: HttpStatus.noContent);
}
