import '../domain/repositories/profile_repository.dart';
import 'profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> updateUser({
    required String token,
    required Map<String, dynamic> userData,
  }) async {
    await remoteDataSource.updateUser(token: token, userData: userData);
  }
}
