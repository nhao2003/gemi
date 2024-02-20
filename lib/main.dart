// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemi/data/data_source/local/local_database.dart';
import 'package:gemi/dependency_container.dart';
import 'package:gemi/presentation/authentication/forgot_password/forgot_password_screen.dart';
import 'package:gemi/presentation/authentication/sign_up/bloc/sign_up_bloc.dart';
import 'package:gemi/presentation/home/home_screen.dart';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:gemi/presentation/setting/setting_screen.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'presentation/authentication/sign_in/bloc/sign_in_bloc.dart';
import 'presentation/authentication/sign_in/sign_in_screen.dart';
import 'presentation/authentication/sign_up/sign_up_screen.dart';
import 'presentation/home/bloc/home_bloc.dart';
import 'presentation/setting/bloc/setting_bloc.dart';
import 'presentation/splash/bloc/splash_bloc.dart';
import 'presentation/splash/gradient_animated_container.dart';
import 'presentation/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // 4285f4
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xff4285f4),
          ).copyWith(background: Colors.white),
          drawerTheme: const DrawerThemeData(
            backgroundColor: Colors.white,
          ),
        ),
        initialRoute: '/splash',
        routes: {
          '/home': (context) => const HomeScreen(
                title: "Gemini",
              ),
          '/sign_in': (context) => const SignInScreen(),
          'sign_up': (context) => const SignUpScreen(),
          '/splash': (context) => const SplashScreen(),
          '/setting': (context) => const SettingScreen(),
          'forgot_password': (context) => const ForgotPasswordScreen()
        });
  }
}
