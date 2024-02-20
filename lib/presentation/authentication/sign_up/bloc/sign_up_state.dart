part of 'sign_up_bloc.dart';

sealed class SignUpState extends Equatable {
  @override
  List<Object> get props => [];

  const SignUpState();
}

class SignUpInitial extends SignUpState {
  const SignUpInitial();
}

class SignUpLoading extends SignUpState {
  const SignUpLoading();
}

class SignUpSuccess extends SignUpState {
  final String message;

  const SignUpSuccess({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class SignUpFailure extends SignUpState {
  final String message;

  const SignUpFailure({required this.message});

  @override
  List<Object> get props => [message];
}
