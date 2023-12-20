part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();
}

class SessionLoaded extends AppEvent {
  const SessionLoaded({
    required this.sessionToken,
    required this.isDeveloperMode,
  });

  final String sessionToken;
  final bool isDeveloperMode;

  @override
  List<Object> get props => [sessionToken, isDeveloperMode];
}

class SessionLoggedOff extends AppEvent {
  const SessionLoggedOff();

  @override
  List<Object> get props => [];
}

class DeveloperModeChanged extends AppEvent {
  const DeveloperModeChanged({required this.value});

  final bool value;

  @override
  List<Object> get props => [value];
}
