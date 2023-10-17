import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:user_repository/user_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const ProfileInitial()) {
    on<ProfileRequested>(_onProfileRequested);
    on<DeveloperModeChanged>(_onDeveloperModeChanged);
  }

  final UserRepository _userRepository;

  Future<void> _onProfileRequested(
    ProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(const ProfileLoadInProgress());
      final user = await _userRepository.getUserProfile();
      emit(ProfileLoaded(user));
    } catch (e, s) {
      addError(e, s);
      emit(const ProfileLoadFailure());
    }
  }

  Future<void> _onDeveloperModeChanged(
    DeveloperModeChanged event,
    Emitter<ProfileState> emit,
  ) async {
    final loadedState = state;
    if (loadedState is ProfileLoaded) {
      try {
        emit(ProfileSaving(loadedState.user));
        await _userRepository.setDeveloperMode(value: event.isDeveloperMode);
        emit(
          ProfileLoaded(
            loadedState.user.copyWith(
              isDeveloper: event.isDeveloperMode,
            ),
          ),
        );
      } catch (e, s) {
        addError(e, s);
        emit(ProfileSaveFailed(loadedState.user));
      }
    }
  }
}
