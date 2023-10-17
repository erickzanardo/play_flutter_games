// ignore_for_file: prefer_const_constructors

import 'package:hub_domain/hub_domain.dart';
import 'package:test/test.dart';

void main() {
  group('Studio', () {
    test('can be instantiated', () {
      expect(
        Studio(
          id: '',
          name: '',
          userId: '',
          description: '',
          website: '',
        ),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        Studio(
          id: '',
          name: '',
          description: '',
          userId: '',
          website: '',
        ),
        equals(
          Studio(
            id: '',
            name: '',
            userId: '',
            description: '',
            website: '',
          ),
        ),
      );

      expect(
        Studio(
          id: '',
          name: '',
          userId: '',
          description: '',
          website: '',
        ),
        isNot(
          equals(
            Studio(
              id: '1',
              name: '',
              userId: '',
              description: '',
              website: '',
            ),
          ),
        ),
      );

      expect(
        Studio(
          id: '',
          name: '',
          userId: '',
          description: '',
          website: '',
        ),
        isNot(
          equals(
            Studio(
              id: '',
              name: '1',
              userId: '',
              description: '',
              website: '',
            ),
          ),
        ),
      );

      expect(
        Studio(
          id: '',
          name: '',
          userId: '',
          description: '',
          website: '',
        ),
        isNot(
          equals(
            Studio(
              id: '',
              name: '',
              description: '1',
              userId: '',
              website: '',
            ),
          ),
        ),
      );

      expect(
        Studio(
          id: '',
          name: '',
          description: '',
          userId: '',
          website: '',
        ),
        isNot(
          equals(
            Studio(
              id: '',
              name: '',
              description: '',
              userId: '1',
              website: '',
            ),
          ),
        ),
      );

      expect(
        Studio(
          id: '',
          name: '',
          description: '',
          userId: '',
          website: '',
        ),
        isNot(
          equals(
            Studio(
              id: '',
              name: '',
              userId: '',
              description: '',
              website: '1',
            ),
          ),
        ),
      );
    });

    test('serializes to json', () {
      expect(
        Studio(
          id: 'id',
          name: 'name',
          description: 'description',
          website: 'website',
          userId: 'userId',
        ).toJson(),
        equals(
          {
            'id': 'id',
            'name': 'name',
            'description': 'description',
            'website': 'website',
            'userId': 'userId',
          },
        ),
      );
    });

    test('deserializes from json', () {
      expect(
        Studio.fromJson(
          const {
            'id': 'id',
            'name': 'name',
            'description': 'description',
            'website': 'website',
            'userId': 'userId',
          },
        ),
        equals(
          Studio(
            id: 'id',
            name: 'name',
            description: 'description',
            website: 'website',
            userId: 'userId',
          ),
        ),
      );
    });
  });
}
