import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:notly/Helpers/Authentication.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:notly/Helpers/Constant/Colors.dart';
import 'package:notly/Screens/Home.dart';
import 'package:notly/Widgets/CustomButton.dart';
import 'package:notly/Widgets/CustomField.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  Auth _auth = Auth();
  final _formKey = GlobalKey<FormState>();
  final firestoreInstance = FirebaseFirestore.instance;

  TextEditingController _emailController;
  TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController?.dispose();
    _passwordController?.dispose();
  }

  Future<void> _onTapSingIn(context) async {
    final progress = ProgressHUD.of(context);

    if (!_formKey.currentState.validate()) return;
    progress.showWithText('Loading...');
    try {
      UserCredential authResult =
          await _auth.signIn(_emailController.text, _passwordController.text);
      progress.dismiss();
      String uid = authResult.user.uid.toString();
      SharedPreferences userUid = await SharedPreferences.getInstance();
      userUid.setString('UID', uid);
      if (authResult == null) {
        return;
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
    } on FirebaseAuthException catch (e) {
      progress.dismiss();

      Future.error(e);
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            'Oh something went wrong!',
            style: TextStyle(
              fontSize: 19,
            ),
          ),
          content: Text(e.message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: CColors.lightRedTheme,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Scaffold(
      body: ProgressHUD(
        child: Builder(
          builder: (context) {
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 40),
                    CustomTextField(
                      maxLines: 1,
                      hint: "Enter email",
                      icon: Icon(
                        Icons.email_outlined,
                        color: CColors.textFelidHintTheme,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter your email';
                        }
                        return null;
                      },
                      controller: _emailController,
                      obscureText: false,
                    ),
                    CustomTextField(
                      maxLines: 1,
                      hint: "Password",
                      icon: Icon(
                        Icons.vpn_key_outlined,
                        color: CColors.textFelidHintTheme,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter your password';
                        }
                        return null;
                      },
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(
                              color: CColors.textFelidHintTheme,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomButton(
                        text: "Sign in",
                        onTap: () async => await _onTapSingIn(context),
                        color: CColors.lightRedTheme,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade100,
                            thickness: 1,
                            indent: 8,
                            endIndent: 8,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Not a member?",
                              style: TextStyle(
                                color: CColors.blackTheme,
                                fontSize: 11,
                              ),
                            ),
                            SizedBox(width: 4),
                            GestureDetector(
                              onTap: () =>
                                  Navigator.pushNamed(context, '/SignUp'),
                              child: Text(
                                "Regiaster now",
                                style: TextStyle(
                                  color: CColors.lightRedTheme,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade100,
                            thickness: 1,
                            indent: 8,
                            endIndent: 8,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
