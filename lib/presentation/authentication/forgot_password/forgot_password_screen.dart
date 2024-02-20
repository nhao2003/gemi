import 'package:flutter/material.dart';
import 'package:gemi/core/utils/validator.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _sendResetPasswordEmail() async {
    if (_formKey.currentState!.validate()) {}
  }

  final focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  focusNode: focusNode,
                  controller: _emailController,
                  validator: Validator.validateEmail,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    hintText: 'Enter your email address',
                    border: OutlineInputBorder(),
                  ),
                  onTapOutside: (term) {
                    focusNode.unfocus();
                  },
                  onFieldSubmitted: (term) {
                    _sendResetPasswordEmail();
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _sendResetPasswordEmail,
                  child: const Text('Send Reset Link'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
