import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes/dialogs/error_dialog.dart';
import 'package:my_notes/dialogs/password_reset_email_sent_dialog.dart';
import 'package:my_notes/services/auth/bloc/auth_bloc.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetEmailSentDialog(context);
          }
          if (state.exception != null) {
            if (context.mounted) {
              await showErrorDialog(
                context,
                'We could not process your request. Please make sure that you are a registered user, or if not, register a user now by going back one step',
              );
            }
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Forgot Password'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                  'If you forgot your password, simply enter your email and we will send you a password reset link.'),
              TextField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                autofocus: true,
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Your email address...',
                ),
              ),
              TextButton(
                onPressed: () {
                  final email = _controller.text;
                  context.read<AuthBloc>().add(
                        AuthEventForgotPassword(email: email),
                      );
                },
                child: const Text('Sent me password reset link'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventLogOut(),
                      );
                },
                child: const Text('Back to login page'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
