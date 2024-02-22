import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/repositories/auth_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository _authRepository;
  SignUpBloc(this._authRepository) : super(const SignUpInitial()) {
    on<SignUpEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<SignUpWithEmailAndPassword>((event, emit) async {
      emit(const SignUpLoading());
      final result = await _authRepository.signUpWithEmailAndPassword(
          email: event.email,
          password: event.password,
          data: {
            'first_name': event.firstName,
            'last_name': event.lastName,
          });
      result.fold(
        (l) => emit(SignUpFailure(message: (l).message)),
        (r) =>
            emit(const SignUpSuccess(message: 'Account created successfully.')),
      );
    });
  }
}
