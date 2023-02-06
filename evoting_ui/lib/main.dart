// import 'package:evoting_ui/admin_view/cadnidate_list.dart';
import 'package:evoting_ui/admin_view/admin.dart';
import 'package:evoting_ui/providers/candidate_provider.dart';
// import './user_view/voter_view/biometric_verification.dart';
// import './admin_view/admin.dart';
import 'package:evoting_ui/theme/theme_constants.dart';
import 'package:evoting_ui/user_view/user_auth.dart';
import 'package:evoting_ui/user_view/voter_view/biometric_verification.dart';
import 'package:flutter/material.dart';
// import './user_view/user_auth.dart';
// import './admin_view/imagepicker.dart';
import './theme/theme_manager.dart';
import './user_view/voter_view/voting_list.dart';
// import 'user_view/user_auth.dart';
import 'package:provider/provider.dart';
// import './providers/candidate_provider.dart';

void main() => runApp(App());

ThemeManager _themeManager = ThemeManager();

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CandidateProvider(),
      child: MaterialApp(
          title: 'E-VOTING',
          theme: darkTheme,
          // lightTheme: lightTheme,
          themeMode: _themeManager.themeMode,
          home: Admin()),
    );
  }
}
