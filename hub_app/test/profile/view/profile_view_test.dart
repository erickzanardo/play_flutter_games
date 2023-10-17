import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:play_flutter_games_hub/profile/profile.dart';

import '../../helpers/helpers.dart';

class _MockProfileBloc extends MockBloc<ProfileEvent, ProfileState>
    implements ProfileBloc {}

void main() {
  group('ProfileView', () {
    late ProfileBloc profileBloc;

    void mockState(ProfileState state) {
      whenListen(
        profileBloc,
        Stream.fromIterable([state]),
        initialState: state,
      );
    }

    setUp(() {
      profileBloc = _MockProfileBloc();

      mockState(const ProfileInitial());
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpSuject(profileBloc);
      expect(find.byType(ProfileView), findsOneWidget);
    });

    testWidgets('renders loading', (tester) async {
      mockState(const ProfileLoadInProgress());
      await tester.pumpSuject(profileBloc);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders the profile information when loaded', (tester) async {
      mockState(
        const ProfileLoaded(
          User(
            id: 'id',
            name: 'name',
            username: 'username',
          ),
        ),
      );
      await tester.pumpSuject(profileBloc);
      expect(find.text('Name: name'), findsOneWidget);
      expect(find.text('Username: username'), findsOneWidget);
    });

    testWidgets(
      'adds developer mode changed when taping the switch',
      (tester) async {
        mockState(
          const ProfileLoaded(
            User(
              id: 'id',
              name: 'name',
              username: 'username',
            ),
          ),
        );
        await tester.pumpSuject(profileBloc);
        await tester.tap(find.byType(Switch));
        await tester.pump();

        verify(
          () => profileBloc.add(
            const DeveloperModeChanged(isDeveloperMode: true),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'renders a progress indicator when is saving',
      (tester) async {
        mockState(
          const ProfileSaving(
            User(
              id: 'id',
              name: 'name',
              username: 'username',
            ),
          ),
        );
        await tester.pumpSuject(profileBloc);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets('renders failure message when loading fails', (tester) async {
      mockState(const ProfileLoadFailure());
      await tester.pumpSuject(profileBloc);
      expect(find.text('Something went wrong.'), findsOneWidget);
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSuject(ProfileBloc bloc) {
    return pumpApp(
      BlocProvider.value(
        value: bloc,
        child: const ProfileView(),
      ),
    );
  }
}
