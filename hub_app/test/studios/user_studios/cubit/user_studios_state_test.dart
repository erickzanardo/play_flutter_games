// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter_test/flutter_test.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:play_flutter_games_hub/studios/user_studios/cubit/user_studios_cubit.dart';

void main() {
  group('UserStudiosState', () {
    test('can be instantiated', () {
      expect(UserStudiosState(), isNotNull);
    });

    test('supports equality comparison', () {
      expect(UserStudiosState(), equals(UserStudiosState()));

      expect(
        UserStudiosState(status: UserStudiosStatus.loading),
        isNot(equals(UserStudiosState(status: UserStudiosStatus.success))),
      );

      expect(
        UserStudiosState(),
        isNot(
          equals(
            UserStudiosState(
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
          ),
        ),
      );
    });

    test('copyWith returns a instance with the copied values', () {
      final state = UserStudiosState(
        status: UserStudiosStatus.loading,
        studios: [
          Studio(
            id: '',
            name: '',
            description: '',
            userId: '',
            website: '',
          ),
        ],
      );

      var copy = state.copyWith(
        status: UserStudiosStatus.success,
      );

      expect(copy.status, equals(UserStudiosStatus.success));

      copy = state.copyWith(
        studios: [],
      );
      expect(copy.studios, isEmpty);
    });
  });
}
