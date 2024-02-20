import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/repositories/auth_repository.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthRepository authRepository;
  SplashBloc(this.authRepository) : super(SplashInitial()) {
    on<SplashEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<CheckUserAuthenticated>((event, emit) {
      if (authRepository.isUserAuthenticated()) {
        emit(UserAuthenticated());
      } else {
        emit(UserNotAuthenticated());
      }
    });
  }
}
