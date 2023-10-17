import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:play_flutter_games_api/models/models.dart';
import 'package:studio_repository/studio_repository.dart';
import 'package:test/test.dart';

import '../../../../routes/hub/studios/index.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockStudioRepository extends Mock implements StudioRepository {}

void main() {
  group('Profile', () {
    const user = User(
      id: '1',
      name: 'Test User',
      username: '',
    );

    final session = Session(
      id: 'id',
      token: 'token',
      userId: 'userId',
      expiryDate: DateTime(2021),
      createdAt: DateTime(2021).subtract(
        const Duration(days: 1),
      ),
    );

    final apiSession = ApiSession(user: user, session: session);

    late StudioRepository studioRepository;

    setUp(() {
      studioRepository = _MockStudioRepository();

      when(() => studioRepository.findByUserId(apiSession.user.id)).thenAnswer(
        (_) async => <Studio>[
          Studio(
            id: '1',
            name: 'Test Studio',
            userId: apiSession.user.id,
            website: 'https://cherrybit.studio',
            description: 'cool studio',
          ),
        ],
      );
    });

    group('GET /hub/studios', () {
      test("returns 200 with the user's studios", () async {
        final context = _MockRequestContext();
        final request = _MockRequest();

        when(() => context.request).thenReturn(request);
        when(() => request.method).thenReturn(HttpMethod.get);
        when(() => context.read<ApiSession>()).thenReturn(apiSession);
        when(() => context.read<StudioRepository>())
            .thenReturn(studioRepository);

        final response = await route.onRequest(context);

        expect(response.statusCode, equals(200));
        expect(
          await response.json(),
          equals(
            [
              {
                'id': '1',
                'name': 'Test Studio',
                'userId': apiSession.user.id,
                'website': 'https://cherrybit.studio',
                'description': 'cool studio',
              },
            ],
          ),
        );
      });
    });

    group('POST /hub/studios', () {
      test('creates a studio for the logged user', () async {
        final context = _MockRequestContext();
        final request = _MockRequest();

        when(() => context.request).thenReturn(request);
        when(() => request.method).thenReturn(HttpMethod.post);
        when(() => context.read<ApiSession>()).thenReturn(apiSession);
        when(() => context.read<StudioRepository>())
            .thenReturn(studioRepository);
        when(
          () => studioRepository.createStudio(
            name: 'CherryBit',
            description: 'cool studio',
            userId: apiSession.user.id,
            website: 'https://cherrybit.studio',
          ),
        ).thenAnswer(
          (_) async => Studio(
            id: '1',
            name: 'CherryBit',
            description: 'cool studio',
            userId: apiSession.user.id,
            website: 'https://cherrybit.studio',
          ),
        );

        when(request.json).thenAnswer(
          (_) async => {
            'name': 'CherryBit',
            'website': 'https://cherrybit.studio',
            'description': 'cool studio',
          },
        );

        final response = await route.onRequest(context);

        expect(response.statusCode, equals(200));
        expect(
          await response.json(),
          equals(
            {
              'id': '1',
              'name': 'CherryBit',
              'userId': apiSession.user.id,
              'website': 'https://cherrybit.studio',
              'description': 'cool studio',
            },
          ),
        );
      });

      test('returns bad request when no name is informed', () async {
        final context = _MockRequestContext();
        final request = _MockRequest();

        when(() => context.request).thenReturn(request);
        when(() => request.method).thenReturn(HttpMethod.post);
        when(() => context.read<ApiSession>()).thenReturn(apiSession);
        when(() => context.read<StudioRepository>())
            .thenReturn(studioRepository);

        when(request.json).thenAnswer(
          (_) async => {
            'website': 'https://cherrybit.studio',
            'description': 'cool studio',
          },
        );

        final response = await route.onRequest(context);

        expect(response.statusCode, equals(HttpStatus.badRequest));
      });

      test('returns bad request when no description is informed', () async {
        final context = _MockRequestContext();
        final request = _MockRequest();

        when(() => context.request).thenReturn(request);
        when(() => request.method).thenReturn(HttpMethod.post);
        when(() => context.read<ApiSession>()).thenReturn(apiSession);
        when(() => context.read<StudioRepository>())
            .thenReturn(studioRepository);

        when(request.json).thenAnswer(
          (_) async => {
            'name': 'CherryBit',
            'website': 'https://cherrybit.studio',
          },
        );

        final response = await route.onRequest(context);

        expect(response.statusCode, equals(HttpStatus.badRequest));
      });

      test(
        'returns conflict when there is already a studio with that name',
        () async {
          final context = _MockRequestContext();
          final request = _MockRequest();

          when(() => context.request).thenReturn(request);
          when(() => request.method).thenReturn(HttpMethod.post);
          when(() => context.read<ApiSession>()).thenReturn(apiSession);
          when(() => context.read<StudioRepository>())
              .thenReturn(studioRepository);

          when(
            () => studioRepository.createStudio(
              name: 'CherryBit',
              description: 'cool studio',
              userId: apiSession.user.id,
              website: 'https://cherrybit.studio',
            ),
          ).thenThrow(StudioAlreadyExistsException());

          when(request.json).thenAnswer(
            (_) async => {
              'name': 'CherryBit',
              'description': 'cool studio',
              'website': 'https://cherrybit.studio',
            },
          );

          final response = await route.onRequest(context);

          expect(response.statusCode, equals(HttpStatus.conflict));
        },
      );
    });

    test('returns method not allowed when is not GET or POST', () async {
      final context = _MockRequestContext();
      final request = _MockRequest();

      when(() => context.request).thenReturn(request);
      when(() => request.method).thenReturn(HttpMethod.put);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });
  });
}
