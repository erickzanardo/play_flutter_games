import 'package:dart_frog/dart_frog.dart';
import 'package:db_client/db_client.dart';
import 'package:play_flutter_games_api/middlewares/middlewares.dart';
import 'package:session_repository/session_repository.dart';
import 'package:user_repository/user_repository.dart';

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(corsHeaders())
      .use(
        provider<SessionRepository>(
          (context) => SessionRepository(dbClient: context.read<DbClient>()),
        ),
      )
      .use(
        provider<UserRepository>(
          (context) => UserRepository(dbClient: context.read<DbClient>()),
        ),
      );
}
