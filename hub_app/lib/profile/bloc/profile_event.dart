part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class ProfileRequested extends ProfileEvent {
  const ProfileRequested();

  @override
  List<Object> get props => [];
}

class DeveloperModeChanged extends ProfileEvent {
  const DeveloperModeChanged({
    required this.isDeveloperMode,
  });

  final bool isDeveloperMode;

  @override
  List<Object> get props => [isDeveloperMode];
}
