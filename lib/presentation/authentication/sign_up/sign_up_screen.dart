import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemi/core/utils/validator.dart';
import 'package:gemi/dependency_container.dart';
import 'package:gemi/presentation/home/widgets/gradient_text.dart';

import 'bloc/sign_up_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _firstNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => sl<SignUpBloc>(),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
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
                  child: BlocListener<SignUpBloc, SignUpState>(
                    listener: (blocContext, state) {
                      if (state is SignUpSuccess) {
                        // Handle success state
                        ScaffoldMessenger.of(blocContext).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                        // Navigate to next screen or do any other operation
                      } else if (state is SignUpFailure) {
                        // Handle failure state
                        ScaffoldMessenger.of(blocContext).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                    },
                    child: Column(children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _firstNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your first name";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: "First Name",
                                hintText: "Enter your first name",
                                border: OutlineInputBorder(),
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              controller: _lastNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your last name";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: "Last Name",
                                hintText: "Enter your last name",
                                border: OutlineInputBorder(),
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        validator: Validator.validateEmail,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          hintText: "Enter your email",
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        validator: Validator.validatePassword,
                        decoration: InputDecoration(
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
                          border: const OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return "Passwords must match";
                          }
                          // Add other validation logic if needed
                          return Validator.validatePassword(value);
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: _toggleConfirmPasswordVisibility,
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          labelText: "Confirm Password",
                          hintText: "Re-enter your password",
                          border: const OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (value) {
                          if (_formKey.currentState!.validate()) {
                            // Trigger sign-up event
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                // Handle navigation to sign-in screen
                                Navigator.of(context).pop();
                              },
                              child: const Text("Already have an account?"),
                            ),
                            BlocBuilder<SignUpBloc, SignUpState>(
                              builder: (context, state) {
                                if (state is SignUpLoading) {
                                  return const CircularProgressIndicator();
                                }
                                return ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<SignUpBloc>().add(
                                            SignUpWithEmailAndPassword(
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text,
                                              confirmPassword:
                                                  _confirmPasswordController
                                                      .text,
                                              firstName:
                                                  _firstNameController.text,
                                              lastName:
                                                  _lastNameController.text,
                                            ),
                                          );
                                    }
                                  },
                                  child: const Text("Sign Up"),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
