import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gemi/core/utils/string_util.dart';
import 'package:gemi/dependency_container.dart';
import 'package:gemi/presentation/authentication/sign_in/bloc/sign_in_bloc.dart';
import 'package:gemi/presentation/home/widgets/gradient_text.dart';
import 'package:gemi/resource/assets.dart';

import '../forgot_password/forgot_password_screen.dart';
import '../sign_up/sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SignInBloc>(),
      child: BlocListener<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state is SignInSuccess) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is SignInError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const GradientText(
                      "Welcome",
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                      ),
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Supercharge your creativity and productivity',
                    ),
                    const Text(
                        "Chat to start writing, planning, learning and more with Google AI"),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your email";
                              } else if (!StringUtil.isValidEmail(value)) {
                                return "Please enter a valid email";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email),
                              labelText: "Email",
                              hintText: "Enter your email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                            ),
                            // Next focus to password field
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                onPressed: _togglePasswordVisibility,
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                              labelText: "Password",
                              hintText: "Enter your password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your password";
                              } else if (value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                            onFieldSubmitted: (term) {
                              if (_formKey.currentState!.validate()) {
                                // Do something
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/forgot_password');
                                  },
                                  child: const Text("Forgot Password?"),
                                ),
                                BlocBuilder<SignInBloc, SignInState>(
                                  builder: (context, state) {
                                    if (state is SignInLoading) {
                                      return const CircularProgressIndicator();
                                    }
                                    return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          context.read<SignInBloc>().add(
                                                SignInWithEmailAndPassword(
                                                  email: _emailController.text,
                                                  password:
                                                      _passwordController.text,
                                                ),
                                              );
                                        }
                                      },
                                      child: const Text(
                                        "Sign In",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Divider(),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text("or sign in with"),
                              ),
                              Expanded(
                                child: Divider(),
                              ),
                            ],
                          ),
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              label: const Text("Sign In with Google"),
                              icon: SvgPicture.asset(
                                Assets.googleLogo,
                                width: 24,
                              ),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              label: const Text("Sign In with Facebook"),
                              icon: const Icon(Icons.facebook),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account?"),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpScreen(),
                                    ),
                                  );
                                },
                                child: const Text("Sign Up"),
                              ),
                            ],
                          ),

                          // By signing in, you agree to our Terms of Service and Privacy Policy
                          RichText(
                            text: const TextSpan(
                              text: "By signing in, you agree to our ",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: "Terms of Service",
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                                TextSpan(
                                  text: " and ",
                                ),
                                TextSpan(
                                  text: "Privacy Policy",
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
