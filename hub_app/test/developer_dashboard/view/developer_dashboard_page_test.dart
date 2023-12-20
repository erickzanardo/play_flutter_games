// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:play_flutter_games_hub/developer_dashboard/developer_dashboard.dart';

import '../../helpers/helpers.dart';

void main() {
  group('DeveloperDashboardPage', () {
    testWidgets('route renders the DeveloperDashboardView', (tester) async {
      await tester.pumpRoute(
        DeveloperDashboardPage.route(),
      );

      expect(find.byType(DeveloperDashboardView), findsOneWidget);
    });
  });

  group('DeveloperDashboardView', () {
    testWidgets('renders', (tester) async {
      await tester.pumpApp(DeveloperDashboardView());
      expect(find.byType(DeveloperDashboardView), findsOneWidget);
    });

    testWidgets('navigates to my studios page', (tester) async {
      final navigator = MockNavigator();
      when(() => navigator.push<void>(any())).thenAnswer((_) async {});
      when(navigator.canPop).thenReturn(true);

      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: DeveloperDashboardView(),
        ),
      );

      await tester.tap(find.text('My studios'));
      verify(() => navigator.push<void>(any())).called(1);
    });
  });
}
