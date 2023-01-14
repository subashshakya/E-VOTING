import './admin_view/admin.dart';
import 'package:evoting_ui/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import './user_view/user_auth.dart';
import './theme/theme_manager.dart';

void main() => runApp(App());

ThemeManager _themeManager = ThemeManager();

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-VOTING',
      theme: darkTheme,
      // lightTheme: lightTheme,
      themeMode: _themeManager.themeMode,
      home: Admin(),
    );
  }
}
