import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemi/data/model/gemini/gemini_safety/safety_category.dart';
import 'package:gemi/data/model/gemini/gemini_safety/safety_threshold.dart';
import 'package:gemi/dependency_container.dart';
import 'package:gemi/presentation/setting/widgets/safety_setting_dialog.dart';

import 'bloc/setting_bloc.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text("Account"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text("Safety & Setting"),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return BlocBuilder<SettingBloc, SettingState>(
                        bloc: sl<SettingBloc>()
                          ..add(GetSafetyCategorySettings()),
                        builder: (context, state) {
                          var safetySettings =
                              state is SafetyCategorySettingsLoaded
                                  ? Map<SafetyCategory, int>.from(
                                      state.safetyCategorySettings)
                                  : Map<SafetyCategory, int>.from({});
                          return SafetySettingDialog(
                            safetySettings: safetySettings,
                            isLoading: state is SafetyCategorySettingsLoading,
                            onSave: (safetySettings) {
                              this.context.read<SettingBloc>().add(
                                  SetSafetyCategorySettings(safetySettings));
                            },
                          );
                        },
                      );
                    });
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text("Clear all chat history"),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Clear all chat history"),
                      content: const Text(
                          "Are you sure you want to clear all chat history?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Clear"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About"),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: "Gemi",
                  applicationVersion: "1.0.0",
                  applicationIcon: const Icon(Icons.chat),
                  children: const [
                    Text("Gemi is a chat application"),
                  ],
                );
              },
            ),
            BlocConsumer<SettingBloc, SettingState>(
              listener: (context, state) {
                if (state is SignOutSuccess) {
                  Navigator.pushReplacementNamed(context, '/sign_in');
                }
              },
              builder: (context, state) {
                if (state is SignOutLoading) {
                  return const CircularProgressIndicator();
                }
                return ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Sign out"),
                  onTap: () {
                    context.read<SettingBloc>().add(SignOut());
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
