import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:play_flutter_games_hub/app/app.dart';
import 'package:play_flutter_games_hub/auth/auth.dart';
import 'package:studio_repository/studio_repository.dart';
import 'package:token_provider/token_provider.dart';
import 'package:user_repository/user_repository.dart';

class _MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class _MockUserRepository extends Mock implements UserRepository {}

class _MockTokenProvider extends Mock implements TokenProvider {}

class _MockPostRepository extends Mock implements PostRepository {}

class _MockStudioRepository extends Mock implements StudioRepository {}

void main() {
  group('App', () {
    late AuthenticationRepository authenticationRepository;
    late TokenProvider tokenProvider;

    setUp(() {
      authenticationRepository = _MockAuthenticationRepository();

      when(() => authenticationRepository.session)
          .thenAnswer((_) => const Stream.empty());

      tokenProvider = _MockTokenProvider();
      when(() => tokenProvider.current).thenAnswer((invocation) async => null);
    });
    testWidgets('renders AuthViewView', (tester) async {
      await tester.pumpWidget(
        App(
          authenticationRepository: authenticationRepository,
          userRepository: _MockUserRepository(),
          postRepository: _MockPostRepository(),
          studioRepository: _MockStudioRepository(),
          tokenProvider: tokenProvider,
        ),
      );
      expect(find.byType(AuthViewView), findsOneWidget);
    });
  });
}
