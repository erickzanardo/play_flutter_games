import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:play_flutter_games_hub/profile/profile.dart';
import 'package:user_repository/user_repository.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (_) => BlocProvider<ProfileBloc>(
        create: (context) {
          return ProfileBloc(
            userRepository: context.read<UserRepository>(),
          )..add(const ProfileRequested());
        },
        child: const ProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const ProfileView();
  }
}
