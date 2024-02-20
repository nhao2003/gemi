abstract class AuthRemoteDataSource {
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  });

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  bool isUserAuthenticated();
  Future<void> signOut();
}
