// This file contains smaller widgets used during the user authentication flow

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'auth_pages.dart';
import 'main.dart';
import 'my_app_state.dart';
import 'theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uni_links/uni_links.dart';

// This widget displays and handles login
class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key, required this.switchToSignUp});

  // This void callback switches from the sign in page to the sign up page
  final VoidCallback switchToSignUp;

  @override
  // ignore: library_private_types_in_public_api
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // These string variables are used to display error text below the username and password
  String _emailErrorMessage = '';
  String _passwordErrorMessage = '';
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
  }

  void _initDeepLinkListener() {
    _sub = linkStream.listen((String? link) {
      if (link != null) {
        print(link);
        final uri = Uri.parse(link);
        if (uri.host == 'auth') {
          final token = uri.queryParameters['access_token'];
          print("Token: $token");
          fetchLinkedInProfile(token!);
        }
      }
    }, onError: (err) {
      print('Failed to receive deep link: $err');
    });
  }

  void fetchLinkedInProfile(String accessToken) async {
    const profileUrl = 'https://api.linkedin.com/v2/userinfo';
    final headers = {'Authorization': 'Bearer $accessToken'};

    final profileResponse =
        await http.get(Uri.parse(profileUrl), headers: headers);
    if (profileResponse.statusCode == 200) {
      final profileData = json.decode(profileResponse.body);
      print('LinkedIn Profile: $profileData');
    } else {
      print(
          'Failed to fetch LinkedIn profile: ${profileResponse.statusCode}, ${profileResponse.body}');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            // This is the header
            Text(
              'Sign in',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              // This is where the user enters their email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorMaxLines: 3,
                  errorText:
                      _emailErrorMessage.isEmpty ? null : _emailErrorMessage,
                ),
                validator: (value) => noEmptyField(value),
              ),
              // This is where the user enters their password
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorMaxLines: 3,
                  errorText: _passwordErrorMessage.isEmpty
                      ? null
                      : _passwordErrorMessage,
                ),
                obscureText: true,
                validator: (value) => noEmptyField(value),
              ),
              // This is the sign in button
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    signIn();
                  }
                },
                child: const Text('Sign in'),
              ),
              const SizedBox(height: 10),
              // This is the forgot password button
              MouseRegion(
                cursor: MaterialStateMouseCursor.clickable,
                child: GestureDetector(
                  child: Text(
                    'Forgot Password?',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).primaryColorLight,
                          decoration: TextDecoration.underline,
                          decorationColor: Theme.of(context).primaryColorLight,
                        ),
                  ),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ForgotPasswordPage(),
                  )),
                ),
              ),
              const SizedBox(height: 5),
              // This is the button to switch to the sign up page
              RichText(
                text: TextSpan(
                  text: 'No account? ',
                  style: Theme.of(context).textTheme.bodySmall,
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.switchToSignUp,
                      text: 'Sign up',
                      style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        decoration: TextDecoration.underline,
                        decorationColor: Theme.of(context).primaryColorLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12.5),
              const Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(color: Colors.grey),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.5),
                    child: Text(
                      "OR",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 12.5),
              CustomImageButton(
                height: 50,
                width: 200,
                image: const AssetImage('assets/sign_in.png'),
                onTap: () => loginWithLinkedIn(),
              ),
            ],
          ),
        ),
      ],
    );
  }

// This method allows the user to sign in
  Future<void> signIn() async {
    // After this method starts running, a loading page is shown
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Here, the user is signed in Firebase Auth
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (error) {
      // Here, an error message is shown based on the type of error given
      if (error.code == 'invalid-email') {
        setState(() {
          _emailErrorMessage = 'The email address is badly formatted.';
          _passwordErrorMessage = '';
        });
      } else if (error.code == 'invalid-credential') {
        setState(() {
          _emailErrorMessage = '';
          _passwordErrorMessage =
              'No user found with the given combination of email and credentials.';
        });
      } else if (error.code == 'user-disabled') {
        setState(() {
          _emailErrorMessage =
              'The user account associated with this email is disabled.';
          _passwordErrorMessage = '';
        });
      } else {
        setState(() {
          _emailErrorMessage = '';
          _passwordErrorMessage = error.message ?? 'An unknown error occurred.';
        });
      }
    } catch (error) {
      setState(() {
        _emailErrorMessage = '';
        _passwordErrorMessage = error.toString();
      });
    }

    // Once this method is completed, the loading page is no longer shown
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future<void> loginWithLinkedIn() async {
    const clientId = '86w3jl8a5w2h0t';
    const redirectUrl = 'https://linkedin-oauth-server.onrender.com/auth';

    // Construct the url
    final authorizationUrl =
        Uri.https('www.linkedin.com', '/oauth/v2/authorization', {
      'response_type': 'code',
      'client_id': clientId,
      'redirect_uri': redirectUrl,
      'scope': 'openid email w_member_social',
    });

    await launchUrl(authorizationUrl);
  }
}

