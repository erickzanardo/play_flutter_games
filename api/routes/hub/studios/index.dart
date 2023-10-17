import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:play_flutter_games_api/models/models.dart';
import 'package:studio_repository/studio_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _onGet(context),
    HttpMethod.post => _onPost(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _onGet(RequestContext context) async {
  final apiSession = context.read<ApiSession>();
  final studioRepository = context.read<StudioRepository>();

  final studios = await studioRepository.findByUserId(apiSession.user.id);

  return Response.json(
    body: studios.map((studio) => studio.toJson()).toList(),
  );
}

Future<Response> _onPost(RequestContext context) async {
  final apiSession = context.read<ApiSession>();
  final studioRepository = context.read<StudioRepository>();

  final body = await context.request.json() as Map<String, dynamic>;

  final name = body['name'] as String?;
  final description = body['description'] as String?;
  final website = body['website'] as String?;

  if (name == null || description == null) {
    return Response(
      statusCode: HttpStatus.badRequest,
      body: 'name and description are required',
    );
  }

  try {
    final studio = await studioRepository.createStudio(
      name: name,
      description: description,
      userId: apiSession.user.id,
      website: website,
    );

    return Response.json(body: studio.toJson());
  } on StudioAlreadyExistsException {
    return Response(
      statusCode: HttpStatus.conflict,
      body: 'studio with name $name already exists',
    );
  }
}
