// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studio_repository/studio_repository.dart';
import 'package:test/test.dart';

class _MockApiClient extends Mock implements ApiClient {}

class _MockResponse extends Mock implements Response {}

void main() {
  group('StudioRepository', () {
    late ApiClient apiClient;
    late StudioRepository userRepository;

    setUp(() {
      apiClient = _MockApiClient();
      userRepository = StudioRepository(apiClient: apiClient);
    });

    test('can be instantiated', () {
      expect(
        StudioRepository(apiClient: _MockApiClient()),
        isNotNull,
      );
    });

    group('getUserStudios', () {
      const studio = Studio(
        id: '',
        name: '',
        description: '',
        userId: '',
        website: '',
      );

      test('returns the user', () async {
        final response = _MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(jsonEncode([studio.toJson()]));

        when(() => apiClient.authenticatedGet('hub/studios'))
            .thenAnswer((_) async => response);

        final result = await userRepository.getUserStudios();
        expect(result, equals([studio]));
      });

      test(
        'throws AuthenticationFailure when the user is not authenticated',
        () async {
          final response = _MockResponse();
          when(() => response.statusCode).thenReturn(HttpStatus.unauthorized);

          when(() => apiClient.authenticatedGet('hub/studios'))
              .thenAnswer((_) async => response);

          await expectLater(
            () => userRepository.getUserStudios(),
            throwsA(isA<AuthenticationFailure>()),
          );
        },
      );

      test(
        'throws UserInformationFailure when something else goes wrong',
        () async {
          final response = _MockResponse();
          when(() => response.statusCode).thenReturn(
            HttpStatus.internalServerError,
          );
          when(() => response.body).thenReturn('Error');

          when(() => apiClient.authenticatedGet('hub/studios'))
              .thenAnswer((_) async => response);

          await expectLater(
            () => userRepository.getUserStudios(),
            throwsA(
              isA<StudioInformationFailure>().having(
                (e) => e.message,
                'message',
                equals('Error getting user studios:\n500\nError'),
              ),
            ),
          );
        },
      );
    });

    group('createStudio', () {
      test('creates and returns the created studio', () {
        const studio = Studio(
          id: '',
          name: '',
          description: '',
          userId: '',
          website: '',
        );

        final response = _MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(jsonEncode(studio.toJson()));

        when(
          () => apiClient.authenticatedPost(
            'hub/studios',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode({
              'name': studio.name,
              'description': studio.description,
              'website': studio.website,
            }),
          ),
        ).thenAnswer((_) async => response);

        final result = userRepository.createStudio(
          name: studio.name,
          description: studio.description,
          website: studio.website,
        );

        expect(result, completion(equals(studio)));
      });
    });

    test('throws AuthenticationFailure when the user is not authenticated',
        () async {
      final response = _MockResponse();
      when(() => response.statusCode).thenReturn(HttpStatus.unauthorized);

      when(
        () => apiClient.authenticatedPost(
          'hub/studios',
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => response);

      await expectLater(
        () => userRepository.createStudio(
          name: '',
          description: '',
          website: '',
        ),
        throwsA(isA<AuthenticationFailure>()),
      );
    });

    test(
      'throws StudioCreationFailed when something else goes wrong',
      () async {
        final response = _MockResponse();
        when(() => response.statusCode).thenReturn(
          HttpStatus.internalServerError,
        );
        when(() => response.body).thenReturn('Error');

        when(
          () => apiClient.authenticatedPost(
            'hub/studios',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: any(named: 'body'),
          ),
        ).thenAnswer((_) async => response);

        await expectLater(
          () => userRepository.createStudio(
            name: '',
            description: '',
            website: '',
          ),
          throwsA(
            isA<StudioCreationFailed>().having(
              (e) => e.message,
              'message',
              equals('Error creating studio:\n500\nError'),
            ),
          ),
        );
      },
    );

    test(
      'throws StudioAlreadyExistsFailure when the studio already exists',
      () async {
        final response = _MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.conflict);
        when(() => response.body).thenReturn('Studio already exists');

        when(
          () => apiClient.authenticatedPost(
            'hub/studios',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: any(named: 'body'),
          ),
        ).thenAnswer((_) async => response);

        await expectLater(
          () => userRepository.createStudio(
            name: '',
            description: '',
            website: '',
          ),
          throwsA(
            isA<StudioAlreadyExistsFailure>(),
          ),
        );
      },
    );
  });
}
