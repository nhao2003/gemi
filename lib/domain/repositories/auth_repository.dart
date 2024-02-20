import 'package:dartz/dartz.dart';
import 'package:gemi/core/errors/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  });

  Future<Either<Failure, void>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> signOut();

  bool isUserAuthenticated();
}
