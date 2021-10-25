import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:notly/Helpers/Authentication.dart';

import 'package:notly/Helpers/Constant/Colors.dart';
import 'package:notly/Screens/Home.dart';
import 'package:notly/Widgets/CustomButton.dart';
import 'package:notly/Widgets/CustomField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final firestoreInstance = FirebaseFirestore.instance;
  Auth _auth = Auth();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _reEnterPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _reEnterPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _reEnterPasswordController.dispose();
  }

  Future<void> _onTapSingUp(context) async {
    final progress = ProgressHUD.of(context);
    if (!_formKey.currentState.validate()) return;
    progress.showWithText('Loading...');
    try {
      UserCredential authResult =
          await _auth.signUp(_emailController.text, _passwordController.text);
      progress.dismiss();
      if (authResult == null) {
        return;
      } else {
        String uid = authResult.user.uid.toString();
        SharedPreferences userUid = await SharedPreferences.getInstance();
        userUid.setString('UID', uid);
        firestoreInstance.collection('users').doc(uid).set({
          'name': _nameController.text,
          'email': _emailController.text,
        });
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CColors.whiteTheme,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CColors.whiteTheme,
        iconTheme: IconThemeData(
          color: CColors.lightRedTheme,
        ),
      ),
      body: ProgressHUD(
        child: Builder(builder: (context) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: size.width / 1.5,
                    child: Text(
                      "Create your account, start enjoying the unlimited experience!",
                      style: TextStyle(
                        color: CColors.blackTheme,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                CustomTextField(
                  maxLines: 1,
                  hint: "Enter your name",
                  icon: Icon(
                    Icons.person_outline,
                    color: CColors.textFelidHintTheme,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter User Name';
                    }
                    return null;
                  },
                  controller: _nameController,
                  obscureText: false,
                ),
                CustomTextField(
                  maxLines: 1,
                  hint: "Enter email",
                  icon: Icon(
                    Icons.email_outlined,
                    color: CColors.textFelidHintTheme,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter you Email';
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
                      return 'Enter password';
                    }
                    return null;
                  },
                  controller: _passwordController,
                  obscureText: true,
                ),
                CustomTextField(
                  maxLines: 1,
                  hint: "Re-Enter Password",
                  icon: Icon(
                    Icons.vpn_key_outlined,
                    color: CColors.textFelidHintTheme,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Re-Enter password';
                    }
                    return null;
                  },
                  controller: _reEnterPasswordController,
                  obscureText: true,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "By creating this account you agree to all our terms and conditions.",
                    style: TextStyle(
                      color: CColors.textFelidHintTheme,
                      fontSize: 12,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    text: "Sign up",
                    onTap: () async => await _onTapSingUp(context),
                    color: CColors.lightRedTheme,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
