import 'package:flutter/material.dart';
import 'package:notly/Helpers/Constant/Colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _selectedTheme;
  ThemeData light = ThemeData.light().copyWith(
    backgroundColor: CColors.whiteTheme,
    accentColor: CColors.lightRedTheme,
    textTheme: TextTheme(
      bodyText1: TextStyle(
        fontFamily: 'SFProText',
      ),
    ),
  );
  ThemeData dark = ThemeData.dark().copyWith(
    backgroundColor: Color(0xff121212),
    accentColor: CColors.lightRedTheme,
    textTheme: TextTheme(
      bodyText1: TextStyle(
        fontFamily: 'SFProText',
      ),
    ),
  );
  ThemeProvider({bool isDark}) {
    _selectedTheme = isDark ? dark : light;
  }
  ThemeData get getTheme => _selectedTheme;

  void changeTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_selectedTheme == dark) {
      _selectedTheme = light;
      prefs.setBool('isDark', false);
    } else {
      _selectedTheme = dark;
      prefs.setBool('isDark', true);
    }
    notifyListeners();
  }
}
