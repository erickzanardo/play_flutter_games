import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:token_provider/token_provider.dart';
import 'package:user_repository/user_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
    required TokenProvider tokenProvider,
  })  : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        _tokenProvider = tokenProvider,
        super(const AppInitial()) {
    on<SessionLoaded>(_onSessionLoaded);
    on<SessionLoggedOff>(_onSessionLoggedOff);
    on<DeveloperModeChanged>(_onDeveloperModeChanged);

    _sessionSubscription = _authenticationRepository.session.listen((event) {
      if (event != null) {
        _tokenProvider.applyToken(event);

        final isDeveloper =
            state is SessionLoaded && (state as SessionLoaded).isDeveloperMode;

        add(
          SessionLoaded(
            sessionToken: event,
            isDeveloperMode: isDeveloper,
          ),
        );
      } else {
        add(const SessionLoggedOff());
        _tokenProvider.clear();
      }
    });

    tokenProvider.current.then((value) async {
      if (value != null) {
        final session = await _userRepository.getUserSession();
        final user = await _userRepository.getUserProfile();
        add(
          SessionLoaded(
            sessionToken: session,
            isDeveloperMode: user.isDeveloper,
          ),
        );
      }
    });
  }

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  final TokenProvider _tokenProvider;
  late StreamSubscription<String?> _sessionSubscription;

  void _onSessionLoaded(
    SessionLoaded event,
    Emitter<AppState> emit,
  ) {
    emit(
      AppAuthenticated(
        sessionToken: event.sessionToken,
        isDeveloperMode: event.isDeveloperMode,
      ),
    );
  }

  void _onSessionLoggedOff(
    SessionLoggedOff event,
    Emitter<AppState> emit,
  ) {
    emit(const AppInitial());
  }

  void _onDeveloperModeChanged(
    DeveloperModeChanged event,
    Emitter<AppState> emit,
  ) {
    if (state is AppAuthenticated) {
      final currentState = state as AppAuthenticated;
      emit(
        AppAuthenticated(
          sessionToken: currentState.sessionToken,
          isDeveloperMode: event.value,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _sessionSubscription.cancel();
    return super.close();
  }
}
