import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grovehubmusic/services/services_auth.dart';

class UserState {
  final List<Map<String, dynamic>> users;
  final bool isLoading;
  final String? error;

  UserState({required this.users, required this.isLoading, this.error});

  UserState copyWith(
      {List<Map<String, dynamic>>? users, bool? isLoading, String? error}) {
    return UserState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class UserCubit extends Cubit<UserState> {
  final ApiService _userService;

  UserCubit(this._userService) : super(UserState(users: [], isLoading: false));

  Future<void> loadUsers({Map<String, dynamic>? filters}) async {
    emit(state.copyWith(isLoading: true));

    try {
      final users = await _userService.getUsers(filters: filters);
      emit(state.copyWith(users: users, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
