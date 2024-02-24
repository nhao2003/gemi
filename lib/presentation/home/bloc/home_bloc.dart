import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gemi/core/utils/string_util.dart';
import 'package:gemi/domain/repositories/gemini_repository.dart';

import '../../../domain/entities/conversation.dart';
import '../../../domain/entities/prompt.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GeminiRepository _geminiRepository;
  late final StreamController<List<Conversation>> _conversationStream =
      StreamController<List<Conversation>>.broadcast();
  Stream<List<Conversation>> get conversationStream =>
      _conversationStream.stream;
  final List<Conversation> _conversations = [];
  List<Conversation> get conversations => _conversations;
  HomeBloc(this._geminiRepository) : super(const HomeLoading()) {
    _geminiRepository.conversationStream.listen((event) {
      _conversations.add(event);
      _conversationStream.add(_conversations);
    });
    on<HomeEvent>((event, emit) {
      print(state.runtimeType.toString());
    });
    on<HomeConversationSelected>((event, emit) async {
      final result = await _geminiRepository.getPrompts(
          conversationId: event.conversationId);
      emit(const HomeLoading());
      result.fold((l) {
        emit(const HomeLoading());
      }, (r) {
        emit(HomeOnChat(
          prompts: r,
          currentConversationId: event.conversationId,
          isGenerating: false,
        ));
      });
    });

    on<HomeStarted>((event, emit) async {
      final result = await _geminiRepository.getConversations();
      result.fold((l) {
        emit(const HomeLoading());
      }, (r) {
        _conversations.clear();
        _conversations.addAll(r);
        _conversationStream.add(_conversations);
        emit(const HomeNewChat());
      });
    });

    on<HomePromptSubmitted>((event, emit) async {
      final prompts = [...?state.prompts];
      bool newConversation = state.currentConversationId == null;
      String conversationId = state.currentConversationId ?? StringUtil.uuid;
      final newState = HomeOnChat(
        prompts: prompts,
        currentConversationId: conversationId,
        isGenerating: true,
      );
      emit(newState);
      final result = _geminiRepository.streamGeneratedPrompt(
        text: event.text,
        conversationId: conversationId,
        images: event.images,
        newConversation: newConversation,
      );
      await for (var value in result) {
        value.fold((l) {
          print("Error: $l");
          emit(HomeOnChat(
            prompts: prompts,
            currentConversationId: conversationId,
            isGenerating: false,
          ));
        }, (r) {
          final index = prompts.indexWhere((element) => element.id == r?.id);
          if (index != -1 && r != null) {
            prompts[index] = r;
          } else if (r != null) {
            prompts.add(r);
          }
          final newState = HomeOnChat(
            prompts: [...prompts],
            currentConversationId: conversationId,
            isGenerating: state.isGenerating,
          );
          emit(newState);
        });
        event.onPromptSubmitted?.call();
      }
      emit(newState.copyWith(isGenerating: false));
    });

    on<HomeConversationDeleted>((event, emit) async {
      print("Event: HomeConversationDeleted");
      final result = await _geminiRepository.deleteConversation(
        conversationId: event.conversationId,
      );
      final conversations = [..._conversations];
      _conversationStream.add(conversations);
      result.fold((l) {
        emit(const HomeLoading());
      }, (r) {
        conversations
            .removeWhere((element) => element.id == event.conversationId);
        if (state is HomeOnChat &&
            state.currentConversationId != event.conversationId) {
          emit(HomeOnChat(
            prompts: state.prompts,
            currentConversationId: state.currentConversationId,
            isGenerating: state.isGenerating,
          ));
        } else {
          emit(const HomeNewChat());
        }
      });
    });

    on<HomePromptMarkedGoodOrBad>((event, emit) async {
      final prompts = List<Prompt>.from(state.prompts ?? []);
      final prompt = await _geminiRepository.markGoodOrBadResponse(
        prompt: event.prompt,
        isGoodResponse: event.isGoodResponse,
      );
      prompt.fold((l) {
        throw l;
      }, (r) {
        final index = prompts.indexWhere((element) => element.id == r?.id);
        if (index != -1 && r != null) {
          prompts[index] = r;
          final newState = HomeOnChat(
            prompts: prompts,
            currentConversationId: state.currentConversationId,
            isGenerating: state.isGenerating,
          );
          emit(newState);
        } else {}
      });
    });
  }
}
