import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notly/Helpers/Authentication.dart';
import 'package:notly/Helpers/Constant/Colors.dart';
import 'package:notly/Screens/AddNote.dart';
import 'package:notly/Screens/Auth/Login.dart';
import 'package:notly/Screens/Auth/SignUp.dart';
import 'package:notly/Screens/Home.dart';
import 'package:notly/Screens/ViewNote.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Auth _auth = Auth();
  Widget _currentScreen;
  @override
  void initState() {
    super.initState();
    checkIfLogged();
  }

  checkIfLogged() {
    if (_auth.getUser() == null) {
      _currentScreen = LogIn();
    } else {
      _currentScreen = Home();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: CColors.whiteTheme,
        // Color(0xff333333)

        accentColor: CColors.lightRedTheme,
        fontFamily: 'SFProText',
      ),
      home: _currentScreen,
      routes: {
        '/Home': (context) => Home(),
        '/SignUp': (context) => SignUp(),
        '/LogIn': (context) => LogIn(),
        '/ViewNote': (context) => ViewNote(),
        '/AddNote': (context) => AddNote(),
      },
    );
  }
}
