import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notly/Services/PreferenceUtils.dart';
import 'package:notly/Provider/ThemeProdiver.dart';
import 'package:notly/Screens/Auth/ForgotPassword.dart';
import 'package:notly/Services/Authentication.dart';
import 'package:notly/Screens/AddNote.dart';
import 'package:notly/Screens/Auth/Login.dart';
import 'package:notly/Screens/Auth/SignUp.dart';
import 'package:notly/Screens/Home.dart';
import 'package:notly/Screens/ViewNote.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PreferenceUtils.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
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
    Future.microtask(() => context.read<ThemeProvider>().initTheme());
    _checkIfLogged();
  }

  void _checkIfLogged() {
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
      theme: context.watch<ThemeProvider>().selectedTheme,
      home: _currentScreen,
      routes: {
        '/Home': (context) => Home(),
        '/SignUp': (context) => SignUp(),
        '/LogIn': (context) => LogIn(),
        '/ViewNote': (context) => ViewNote(),
        '/AddNote': (context) => AddNote(),
        '/ForgotPassword': (context) => ForgotPassword(),
      },
    );
  }
}
