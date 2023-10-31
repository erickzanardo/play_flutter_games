import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:play_flutter_games_hub/l10n/l10n.dart';
import 'package:play_flutter_games_hub/studios/studios.dart';

class UserStudiosPage extends StatelessWidget {
  const UserStudiosPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) {
        return BlocProvider<UserStudiosCubit>(
          create: (context) {
            return UserStudiosCubit(
              studioRepository: context.read(),
            )..load();
          },
          child: const UserStudiosPage(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const UserStudiosView();
  }
}

class UserStudiosView extends StatelessWidget {
  const UserStudiosView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<UserStudiosCubit>().state;
    final l10n = context.l10n;

    if (state.status == UserStudiosStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (state.status == UserStudiosStatus.success) {
      return Column(
        children: [
          for (final studio in state.studios)
            Card(
              child: Column(
                children: [
                  Text(
                    studio.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(studio.description),
                ],
              ),
            ),
        ],
      );
    } else {
      return Center(
        child: Text(l10n.somethingWentWrong),
      );
    }
  }
}
