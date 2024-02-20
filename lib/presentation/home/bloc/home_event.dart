part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeStarted extends HomeEvent {}

class HomeConversationSelected extends HomeEvent {
  final String conversationId;

  const HomeConversationSelected(this.conversationId);

  @override
  List<Object> get props => [conversationId];
}

class HomePromptSubmitted extends HomeEvent {
  final String? text;
  final List<String>? images;
  final Function? onPromptSubmitted;

  const HomePromptSubmitted({this.text, this.images, this.onPromptSubmitted});
}

class HomeConversationDeleted extends HomeEvent {
  final String conversationId;

  const HomeConversationDeleted(this.conversationId);

  @override
  List<Object> get props => [conversationId];
}

class HomePromptMarkedGoodOrBad extends HomeEvent {
  final Prompt prompt;
  final bool? isGoodResponse;

  const HomePromptMarkedGoodOrBad(this.prompt, this.isGoodResponse);

  @override
  List<Object> get props => [prompt];
}
