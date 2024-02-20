part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  final List<Conversation>? conversations;
  final List<Prompt>? prompts;
  final bool isGenerating;
  final String? currentConversationId;
  const HomeState({
    this.conversations,
    this.prompts,
    this.isGenerating = false,
    this.currentConversationId,
  });

  @override
  List<Object> get props => [
        conversations ?? [],
        prompts ?? [],
        (conversations.hashCode),
        (prompts.hashCode),
        isGenerating,
        currentConversationId ?? '',
      ];

  HomeState copyWith({
    List<Conversation>? conversations,
    List<Prompt>? prompts,
    bool? isGenerating,
    String? currentConversationId,
  });
}

final class HomeLoading extends HomeState {
  const HomeLoading() : super(conversations: null, prompts: null);

  @override
  HomeState copyWith(
      {List<Conversation>? conversations,
      List<Prompt>? prompts,
      bool? isGenerating,
      String? currentConversationId}) {
    return const HomeLoading();
  }
}

final class HomeOnChat extends HomeState {
  const HomeOnChat({
    required super.conversations,
    required super.currentConversationId,
    required super.prompts,
    required super.isGenerating,
  });

  @override
  HomeOnChat copyWith({
    List<Conversation>? conversations,
    List<Prompt>? prompts,
    bool? isGenerating,
    String? currentConversationId,
  }) {
    return HomeOnChat(
      conversations: conversations ?? super.conversations,
      currentConversationId:
          currentConversationId ?? super.currentConversationId,
      prompts: prompts ?? super.prompts,
      isGenerating: isGenerating ?? super.isGenerating,
    );
  }
}

final class HomeNewChat extends HomeState {
  const HomeNewChat({
    required super.conversations,
  }) : super(currentConversationId: null);

  @override
  HomeNewChat copyWith({
    List<Conversation>? conversations,
    List<Prompt>? prompts,
    bool? isGenerating,
    String? currentConversationId,
  }) {
    return HomeNewChat(
      conversations: conversations ?? super.conversations,
    );
  }
}
