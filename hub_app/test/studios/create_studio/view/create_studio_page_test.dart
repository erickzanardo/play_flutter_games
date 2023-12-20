import 'package:flutter_test/flutter_test.dart';
import 'package:play_flutter_games_hub/studios/create_studio/create_studio.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('CreateStudioPage', () {
    testWidgets('route renders', (tester) async {
      await tester.pumpRoute(
        CreateStudioPage.route(),
      );
      expect(find.byType(CreateStudioPage), findsOneWidget);
    });
  });
}
