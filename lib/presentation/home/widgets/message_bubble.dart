import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gemi/global/markdown_viewer.dart';
import 'package:gemi/presentation/home/widgets/image_grid.dart';
import 'package:gemi/presentation/home/widgets/image_viewer_dialog.dart';
import 'package:share_plus/share_plus.dart';

import '../../../data/model/gemini/content/content.dart';
import '../../../domain/entities/prompt.dart';
import '../../../core/resource/assets.dart';

// enum buttonType { like, dislike, share, more }

enum MessageButtonType {
  goodResponse,
  badResponse,
  modifyResponse,
  shareResponse,
  searchRelatedTopics,
  more,
}

class MessageBubble extends StatelessWidget {
  // const ChatBubble({Key? key, required this.prompt}) : super(key: key);
  final Prompt prompt;
  final bool isLastResponse;
  final Function(MessageButtonType)? onButtonPressed;

  const MessageBubble({
    super.key,
    required this.prompt,
    this.isLastResponse = false,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    ScaffoldMessengerState? scaffoldMessengerState =
        ScaffoldMessenger.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: prompt.role == Role.user
                ? const CircleAvatar(
                    child: Icon(Icons.person_rounded),
                  )
                : SizedBox(
                    width: 40,
                    height: 40,
                    child: isLastResponse
                        ? Image.asset(Assets.sparkleResting)
                        : SvgPicture.asset(
                            Assets.logoSingleColorV2,
                          ),
                  ),
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: prompt.role == Role.user
                        ? const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16)
                        : null,
                    decoration: BoxDecoration(
                      color: prompt.role == Role.user
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.2)
                          : null,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (prompt.role == Role.user)
                          Text(
                            prompt.text,
                          )
                        else
                          MarkDownViewer(
                            data: prompt.text,
                          ),
                        prompt.images != null && prompt.images!.isNotEmpty
                            ? ImageGrid(
                                prompt.images!,
                                onMediaTap: (index) {
                                  // Show dialog. User can swipe to view images
                                  showDialog(
                                    context: context,
                                    builder: (context) => ImageViewDialog(
                                      prompt.images!,
                                      initialIndex: index,
                                    ),
                                  );
                                },
                              )
                            : const SizedBox.shrink(),
                      ],
                    )),
                if (prompt.role != Role.user && !prompt.isStreaming)
                  Row(
                    children: [
                      // Like button, dislike button, share button, more button
                      // Like button, dislike button, share button, more button
                      IconButton(
                        tooltip: "Good response",
                        onPressed: () {
                          onButtonPressed?.call(MessageButtonType.goodResponse);
                        },
                        icon: Icon(
                          prompt.isGoodResponse == true
                              ? Icons.thumb_up
                              : Icons.thumb_up_off_alt_outlined,
                        ),
                      ),
                      IconButton(
                        tooltip: "Bad response",
                        onPressed: () {
                          onButtonPressed?.call(MessageButtonType.badResponse);
                        },
                        icon: Icon(
                          prompt.isGoodResponse == false
                              ? Icons.thumb_down
                              : Icons.thumb_down_off_alt_outlined,
                        ),
                      ),
                      IconButton(
                        tooltip: "Modify response",
                        onPressed: () {},
                        icon: const Icon(
                          // Modify
                          Icons.tune,
                        ),
                      ),
                      IconButton(
                        tooltip: "Share & export",
                        onPressed: () async {
                          // Share text
                          await Share.share(
                              'check out my website https://example.com',
                              subject: 'Look what I made!');
                        },
                        icon: const Icon(
                          Icons.share_outlined,
                        ),
                      ),
                      // Googled this
                      IconButton(
                          tooltip: "Search related topics",
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            Assets.googleLogo,
                            width: 24,
                          )),

                      PopupMenuButton(
                        tooltip: "More",
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            onTap: () async {
                              await Clipboard.setData(
                                  ClipboardData(text: prompt.text));
                              scaffoldMessengerState!.hideCurrentSnackBar();
                              scaffoldMessengerState!
                                  .showSnackBar(const SnackBar(
                                content: Text("Copied to clipboard"),
                              ));
                            },
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.copy_outlined,
                                ),
                                SizedBox(width: 8),
                                Text("Copy"),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            // child: Text("Report legal issue"),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.report_outlined,
                                ),
                                SizedBox(width: 8),
                                Text("Report"),
                              ],
                            ),
                          ),
                        ],
                        icon: const Icon(
                          Icons.more_vert_rounded,
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
