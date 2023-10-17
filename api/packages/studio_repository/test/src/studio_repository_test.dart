// ignore_for_file: prefer_const_constructors
import 'package:db_client/db_client.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studio_repository/studio_repository.dart';
import 'package:test/test.dart';

class _MockDbClient extends Mock implements DbClient {}

void main() {
  group('StudioRepository', () {
    late DbClient dbClient;
    late StudioRepository repository;

    setUp(() {
      dbClient = _MockDbClient();
      repository = StudioRepository(dbClient: dbClient);
    });

    test('can be instantiated', () {
      expect(
        StudioRepository(dbClient: _MockDbClient()),
        isNotNull,
      );
    });

    test('findByUserId returns the studios of that user', () async {
      when(() => dbClient.findByField('studios', 'userId', '1')).thenAnswer(
        (_) async => [
          {
            'id': 'id',
            'name': 'CherryBit',
            'description': 'Cool studio',
            'userId': '1',
            'website': 'https://cherybit.studio',
          },
        ],
      );

      final studios = await repository.findByUserId('1');
      expect(
        studios,
        equals([
          Studio(
            id: 'id',
            name: 'CherryBit',
            description: 'Cool studio',
            userId: '1',
            website: 'https://cherybit.studio',
          ),
        ]),
      );
    });

    test('findByName returns the studio that matches that name', () async {
      when(() => dbClient.findByField('studios', 'name', 'CherryBit'))
          .thenAnswer(
        (_) async => [
          {
            'id': 'id',
            'name': 'CherryBit',
            'description': 'Cool studio',
            'userId': '1',
            'website': 'https://cherybit.studio',
          },
        ],
      );

      final studios = await repository.findByName('CherryBit');
      expect(
        studios,
        equals(
          Studio(
            id: 'id',
            name: 'CherryBit',
            description: 'Cool studio',
            userId: '1',
            website: 'https://cherybit.studio',
          ),
        ),
      );
    });

    test('findByName returns null when there is none to be found', () async {
      when(() => dbClient.findByField('studios', 'name', 'CherryBit'))
          .thenAnswer(
        (_) async => [],
      );

      final studios = await repository.findByName('CherryBit');
      expect(studios, isNull);
    });

    group('createStudio', () {
      test('creates a new studio', () async {
        when(() => dbClient.findByField('studios', 'name', 'CherryBit'))
            .thenAnswer(
          (_) async => [],
        );
        when(
          () => dbClient.add(
            'studios',
            {
              'name': 'CherryBit',
              'description': 'Cool studio',
              'userId': '1',
              'website': 'https://cherybit.studio',
            },
          ),
        ).thenAnswer(
          (_) async => '1',
        );

        final studio = await repository.createStudio(
          name: 'CherryBit',
          description: 'Cool studio',
          userId: '1',
          website: 'https://cherybit.studio',
        );

        expect(
          studio,
          equals(
            Studio(
              id: '1',
              name: 'CherryBit',
              description: 'Cool studio',
              userId: '1',
              website: 'https://cherybit.studio',
            ),
          ),
        );
      });

      test(
        'throws studio already exists when there is already one with that name',
        () async {
          when(() => dbClient.findByField('studios', 'name', 'CherryBit'))
              .thenAnswer(
            (_) async => [
              {
                'id': 'id',
                'name': 'CherryBit',
                'description': 'Cool studio',
                'userId': '1',
                'website': 'https://cherybit.studio',
              },
            ],
          );
          when(
            () => dbClient.add(
              'studios',
              {
                'name': 'CherryBit',
                'description': 'Cool studio',
                'userId': '1',
                'website': 'https://cherybit.studio',
              },
            ),
          ).thenAnswer(
            (_) async => '1',
          );

          await expectLater(
            () => repository.createStudio(
              name: 'CherryBit',
              description: 'Cool studio',
              userId: '1',
              website: 'https://cherybit.studio',
            ),
            throwsA(isA<StudioAlreadyExistsException>()),
          );
        },
      );
    });
  });
}
