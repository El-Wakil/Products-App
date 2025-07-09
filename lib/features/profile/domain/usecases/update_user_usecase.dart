import '../repositories/profile_repository.dart';

class UpdateUserUseCase {
  final ProfileRepository repository;

  UpdateUserUseCase(this.repository);

  Future<void> call({
    required String token,
    required Map<String, dynamic> userData,
  }) async {
    await repository.updateUser(token: token, userData: userData);
  }
}
