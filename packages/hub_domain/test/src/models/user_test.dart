// ignore_for_file: prefer_const_constructors

import 'package:hub_domain/hub_domain.dart';
import 'package:test/test.dart';

void main() {
  group('User', () {
    test('can be instantiated', () {
      expect(
        User(id: 'id', username: 'username', name: 'name'),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        User(id: 'id', username: 'username', name: 'name'),
        equals(
          User(id: 'id', username: 'username', name: 'name'),
        ),
      );

      expect(
        User(id: 'id', username: 'username', name: 'name1'),
        isNot(
          equals(
            User(id: 'id', username: 'username', name: 'name'),
          ),
        ),
      );

      expect(
        User(id: 'id', username: 'username1', name: 'name'),
        isNot(
          equals(
            User(id: 'id', username: 'username', name: 'name'),
          ),
        ),
      );

      expect(
        User(id: 'id1', username: 'username', name: 'name'),
        isNot(
          equals(
            User(id: 'id', username: 'username', name: 'name'),
          ),
        ),
      );
    });

    test('can serialize to json', () {
      expect(
        User(id: 'id', username: 'username', name: 'name').toJson(),
        equals(
          <String, dynamic>{
            'id': 'id',
            'username': 'username',
            'name': 'name',
            'isDeveloper': false,
          },
        ),
      );
    });

    test('can deserialize from json', () {
      expect(
        User.fromJson(const {
          'id': 'id',
          'username': 'username',
          'name': 'name',
          'isDeveloper': true,
        }),
        equals(
          User(
            id: 'id',
            username: 'username',
            name: 'name',
            isDeveloper: true,
          ),
        ),
      );
    });

    test('copyWith returns a new instance with the updated values', () {
      expect(
        User(id: 'id', username: 'username', name: 'name').copyWith(),
        User(
          id: 'id',
          username: 'username',
          name: 'name',
        ),
      );
      expect(
        User(id: 'id', username: 'username', name: 'name').copyWith(
          id: 'id1',
          username: 'username1',
          name: 'name1',
          isDeveloper: true,
        ),
        equals(
          User(
            id: 'id1',
            username: 'username1',
            name: 'name1',
            isDeveloper: true,
          ),
        ),
      );
    });
  });
}
