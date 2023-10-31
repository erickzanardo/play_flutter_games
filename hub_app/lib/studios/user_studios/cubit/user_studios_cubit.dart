import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:studio_repository/studio_repository.dart';

part 'user_studios_state.dart';

class UserStudiosCubit extends Cubit<UserStudiosState> {
  UserStudiosCubit({
    required StudioRepository studioRepository,
  })  : _studioRepository = studioRepository,
        super(const UserStudiosState());

  final StudioRepository _studioRepository;

  Future<void> load() async {
    emit(state.copyWith(status: UserStudiosStatus.loading));
    try {
      final studios = await _studioRepository.getUserStudios();
      emit(state.copyWith(status: UserStudiosStatus.success, studios: studios));
    } catch (e, s) {
      addError(e, s);
      emit(state.copyWith(status: UserStudiosStatus.failure));
    }
  }
}
