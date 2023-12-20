// ignore_for_file: prefer_const_constructors

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:play_flutter_games_hub/app/app.dart';
import 'package:token_provider/token_provider.dart';
import 'package:user_repository/user_repository.dart';

class _MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class _MockUserRepository extends Mock implements UserRepository {}

class _MockTokenProvider extends Mock implements TokenProvider {}

void main() {
  group('AppBloc', () {
    late AuthenticationRepository authenticationRepository;
    late UserRepository userRepository;
    late TokenProvider tokenProvider;

    setUp(() {
      authenticationRepository = _MockAuthenticationRepository();
      when(() => authenticationRepository.session)
          .thenAnswer((_) => const Stream.empty());

      userRepository = _MockUserRepository();
      when(userRepository.getUserProfile).thenAnswer(
        (_) async => User(
          name: 'Erick',
          id: '1',
          username: 'e',
        ),
      );

      tokenProvider = _MockTokenProvider();
      when(() => tokenProvider.current).thenAnswer((invocation) async => null);
      when(() => tokenProvider.applyToken(any())).thenAnswer(
        (invocation) async {},
      );
      when(tokenProvider.clear).thenAnswer(
        (invocation) async {},
      );
    });

    test(
      'has the correct initial state',
      () {
        expect(
          AppBloc(
            authenticationRepository: authenticationRepository,
            userRepository: userRepository,
            tokenProvider: tokenProvider,
          ).state,
          equals(AppInitial()),
        );
      },
    );

    blocTest<AppBloc, AppState>(
      'emits [authenticated] when session is added and apply the token in '
      'the provider',
      build: () => AppBloc(
        authenticationRepository: authenticationRepository,
        userRepository: userRepository,
        tokenProvider: tokenProvider,
      ),
      setUp: () {
        when(() => authenticationRepository.session).thenAnswer(
          (_) => Stream.fromIterable(['TOKEN']),
        );
      },
      expect: () => [
        AppAuthenticated(
          sessionToken: 'TOKEN',
        ),
      ],
      verify: (_) {
        verify(() => tokenProvider.applyToken('TOKEN')).called(1);
      },
    );

    blocTest<AppBloc, AppState>(
      'clears the token when the session is null',
      build: () => AppBloc(
        authenticationRepository: authenticationRepository,
        userRepository: userRepository,
        tokenProvider: tokenProvider,
      ),
      seed: () => AppAuthenticated(
        sessionToken: 'TOKEN',
      ),
      setUp: () {
        when(() => authenticationRepository.session).thenAnswer(
          (_) => Stream.fromIterable(
            [null],
          ),
        );
      },
      expect: () => [
        AppInitial(),
      ],
      verify: (_) {
        verify(() => tokenProvider.clear()).called(1);
      },
    );

    blocTest<AppBloc, AppState>(
      'emits [authenticated] when there is already a token and a valid session',
      build: () => AppBloc(
        authenticationRepository: authenticationRepository,
        userRepository: userRepository,
        tokenProvider: tokenProvider,
      ),
      setUp: () {
        when(() => tokenProvider.current).thenAnswer((_) async => 'token');
        when(userRepository.getUserSession).thenAnswer(
          (_) async => 'TOKEN',
        );
        when(userRepository.getUserProfile).thenAnswer(
          (_) async => User(
            name: 'Erick',
            id: '1',
            username: 'e',
            isDeveloper: true,
          ),
        );
      },
      expect: () => [
        AppAuthenticated(
          sessionToken: 'TOKEN',
          isDeveloperMode: true,
        ),
      ],
    );

    blocTest<AppBloc, AppState>(
      'updates developer mode on DeveloperModeChanged',
      build: () => AppBloc(
        authenticationRepository: authenticationRepository,
        userRepository: userRepository,
        tokenProvider: tokenProvider,
      ),
      seed: () => AppAuthenticated(
        sessionToken: '',
      ),
      act: (bloc) => bloc.add(DeveloperModeChanged(value: true)),
      expect: () => [
        AppAuthenticated(
          sessionToken: '',
          isDeveloperMode: true,
        ),
      ],
    );
  });
}
