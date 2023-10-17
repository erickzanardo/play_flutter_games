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
          website: '',
        ),
        equals(
          Studio(
            id: '',
            name: '',
            description: '',
            website: '',
          ),
        ),
      );

      expect(
        Studio(
          id: '',
          name: '',
          description: '',
          website: '',
        ),
        isNot(
          equals(
            Studio(
              id: '1',
              name: '',
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
          description: '',
          website: '',
        ),
        isNot(
          equals(
            Studio(
              id: '',
              name: '1',
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
          description: '',
          website: '',
        ),
        isNot(
          equals(
            Studio(
              id: '',
              name: '',
              description: '1',
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
          website: '',
        ),
        isNot(
          equals(
            Studio(
              id: '',
              name: '',
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
        ).toJson(),
        equals(
          {
            'id': 'id',
            'name': 'name',
            'description': 'description',
            'website': 'website',
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
          },
        ),
        equals(
          Studio(
            id: 'id',
            name: 'name',
            description: 'description',
            website: 'website',
          ),
        ),
      );
    });
  });
}
