// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:play_flutter_games_hub/app/app.dart';

void main() {
  group('AppEvent', () {
    group('SessionLoaded', () {
      const session1 = 'TOKEN_1';
      const session2 = 'TOKEN_2';
      test('can be instantiated', () {
        expect(
          SessionLoaded(
            sessionToken: session1,
            isDeveloperMode: false,
          ),
          isNotNull,
        );
      });

      test('supports equality', () {
        expect(
          SessionLoaded(
            sessionToken: session1,
            isDeveloperMode: false,
          ),
          equals(
            SessionLoaded(
              sessionToken: session1,
              isDeveloperMode: false,
            ),
          ),
        );
        expect(
          SessionLoaded(
            sessionToken: session1,
            isDeveloperMode: false,
          ),
          isNot(
            equals(
              SessionLoaded(
                sessionToken: session2,
                isDeveloperMode: false,
              ),
            ),
          ),
        );
        expect(
          SessionLoaded(
            sessionToken: session1,
            isDeveloperMode: false,
          ),
          isNot(
            equals(
              SessionLoaded(
                sessionToken: session1,
                isDeveloperMode: true,
              ),
            ),
          ),
        );
      });
    });

    group('SessionLoggedOff', () {
      test('can be instantiated', () {
        expect(
          SessionLoggedOff(),
          isNotNull,
        );
      });

      test('supports equality', () {
        expect(
          SessionLoggedOff(),
          equals(
            SessionLoggedOff(),
          ),
        );
      });
    });
  });
}
