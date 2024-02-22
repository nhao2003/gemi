import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> signUpWithEmailAndPassword({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  });

  Future<AuthResponse> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  bool get isAuthenticated;
  Future<void> signOut();
  User? get user;
}
