abstract class ProfileRepository {
  Future<void> updateUser({
    required String token,
    required Map<String, dynamic> userData,
  });
}
