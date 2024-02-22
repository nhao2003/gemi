import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:gemi/core/errors/data_source_exception.dart';
import 'package:gemi/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/errors/failure.dart';
import '../data_source/remote/auth_remote_data_source/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthRepositoryImpl(this._authRemoteDataSource);

  @override
  User? get user => _authRemoteDataSource.user;
  @override
  Future<Either<Failure, void>> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _authRemoteDataSource.signInWithEmailAndPassword(
          email: email, password: password);
      return Future.value(right(null));
    } catch (e) {
      return Future.value(
          left(Failure(message: (e as DataSourceException).message)));
    }
  }

  @override
  Future<Either<Failure, void>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    try {
      await _authRemoteDataSource.signUpWithEmailAndPassword(
          email: email, password: password, data: data);
      return Future.value(right(null));
    } catch (e) {
      log(e.toString());
      return Future.value(
          left(Failure(message: (e as DataSourceException).message)));
    }
  }

  @override
  bool get isAuthenticated => _authRemoteDataSource.isAuthenticated;

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _authRemoteDataSource.signOut();
      return Future.value(right(null));
    } catch (e) {
      return Future.value(
          left(Failure(message: (e as DataSourceException).message)));
    }
  }
}
