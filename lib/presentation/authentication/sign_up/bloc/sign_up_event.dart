part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpWithEmailAndPassword extends SignUpEvent {
  final String email;
  final String password;
  final String confirmPassword;
  final String firstName;
  final String lastName;

  const SignUpWithEmailAndPassword({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object> get props =>
      [email, password, confirmPassword, firstName, lastName];
}
