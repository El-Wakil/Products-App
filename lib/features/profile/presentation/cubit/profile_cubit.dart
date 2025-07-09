import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/update_user_usecase.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UpdateUserUseCase updateUserUseCase;

  ProfileCubit(this.updateUserUseCase) : super(ProfileInitial());

  Future<void> updateUser({
    required String token,
    required Map<String, dynamic> userData,
  }) async {
    emit(ProfileLoading());
    try {
      await updateUserUseCase(token: token, userData: userData);
      emit(ProfileSuccess());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
