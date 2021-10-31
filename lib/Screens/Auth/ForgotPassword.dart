import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notly/Helpers/Constant/Colors.dart';
import 'package:notly/Widgets/CustomButton.dart';
import 'package:notly/Widgets/CustomTextField.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  TextEditingController _emailController;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController?.dispose();
  }

  _onTapSendMail(context) async {
    if (!_formKey.currentState.validate()) return;

    firebaseAuth
        .sendPasswordResetEmail(email: _emailController.text)
        .then((value) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/LogIn', (Route<dynamic> route) => false);
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            'Check your mail inbox !',
            style: TextStyle(
              fontSize: 19,
              color: CColors.lightRedTheme,
            ),
          ),
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
    }).onError(
      (error, stackTrace) async => await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            error.message,
            style: TextStyle(
              fontSize: 19,
              color: CColors.lightRedTheme,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: CColors.lightRedTheme,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Forgot password!",
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                "assets/images/notes.svg",
                height: 150,
              ),
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
                  return 'Enter your email';
                }
                return null;
              },
              controller: _emailController,
              obscureText: false,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                text: "Change password",
                onTap: () async => await _onTapSendMail(context),
                color: CColors.lightRedTheme,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
