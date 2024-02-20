import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gemi/domain/repositories/gemini_repository.dart';

import '../../../data/model/gemini/content/content.dart';
import '../../../dependency_container.dart';
import '../../../domain/entities/conversation.dart';
import '../../../domain/entities/prompt.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GeminiRepository _geminiRepository = sl<GeminiRepository>();
  HomeBloc() : super(const HomeLoading()) {
    on<HomeEvent>((event, emit) {
      // TODO: implement event handler
      print(state.runtimeType.toString());
    });
    on<HomeConversationSelected>((event, emit) async {
      final result = await _geminiRepository.getPrompts(
          conversationId: event.conversationId);
      final conversations = [...?state.conversations];
      emit(const HomeLoading());
      result.fold((l) {
        emit(const HomeLoading());
      }, (r) {
        emit(HomeOnChat(
          prompts: r,
          currentConversationId: event.conversationId,
          isGenerating: false,
          conversations: conversations,
        ));
      });
    });

    on<HomeStarted>((event, emit) async {
      final result = await _geminiRepository.getConversations();
      result.fold((l) {
        emit(const HomeLoading());
      }, (r) {
        emit(HomeNewChat(conversations: r));
      });
    });

    on<HomePromptSubmitted>((event, emit) async {
      final prompts = [...?state.prompts];
      String? conversationId = state.currentConversationId;

      if (conversationId == null) {
        final res = (await _geminiRepository.createConversation(
            name: event.text ?? "Untitled Conversation"));
        res.fold((l) {
          emit(const HomeLoading());
        }, (r) {
          conversationId = r.id;
        });
      }
      // copyWith
      final newState = HomeOnChat(
        prompts: prompts,
        currentConversationId: conversationId,
        isGenerating: true,
        conversations: state.conversations,
      );
      emit(newState);
      final result = _geminiRepository.streamGenerateChat(
        event.text ?? "",
        chats: prompts,
      );
      await for (var value in result) {
        value.fold((l) {
          print("Error: $l");
          emit(HomeOnChat(
            prompts: prompts,
            currentConversationId: conversationId,
            isGenerating: false,
            conversations: state.conversations,
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
            conversations: state.conversations,
          );
          emit(newState);
        });
        event.onPromptSubmitted?.call();
      }
      emit(state.copyWith(isGenerating: false));
    });

    on<HomeConversationDeleted>((event, emit) async {
      print("Event: HomeConversationDeleted");
      final result = await _geminiRepository.deleteConversation(
        conversationId: event.conversationId,
      );
      final conversations = [...?state.conversations];
      result.fold((l) {
        print("Error: $l");
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
            conversations: conversations,
          ));
        } else {
          emit(HomeNewChat(conversations: conversations));
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
        print("Error: $l");
      }, (r) {
        print("Prompts: ${prompts}");
        print("PromptR: ${r?.isGoodResponse}");
        final index = prompts.indexWhere((element) => element.id == r?.id);
        if (index != -1 && r != null) {
          prompts[index] = r;
          final newState = HomeOnChat(
            prompts: prompts,
            currentConversationId: state.currentConversationId,
            isGenerating: state.isGenerating,
            conversations: state.conversations,
          );
          emit(newState);
        } else {}
      });
    });
  }
}
