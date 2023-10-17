import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:play_flutter_games_hub/profile/profile.dart';
import 'package:user_repository/user_repository.dart';

class _MockUserRepository extends Mock implements UserRepository {}

void main() {
  group('ProfileBloc', () {
    late UserRepository userRepository;

    setUp(() {
      userRepository = _MockUserRepository();
    });

    test('can be instantiated', () {
      expect(
        ProfileBloc(userRepository: _MockUserRepository()),
        isNotNull,
      );
    });

    blocTest<ProfileBloc, ProfileState>(
      'emits the profile when fetching data succeeds',
      build: () => ProfileBloc(
        userRepository: userRepository,
      ),
      setUp: () {
        when(userRepository.getUserProfile).thenAnswer(
          (_) async => const User(
            id: 'id',
            name: 'name',
            username: 'username',
          ),
        );
      },
      act: (bloc) => bloc.add(const ProfileRequested()),
      expect: () => const [
        ProfileLoadInProgress(),
        ProfileLoaded(
          User(
            id: 'id',
            name: 'name',
            username: 'username',
          ),
        ),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits ProfileLoadFailure when the fetching fails',
      build: () => ProfileBloc(
        userRepository: userRepository,
      ),
      setUp: () {
        when(userRepository.getUserProfile).thenThrow(Exception('Ops'));
      },
      act: (bloc) => bloc.add(const ProfileRequested()),
      expect: () => const [
        ProfileLoadInProgress(),
        ProfileLoadFailure(),
      ],
    );

    group('DeveloperModeChanged', () {
      blocTest<ProfileBloc, ProfileState>(
        'emits the profile saved when everything works nice',
        build: () => ProfileBloc(
          userRepository: userRepository,
        ),
        seed: () => const ProfileLoaded(
          User(
            id: 'id',
            name: 'name',
            username: 'username',
          ),
        ),
        setUp: () {
          when(() => userRepository.setDeveloperMode(value: true)).thenAnswer(
            (_) async {},
          );
        },
        act: (bloc) => bloc.add(
          const DeveloperModeChanged(
            isDeveloperMode: true,
          ),
        ),
        expect: () => const [
          ProfileSaving(
            User(
              id: 'id',
              name: 'name',
              username: 'username',
            ),
          ),
          ProfileLoaded(
            User(
              id: 'id',
              name: 'name',
              username: 'username',
              isDeveloper: true,
            ),
          ),
        ],
      );

      blocTest<ProfileBloc, ProfileState>(
        'emits the profile save failed when something goes wrong',
        build: () => ProfileBloc(
          userRepository: userRepository,
        ),
        seed: () => const ProfileLoaded(
          User(
            id: 'id',
            name: 'name',
            username: 'username',
          ),
        ),
        setUp: () {
          when(() => userRepository.setDeveloperMode(value: true)).thenThrow(
            Exception('Ops'),
          );
        },
        act: (bloc) => bloc.add(
          const DeveloperModeChanged(
            isDeveloperMode: true,
          ),
        ),
        expect: () => const [
          ProfileSaving(
            User(
              id: 'id',
              name: 'name',
              username: 'username',
            ),
          ),
          ProfileSaveFailed(
            User(
              id: 'id',
              name: 'name',
              username: 'username',
            ),
          ),
        ],
      );
    });
  });
}
