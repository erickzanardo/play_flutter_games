part of 'user_studios_cubit.dart';

enum UserStudiosStatus { initial, loading, success, failure }

class UserStudiosState extends Equatable {

  const UserStudiosState({
    this.status = UserStudiosStatus.initial,
    this.studios = const <Studio>[],
  });

  final UserStudiosStatus status;

  final List<Studio> studios;

  UserStudiosState copyWith({
    UserStudiosStatus? status,
    List<Studio>? studios,
  }) {
    return UserStudiosState(
      status: status ?? this.status,
      studios: studios ?? this.studios,
    );
  }

  @override
  List<Object?> get props => [status, studios];
}
