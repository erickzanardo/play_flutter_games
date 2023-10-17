import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:play_flutter_games_hub/l10n/l10n.dart';
import 'package:play_flutter_games_hub/profile/profile.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.watch<ProfileBloc>();
    final state = bloc.state;

    if (state is ProfileLoadInProgress) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (state is ProfileLoaded) {
      return Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: [
            Center(
              child: Card(
                child: Column(
                  children: [
                    Text('Name: ${state.user.name}'),
                    Text('Username: ${state.user.username}'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Are you making games:'),
                        Switch(
                          value: state.user.isDeveloper,
                          onChanged: (value) {
                            bloc.add(
                              DeveloperModeChanged(
                                isDeveloperMode: value,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (state is ProfileSaving)
              const Positioned(
                right: 16,
                top: 16,
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: Text(l10n.somethingWentWrong),
        ),
      );
    }
  }
}
