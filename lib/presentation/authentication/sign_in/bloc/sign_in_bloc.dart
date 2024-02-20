import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/repositories/auth_repository.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthRepository _authRepository;
  SignInBloc(this._authRepository) : super(SignInInitial()) {
    on<SignInEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<SignInWithEmailAndPassword>((event, emit) async {
      emit(SignInLoading());
      final result = await _authRepository.signInWithEmailAndPassword(
          email: event.email, password: event.password);
      result.fold(
        (failure) => emit(SignInError(failure.message)),
        (r) => emit(SignInSuccess()),
      );
    });
  }
}
