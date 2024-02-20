import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String message;

  const Failure({this.message = 'An unexpected error occurred'});

  @override
  List<Object> get props => [message];
}
