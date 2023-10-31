import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:play_flutter_games_hub/studios/studios.dart';
import 'package:studio_repository/studio_repository.dart';

import '../../../helpers/helpers.dart';

class _MockStudioRepository extends Mock implements StudioRepository {}

class _MockUserStudiosCubit extends MockCubit<UserStudiosState>
    implements UserStudiosCubit {}

void main() {
  group('UserStudiosPage', () {
    late UserStudiosCubit userStudiosCubit;

    void mockState(List<UserStudiosState> states) {
      assert(states.isNotEmpty, 'states cannot be empty');
      whenListen(
        userStudiosCubit,
        Stream.fromIterable(states),
        initialState: states.first,
      );
    }

    setUp(() {
      userStudiosCubit = _MockUserStudiosCubit();
    });

    testWidgets('route renders', (tester) async {
      await tester.pumpRoute(
        UserStudiosPage.route(),
        providers: [
          RepositoryProvider<StudioRepository>(
            create: (_) {
              return _MockStudioRepository();
            },
          ),
        ],
      );
      expect(find.byType(UserStudiosPage), findsOneWidget);
    });

    testWidgets('renders', (tester) async {
      mockState([const UserStudiosState()]);
      await tester.pumpSubject(userStudiosCubit);
      expect(find.byType(UserStudiosView), findsOneWidget);
    });

    testWidgets(
      "renders a loading indicator when is fetching the user's studios",
      (tester) async {
        mockState([const UserStudiosState(status: UserStudiosStatus.loading)]);
        await tester.pumpSubject(userStudiosCubit);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'renders an error message when something went wrong',
      (tester) async {
        mockState([const UserStudiosState(status: UserStudiosStatus.failure)]);
        await tester.pumpSubject(userStudiosCubit);
        expect(find.text('Something went wrong.'), findsOneWidget);
      },
    );

    testWidgets(
      'renders a list of studios',
      (tester) async {
        mockState([
          const UserStudiosState(
            status: UserStudiosStatus.success,
            studios: [
              Studio(
                id: '1',
                name: 'CherryBit',
                description: 'Studio 1 description',
                userId: '1',
                website: 'https://studio1.com',
              ),
              Studio(
                id: '2',
                name: 'Lovebirds',
                description: 'Studio 2 description',
                userId: '2',
                website: 'https://studio2.com',
              ),
            ],
          ),
        ]);

        await tester.pumpSubject(userStudiosCubit);
        await tester.pumpAndSettle();

        expect(find.text('CherryBit'), findsOneWidget);
        expect(find.text('Lovebirds'), findsOneWidget);

        expect(find.text('Studio 1 description'), findsOneWidget);
        expect(find.text('Studio 2 description'), findsOneWidget);
      },
    );
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(UserStudiosCubit cubit) async {
    await pumpApp(
      BlocProvider.value(
        value: cubit,
        child: const UserStudiosPage(),
      ),
    );
  }
}
