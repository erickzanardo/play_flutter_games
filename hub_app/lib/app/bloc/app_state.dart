part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  const AppState();
}

class AppInitial extends AppState {
  const AppInitial();

  @override
  List<Object> get props => [];
}

class AppAuthenticated extends AppState {
  const AppAuthenticated({
    required this.sessionToken,
    this.isDeveloperMode = false,
  });

  final String sessionToken;
  final bool isDeveloperMode;

  @override
  List<Object> get props => [
        sessionToken,
        isDeveloperMode,
      ];
}
