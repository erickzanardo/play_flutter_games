import 'package:db_client/db_client.dart';
import 'package:hub_domain/hub_domain.dart';

/// Exception thrown when a user tries to sign up with a username
class StudioAlreadyExistsException implements Exception {}

/// {@template studio_repository}
/// Repository for processing studio data
/// {@endtemplate}
class StudioRepository {
  /// {@macro studio_repository}
  const StudioRepository({
    required DbClient dbClient,
  }) : _dbClient = dbClient;

  final DbClient _dbClient;

  static const _entity = 'studios';

  /// Get user's studios.
  Future<List<Studio>> findByUserId(String userId) async {
    final data = await _dbClient.findByField(
      _entity,
      'userId',
      userId,
    );

    return data.map(Studio.fromJson).toList();
  }

  /// Returns a [Studio] with the provided [name].
  Future<Studio?> findByName(String name) async {
    final result = await _dbClient.findByField(
      _entity,
      'name',
      name,
    );

    if (result.isNotEmpty) {
      return Studio.fromJson(result.first);
    }

    return null;
  }

  /// Create a studio.
  Future<Studio> createStudio({
    required String name,
    required String description,
    required String userId,
    required String? website,
  }) async {
    final existingStudio = await findByName(name);

    if (existingStudio != null) {
      throw StudioAlreadyExistsException();
    }

    final data = <String, dynamic>{
      'name': name,
      'description': description,
      'userId': userId,
      'website': website,
    };

    final id = await _dbClient.add(_entity, data);

    return Studio(
      id: id,
      name: name,
      description: description,
      userId: userId,
      website: website,
    );
  }
}