// This widget displays and handles signing up
class SignUpWidget extends StatefulWidget {
  const SignUpWidget({super.key, required this.switchtoSignIn});

  final VoidCallback switchtoSignIn;

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _schoolController = TextEditingController();
  final _yearController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isChecked = false;
  String _emailErrorMessage = '';
  String _passwordErrorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            // This is the header
            Text(
              'Sign up',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              // This is where the user enters their name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => noEmptyField(value),
              ),
              // This is where the user enters their school

              TextFormField(
                controller: _schoolController,
                decoration: const InputDecoration(labelText: 'School'),
                validator: (value) => noEmptyField(value),
              ),
              // This is where the user enters their year
              TextFormField(
                controller: _yearController,
                decoration:
                    const InputDecoration(labelText: 'Year of Graduation'),
                validator: (value) => validateGraduationYear(value),
              ),
              // This is where the user enters their email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorMaxLines: 3,
                  errorText:
                      _emailErrorMessage.isEmpty ? null : _emailErrorMessage,
                ),
                validator: (value) => noEmptyField(value),
              ),
              // This is where the user enters their passowrd
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorMaxLines: 3,
                  errorText: _passwordErrorMessage.isEmpty
                      ? null
                      : _passwordErrorMessage,
                ),
                obscureText: true,
                validator: (value) => noEmptyField(value),
              ),
              // This is where the user confirms their password
              TextFormField(
                controller: _confirmPasswordController,
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please confirm your password';
                  } else if (value == _passwordController.text) {
                    return null;
                  }
                  return 'Passwords do not match';
                },
              ),
              CheckboxListTile(
                value: isChecked,
                onChanged: (value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
                title: const Text("I accept the terms and conditions"),
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(4, 4),
                      blurRadius: 5,
                      spreadRadius: 0,
                    )
                  ],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextButton(
                  onPressed: () {
                    showTermsAndConditionsDialog(context);
                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.white),
                  ),
                  child: const Text('View Terms and Conditions'),
                ),
              ),
              const SizedBox(height: 30),
              // This is the sign up button
              ElevatedButton(
                onPressed: () {
                  if (isChecked) {
                    if (_formKey.currentState!.validate()) {
                      signUp();
                    }
                  } else {
                    showTextSnackBar(
                        'Please accept terms and conditions to continue');
                  }
                },
                child: const Text('Sign up'),
              ),
              const SizedBox(height: 10),
              // This is the button to switch to logging in
              RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: Theme.of(context).textTheme.bodySmall,
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.switchtoSignIn,
                      text: 'Sign in',
                      style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        decoration: TextDecoration.underline,
                        decorationColor: Theme.of(context).primaryColorLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ],
    );
  }

  // In this dialog box, the terms and conditions are shown
  void showTermsAndConditionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Terms and Conditions'),
          content: SingleChildScrollView(
            child: termsConditions,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

// This method creates a new user account
  void signUp() async {
    // After the method is called, a loading page is shown
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Here, a new account is created in Firebase Auth
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Here, a new user is created locally
      // ignore: use_build_context_synchronously
      context.read<MyAppState>().createLocalUser(
            _nameController.text.trim(),
            _schoolController.text.trim(),
            int.parse(_yearController.text.trim()),
          );
    } on FirebaseAuthException catch (error) {
      // Here, an error message is shown based on the type of error given
      if (error.code == 'invalid-email') {
        setState(() {
          _emailErrorMessage = 'The email address is badly formatted.';
          _passwordErrorMessage = '';
        });
      } else if (error.code == 'email-already-in-use') {
        setState(() {
          _emailErrorMessage = 'This email is already in use.';
          _passwordErrorMessage = '';
        });
      } else {
        setState(() {
          _emailErrorMessage = '';
          _passwordErrorMessage = error.message ?? 'An unknown error occurred.';
        });
      }
    } catch (error) {
      setState(() {
        _emailErrorMessage = '';
        _passwordErrorMessage = error.toString();
      });
    }

    // Once this method is completed, the loading page is no longer shown
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}

// This is the class navigated to after a verified user logs in or a new user verifies their email
class VerifiedHomePage extends StatefulWidget {
  const VerifiedHomePage({super.key, required this.newUser});
  final bool newUser;

  @override
  State<VerifiedHomePage> createState() => _VerifiedHomePageState();
}

class _VerifiedHomePageState extends State<VerifiedHomePage> {
  late Future<dynamic> _future;

  // An initState() is used so these methods are not called multiple times
  @override
  void initState() {
    super.initState();
    _future = ((widget.newUser)
        // Based on whether the user is new, a new account is created or user data is retrieved
        ? context.read<MyAppState>().createUserInDB()
        : context.read<MyAppState>().readUser());
  }

  @override
  Widget build(BuildContext context) {
    // The future are called here
    // Then, once the user and app are set up, the app navigates to the home page
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return errorMessage(snapshot.error, context);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const AnimatedLogo();
        } else {
          return const MyHomePage(
            title: '5 Minute संस्कृतम्',
          );
        }
      },
    );
  }
}
