import 'dart:developer';

import 'package:gemi/core/errors/data_source_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _supabaseClient;

  AuthRemoteDataSourceImpl(this._supabaseClient);

  @override
  User? get user => _supabaseClient.auth.currentUser;

  @override
  Future<AuthResponse> signUpWithEmailAndPassword({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    try {
      final res = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: data,
      );
      return res;
    } on AuthException catch (e) {
      log(e.toString());
      throw RemoteDataSourceException(
        message: e.message,
        statusCode: e.statusCode,
      );
    } catch (e) {
      log(e.toString());
      throw RemoteDataSourceException(
        message: e.toString(),
      );
    }
  }

  @override
  Future<AuthResponse> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      log(res.toString());
      return res;
    } on AuthException catch (e) {
      log(e.toString());
      throw RemoteDataSourceException(
        message: e.message,
        statusCode: e.statusCode,
      );
    } catch (e) {
      log(e.toString());
      throw RemoteDataSourceException(
        message: e.toString(),
      );
    }
  }

  @override
  bool get isAuthenticated => _supabaseClient.auth.currentUser != null;

  @override
  Future<void> signOut() {
    return _supabaseClient.auth.signOut();
  }
}
