import 'package:flutter/material.dart';
import 'package:notly/Helpers/Constant/Colors.dart';
import 'package:notly/Services/PreferenceUtils.dart';

class ThemeProvider extends ChangeNotifier {
  PreferenceUtils _prefs;
  ThemeData selectedTheme;

  ThemeProvider() {
    _prefs = PreferenceUtils.instancePreference;
  }

  bool get isDark => _prefs.getValue('isDark', hideDebugPrint: true);
  String get nameTheme => this.isDark ? 'Dark' : 'Light';

  ThemeData light = ThemeData.light().copyWith(
    backgroundColor: CColors.whiteTheme,
    textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'SFProText',
        ),
    primaryTextTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'SFProText',
        ),
  );
  ThemeData dark = ThemeData.dark().copyWith(
    backgroundColor: Color(0xff121212),
    textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'SFProText',
        ),
    primaryTextTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'SFProText',
        ),
  );

  void initTheme() {
    selectedTheme = this.isDark ? dark : light;
    notifyListeners();
  }

  void changeTheme() {
    if (selectedTheme == dark) {
      selectedTheme = light;
      _prefs.saveValueWithKey('isDark', false);
    } else {
      selectedTheme = dark;
      _prefs.saveValueWithKey('isDark', true);
    }
    notifyListeners();
  }
}
