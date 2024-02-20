import 'dart:developer';

import 'package:gemi/core/errors/data_source_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _supabaseClient;

  AuthRemoteDataSourceImpl(this._supabaseClient);

  @override
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    try {
      final res = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );
      print(res.toString());
    } catch (e) {
      if (e is AuthException) {
        log(e.toString());
        throw RemoteDataSourceException(
          message: e.message,
          statusCode: e.statusCode,
        );
      } else {
        log(e.toString());
        throw RemoteDataSourceException(message: e.toString());
      }
    }
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final res = await _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );

    log(res.toString());
  }

  @override
  bool isUserAuthenticated() {
    final user = _supabaseClient.auth.currentUser;
    return user != null;
  }

  @override
  Future<void> signOut() {
    // return _supabaseClient.auth.signOut();
    return Future.value();
  }
}
