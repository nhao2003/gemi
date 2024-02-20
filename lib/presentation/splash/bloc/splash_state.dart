part of 'splash_bloc.dart';

sealed class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => [];
}

final class SplashInitial extends SplashState {}

final class UserAuthenticated extends SplashState {}

final class UserNotAuthenticated extends SplashState {}

final class UserAuthenticationError extends SplashState {
  final String message;

  const UserAuthenticationError(this.message);

  @override
  List<Object> get props => [message];
}
