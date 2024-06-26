// This file contains the main pages used in user authentication

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/my_app_state.dart';
import 'package:provider/provider.dart';
import 'auth_widgets.dart';
import 'main.dart';
import 'theme.dart';

// This class manages root authentication navigation
class AuthNav extends StatefulWidget {
  const AuthNav({super.key});

  @override
  State<AuthNav> createState() => _AuthNavState();
}

class _AuthNavState extends State<AuthNav> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: context.read<MyAppState>().tokenNotifier,
      builder: (context, token, child) {
        if (token == null) {
          return StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return errorMessage(snapshot.error, context);
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const AnimatedLogo();
              } else if (snapshot.hasData) {
                return const VerifyEmailPage();
              } else {
                return const AuthPage();
              }
            },
          );
        } else {
          return LinkedInAuthPage(
            profileInfo: context.read<MyAppState>().profileInfo,
          );
        }
      },
    );
  }
}

// This is the error message page
Widget errorMessage(Object? error, BuildContext context) {
  return Scaffold(
    appBar: appBar,
    body: Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [shadow],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Oops! Something went wrong',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'We apologize for the inconvenience. Please try again later.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Error: $error',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    CustomElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                      child: Text(
                        'Return to Login',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// This is the authentication page, where the user can log in, create a new account, etc.
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // The variable and method manage state based on whether the user is logging in or signing up
  bool login = true;
  void toggle() => setState(() {
        login = !login;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top section with logo and app name
          Container(
            color: Theme.of(context).colorScheme.secondary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 150),
                const Image(image: AssetImage("assets/logo.png"), height: 60),
                Text(
                  'Rise',
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).colorScheme.background),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: SingleChildScrollView(
                  child: login
                      ? LoginWidget(switchToSignUp: toggle)
                      : SignUpWidget(switchtoSignIn: toggle),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// This is the forgot password page
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        leading: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            navigatorKey.currentState!.pop();
          },
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        elevation: 0,
        title: Text(
          'Reset Password',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Colors.white,
              ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Theme.of(context).colorScheme.secondary,
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25, bottom: 20),
                    child: Text(
                      'Reset Password',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter your email to receive a password reset link.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: underlineInputDecoration(
                        context,
                        "Enter your email",
                        "Email",
                      ),
                      validator: (value) => noEmptyField(value),
                    ),
                    const SizedBox(height: 30),
                    CustomElevatedButton(
                      onPressed: resetPassword,
                      child: Text(
                        'Reset Password',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// This method sends a link to the user's email to reset their password
  Future resetPassword() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // A snackbar is shown based on whether the operation is successful
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showTextSnackBar("A reset password email was sent.");

      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } catch (error) {
      showTextSnackBar(
        "Error sending email: $error",
      );
      // Navigating back to the authentication page
      navigatorKey.currentState!.pop();
    }
  }
}

// Tis is the verify email page
class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool newUser = false;
  bool emailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  // Here, values are initialized, and an initial verification email is sent
  // The timer checks whether the user's email has been verified every 5 seconds
  @override
  void initState() {
    super.initState();
    emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!emailVerified) {
      sendVerificationEmail();
    } else {
      timer?.cancel();
    }

    timer = Timer.periodic(
      const Duration(seconds: 5),
      (context) => checkEmailVerified(),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (emailVerified)
        // If the email is verified, then they are sent to the verified page, with further navigation logic
        ? VerifiedHomePage(newUser: newUser)
        // Else, a simple page is shown, where users can resend a verification email or cancel
        : Scaffold(
            // A simple app bar that lets the user go back
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              elevation: 0,
              title: Text(
                'Verify Email',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.white,
                    ),
              ),
              leading: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Theme.of(context).colorScheme.secondary,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 25, bottom: 20),
                          child: Text(
                            'Verify Email',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'A verification email has been sent to your email address.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 30),
                        CustomElevatedButton(
                          onPressed: canResendEmail
                              ? () {
                                  sendVerificationEmail;
                                }
                              : null,
                          child: Text(
                            'Resend Email',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomElevatedButton(
                          onPressed: () => FirebaseAuth.instance.signOut(),
                          buttonColor: Colors.grey,
                          child: Text(
                            'Cancel',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

// This method sends the user a verification email
// If an error comes up, it displays a snack bar
  Future sendVerificationEmail() async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();

      // After an email is sent, the user must wait 5 seconds before sending another one
      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (error) {
      showTextSnackBar('Error sending email: $error');
    }
  }

// This method checks whether the user is verified
// It reloads the current user's data, and if they are verfied, cancels the timer
  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    if (!mounted) {
      return;
    }
    setState(() {
      emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      newUser = true;
    });

    if (emailVerified) {
      timer?.cancel();
    }
  }
}

class LinkedInAuthPage extends StatefulWidget {
  const LinkedInAuthPage({super.key, required this.profileInfo});
  final Map<String, dynamic> profileInfo;

  @override
  State<LinkedInAuthPage> createState() => _LinkedInAuthPageState();
}

class _LinkedInAuthPageState extends State<LinkedInAuthPage> {
  late Future<bool> _future;

  // An initState() is used so these methods are not called multiple times
  @override
  void initState() {
    super.initState();
    _future = context.read<MyAppState>().checkIfUserExists(
          widget.profileInfo["email"],
        );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return errorMessage(snapshot.error, context);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const AnimatedLogo();
        } else {
          if (snapshot.data == true) {
            // User exists, proceed to home page
            return const VerifiedHomePage(newUser: false);
          } else {
            // User doesn't exist, show sign up page
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                elevation: 0,
                title: Text(
                  'Sign Up With LinkedIn',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
              body: SingleChildScrollView(
                child: LinkedInSignUpWidget(
                  email: widget.profileInfo["email"],
                  name: widget.profileInfo["name"] ?? "",
                ),
              ),
            );
          }
        }
      },
    );
  }
}
