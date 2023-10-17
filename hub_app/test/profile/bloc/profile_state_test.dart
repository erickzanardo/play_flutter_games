// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:play_flutter_games_hub/profile/profile.dart';

void main() {
  group('ProfileInitial', () {
    test('can be instantiated', () {
      expect(
        ProfileInitial(),
        isNotNull,
      );
    });

    test('supports value comparison', () {
      expect(
        ProfileInitial(),
        equals(
          ProfileInitial(),
        ),
      );
    });
  });

  group('ProfileLoadInProgress', () {
    test('can be instantiated', () {
      expect(
        ProfileLoadInProgress(),
        isNotNull,
      );
    });

    test('supports value comparison', () {
      expect(
        ProfileLoadInProgress(),
        equals(
          ProfileLoadInProgress(),
        ),
      );
    });
  });

  group('ProfileLoaded', () {
    test('can be instantiated', () {
      expect(
        ProfileLoaded(
          User(
            id: 'id',
            name: 'name',
            username: 'username',
          ),
        ),
        isNotNull,
      );
    });

    test('supports value comparison', () {
      expect(
        ProfileLoaded(
          User(
            id: 'id',
            name: 'name',
            username: 'username',
          ),
        ),
        equals(
          ProfileLoaded(
            User(
              id: 'id',
              name: 'name',
              username: 'username',
            ),
          ),
        ),
      );

      expect(
        ProfileLoaded(
          User(
            id: 'id',
            name: 'name',
            username: 'username',
          ),
        ),
        equals(
          isNot(
            ProfileLoaded(
              User(
                id: 'id2',
                name: 'name',
                username: 'username',
              ),
            ),
          ),
        ),
      );
    });
  });

  group('ProfileSavingFailed', () {
    test('can be instantiated', () {
      expect(
        ProfileSaveFailed(
          User(
            id: 'id',
            name: 'name',
            username: 'username',
          ),
        ),
        isNotNull,
      );
    });

    test('supports value comparison', () {
      expect(
        ProfileSaveFailed(
          User(
            id: 'id',
            name: 'name',
            username: 'username',
          ),
        ),
        equals(
          ProfileSaveFailed(
            User(
              id: 'id',
              name: 'name',
              username: 'username',
            ),
          ),
        ),
      );

      expect(
        ProfileSaveFailed(
          User(
            id: 'id',
            name: 'name',
            username: 'username',
          ),
        ),
        equals(
          isNot(
            ProfileSaveFailed(
              User(
                id: 'id2',
                name: 'name',
                username: 'username',
              ),
            ),
          ),
        ),
      );
    });
  });
  group('ProfileSaving', () {
    test('can be instantiated', () {
      expect(
        ProfileSaving(
          User(
            id: 'id',
            name: 'name',
            username: 'username',
          ),
        ),
        isNotNull,
      );
    });

    test('supports value comparison', () {
      expect(
        ProfileSaving(
          User(
            id: 'id',
            name: 'name',
            username: 'username',
          ),
        ),
        equals(
          ProfileSaving(
            User(
              id: 'id',
              name: 'name',
              username: 'username',
            ),
          ),
        ),
      );

      expect(
        ProfileSaving(
          User(
            id: 'id',
            name: 'name',
            username: 'username',
          ),
        ),
        equals(
          isNot(
            ProfileSaving(
              User(
                id: 'id2',
                name: 'name',
                username: 'username',
              ),
            ),
          ),
        ),
      );
    });
  });

  group('ProfileLoadFailure', () {
    test('can be instantiated', () {
      expect(
        ProfileLoadFailure(),
        isNotNull,
      );
    });

    test('supports value comparison', () {
      expect(
        ProfileLoadFailure(),
        equals(
          ProfileLoadFailure(),
        ),
      );
    });
  });
}
