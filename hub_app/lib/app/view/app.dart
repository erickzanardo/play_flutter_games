import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:play_flutter_games_hub/app/app.dart';
import 'package:play_flutter_games_hub/auth/auth.dart';
import 'package:play_flutter_games_hub/home/home.dart';
import 'package:play_flutter_games_hub/l10n/l10n.dart';
import 'package:studio_repository/studio_repository.dart';
import 'package:token_provider/token_provider.dart';
import 'package:user_repository/user_repository.dart';

class App extends StatelessWidget {
  const App({
    required this.authenticationRepository,
    required this.postRepository,
    required this.userRepository,
    required this.studioRepository,
    required this.tokenProvider,
    super.key,
  });

  final AuthenticationRepository authenticationRepository;
  final PostRepository postRepository;
  final UserRepository userRepository;
  final StudioRepository studioRepository;
  final TokenProvider tokenProvider;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: authenticationRepository,
        ),
        RepositoryProvider.value(
          value: postRepository,
        ),
        RepositoryProvider.value(
          value: userRepository,
        ),
        RepositoryProvider.value(
          value: studioRepository,
        ),
      ],
      child: BlocProvider(
        create: (_) => AppBloc(
          authenticationRepository: authenticationRepository,
          tokenProvider: tokenProvider,
          userRepository: userRepository,
        ),
        child: MaterialApp(
          theme: ThemeData(
            appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
            scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSwatch(
              accentColor: const Color(0xFF13B9FF),
            ),
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              final appState = context.watch<AppBloc>().state;
              return (appState is AppAuthenticated)
                  ? const HomePage()
                  : const AuthPage();
            },
          ),
        ),
      ),
    );
  }
}
