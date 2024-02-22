import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gemi/data/repository/gemini_repository_impl.dart';
import 'package:gemi/data/stream_data.dart';
import 'package:gemi/domain/entities/conversation.dart';
import 'package:gemi/presentation/home/bloc/home_bloc.dart';

import '../../../data/data_source/local/gemini_local_data_source/gemini_local_data_source_impl.dart';
import '../../../data/data_source/local/local_database.dart';
import '../../../data/data_source/remote/gemini_remote_data_source/gemini_remote_data_source.dart';
import '../../../core/resource/assets.dart';
import '../../setting/setting_screen.dart';

class GeminiDrawer extends StatelessWidget {
  final Function(String) onConversationSelected;
  final Function() onNewConversationSelected;
  final List<Conversation> conversations;
  final Function(String) onConversationDeleted;
  final Function() onSettingsSelected;
  const GeminiDrawer({
    super.key,
    required this.onConversationSelected,
    required this.onNewConversationSelected,
    required this.conversations,
    required this.onConversationDeleted,
    required this.onSettingsSelected,
  });
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeader(
                child:
                    Center(child: SvgPicture.asset(Assets.logoSingleColorV2))),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
              child: ElevatedButton.icon(
                onPressed: () {
                  onNewConversationSelected();
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.add),
                label: const Text("New Chat"),
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.transparent,
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  minimumSize: const Size(64, 44),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: conversations.map((e) {
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).pop();
                        onConversationSelected(e.id);
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Delete conversation"),
                              content: const Text(
                                  "Are you sure you want to delete this conversation?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    onConversationDeleted(e.id);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Delete"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      title: Text(
                        e.name,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // Random icon
                      leading: const Icon(
                        Icons.chat_bubble_outline,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            ListTile(
              onTap: onSettingsSelected,
              title: Text(
                'Settings',
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // Random icon
              trailing: const Icon(
                Icons.settings_outlined,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
