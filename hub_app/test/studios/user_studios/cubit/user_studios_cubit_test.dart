// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:play_flutter_games_hub/studios/user_studios/cubit/user_studios_cubit.dart';
import 'package:studio_repository/studio_repository.dart';

class _MockStudioRepository extends Mock implements StudioRepository {}

void main() {
  group('UserStudiosCubit', () {
    late StudioRepository _studioRepository;

    setUp(() {
      _studioRepository = _MockStudioRepository();
    });

    test('has the correct initial state', () {
      expect(
        UserStudiosCubit(studioRepository: _MockStudioRepository()).state,
        equals(
          UserStudiosState(),
        ),
      );
    });

    blocTest<UserStudiosCubit, UserStudiosState>(
      "fetch the user's studios",
      build: () => UserStudiosCubit(studioRepository: _studioRepository),
      setUp: () {
        when(() => _studioRepository.getUserStudios()).thenAnswer(
          (_) async => [
            Studio(
              id: '',
              name: '',
              description: '',
              userId: '',
              website: '',
            ),
          ],
        );
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        UserStudiosState(
          status: UserStudiosStatus.loading,
        ),
        UserStudiosState(
          status: UserStudiosStatus.success,
          studios: [
            Studio(
              id: '',
              name: '',
              description: '',
              userId: '',
              website: '',
            ),
          ],
        ),
      ],
    );

    blocTest<UserStudiosCubit, UserStudiosState>(
      'emits failure when the repository throws error',
      build: () => UserStudiosCubit(studioRepository: _studioRepository),
      setUp: () {
        when(() => _studioRepository.getUserStudios()).thenThrow(
          Exception('Ops'),
        );
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        UserStudiosState(
          status: UserStudiosStatus.loading,
        ),
        UserStudiosState(
          status: UserStudiosStatus.failure,
        ),
      ],
    );
  });
}
