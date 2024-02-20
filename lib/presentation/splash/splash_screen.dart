import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemi/dependency_container.dart';
import 'package:gemi/presentation/authentication/sign_in/sign_in_screen.dart';
import 'package:gemi/presentation/home/widgets/gradient_text.dart';
import 'package:gemi/presentation/splash/bloc/splash_bloc.dart';
import 'package:gemi/presentation/splash/gradient_animated_container.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc(
        sl(),
      )..add(const CheckUserAuthenticated()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is UserAuthenticated) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is UserAuthenticationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        child: Scaffold(
          body: GradientAnimatedContainer(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    RichText(
                      text: const TextSpan(
                        text: 'Build with ',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: GradientText(
                              "Gemini",
                              gradient: LinearGradient(
                                colors: [Colors.blue, Colors.purple],
                              ),
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.5,
                      ),
                      child: const Text(
                        'Experience Google\'s largest and most capable AI model',
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    ElevatedButton(
                      child: const Text('Get Started'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInScreen()));
                      },
                    ),
                    // VideoPlayerScreen
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
