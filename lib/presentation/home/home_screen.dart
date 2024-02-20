import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemi/dependency_container.dart';
import 'package:gemi/domain/entities/prompt.dart';
import 'package:gemi/presentation/home/widgets/chat_input.dart';
import 'package:gemi/presentation/home/widgets/gemini_drawer.dart';
import 'package:gemi/presentation/home/widgets/home_started.dart';
import 'package:gemi/core/resource/assets.dart';
import 'package:gemi/domain/enums/enums.dart';
import 'package:image_picker/image_picker.dart';
import 'bloc/home_bloc.dart';
import 'widgets/message_bubble.dart';

class HomeScreen extends StatefulWidget {
  final String title;
  const HomeScreen({super.key, required this.title});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScaffoldMessengerState? scaffoldMessengerState;

  @override
  void dispose() {
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        // Check scroll is attached to a scroll view
        if (_scrollController.hasClients &&
            _scrollController.position.maxScrollExtent > 0) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(
              milliseconds: 750,
            ),
            curve: Curves.easeOutCirc,
          );
        }
      },
    );
  }

  void likeButtonPressed(
      BuildContext context, Prompt prompt, MessageButtonType type) {
    if (type == MessageButtonType.goodResponse ||
        type == MessageButtonType.badResponse) {
      bool? promptIsGoodResponse = prompt.isGoodResponse;
      bool isGoodResponse = type == MessageButtonType.goodResponse;
      bool? res;
      // If the prompt is already marked as good response, then unmark it
      if (promptIsGoodResponse == isGoodResponse) {
        res = null;
      } else {
        res = isGoodResponse;
      }
      print('Prompt is good response: $res');
      context.read<HomeBloc>().add(HomePromptMarkedGoodOrBad(prompt, res));
    }
  }

  @override
  Widget build(BuildContext context) {
    Breakpoint breakpoint =
        Breakpoint.fromWidth(MediaQuery.of(context).size.width);
    scaffoldMessengerState = ScaffoldMessenger.of(context);
    final padding = breakpoint != Breakpoint.mobile
        ? const EdgeInsets.symmetric(horizontal: 100)
        : const EdgeInsets.all(8);
    return BlocProvider(
      create: (context) => sl<HomeBloc>()..add(HomeStarted()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            drawer: breakpoint != Breakpoint.desktop
                ? GeminiDrawer(
                    key: UniqueKey(),
                    conversations: state.conversations ?? [],
                    onNewConversationSelected: () {
                      context.read<HomeBloc>().add(HomeStarted());
                    },
                    onConversationSelected: (id) => context
                        .read<HomeBloc>()
                        .add(HomeConversationSelected(id)),
                    onConversationDeleted: (id) {
                      context.read<HomeBloc>().add(HomeConversationDeleted(id));
                    },
                  )
                : null,
            body: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                breakpoint == Breakpoint.desktop
                    ? GeminiDrawer(
                        onNewConversationSelected: () {
                          context.read<HomeBloc>().add(HomeStarted());
                        },
                        onConversationSelected: (id) => context
                            .read<HomeBloc>()
                            .add(HomeConversationSelected(id)),
                        conversations: state.conversations ?? [],
                        onConversationDeleted: (id) {
                          context
                              .read<HomeBloc>()
                              .add(HomeConversationDeleted(id));
                        },
                      )
                    : const SizedBox.shrink(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state is HomeLoading)
                        const Expanded(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (state is HomeNewChat)
                        const Expanded(
                          child: HomeWelcome(),
                        )
                      else
                        Expanded(
                            child: ListView.builder(
                          cacheExtent: 2000,
                          padding: breakpoint == Breakpoint.mobile
                              ? const EdgeInsets.all(8)
                              : const EdgeInsets.only(
                                  top: 16, left: 100, right: 100),
                          itemCount: state.prompts!.length + 1,
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            if (index < state.prompts!.length) {
                              return MessageBubble(
                                key: UniqueKey(),
                                prompt: state.prompts![index],
                                isLastResponse:
                                    index == state.prompts!.length - 1,
                                onButtonPressed: (type) {
                                  likeButtonPressed(
                                      context, state.prompts![index], type);
                                },
                              );
                            } else {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Visibility(
                                    visible: state.isGenerating,
                                    child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child:
                                          Image.asset(Assets.sparkleThinking),
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        )),
                      GemiTextField(
                        padding: padding,
                        onSend: (text, images) async {
                          context.read<HomeBloc>().add(
                                HomePromptSubmitted(
                                    text: text,
                                    images: images?.map((e) => e.path).toList(),
                                    onPromptSubmitted: _scrollDown),
                              );
                        },
                        onTap: () {
                          _scrollDown();
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
