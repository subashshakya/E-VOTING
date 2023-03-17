// import 'package:evoting_ui/admin_view/cadnidate_list.dart';
import 'package:evoting_ui/admin_view/admin/admin_login.dart';
import 'package:evoting_ui/admin_view/super_admin/admin.dart';
import 'package:evoting_ui/admin_view/super_admin/super_admin_login.dart';
import 'package:evoting_ui/admin_view/super_admin/candidate_list.dart';
import 'package:evoting_ui/home/homepage.dart';
import 'package:evoting_ui/providers/candidate_provider.dart';
import 'package:evoting_ui/real_time_votecount/rt_vote_count.dart';
// import './user_view/voter_view/biometric_verification.dart';
// import './admin_view/admin.dart';
import 'package:evoting_ui/theme/theme_constants.dart';
import 'package:evoting_ui/user_view/end_voting.dart';
import 'package:evoting_ui/user_view/user_auth.dart';
import 'package:evoting_ui/user_view/biometric_verification.dart';
import 'package:flutter/material.dart';
// import './user_view/user_auth.dart';
// import './admin_view/imagepicker.dart';
import './theme/theme_manager.dart';
import 'user_view/voting_list.dart';
// import 'user_view/user_auth.dart';
import 'package:provider/provider.dart';
// import './providers/candidate_provider.dart';
import 'package:get/get.dart';
import './localization/localization.dart';
import 'user_view/select_language.dart';
import 'admin_view/admin/admin_pannel.dart';

void main() => runApp(App());

ThemeManager _themeManager = ThemeManager();

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        translations: Localization(),
        locale: const Locale('en', 'US'),
        debugShowCheckedModeBanner: false,
        title: 'E-VOTING',
        theme: darkTheme,
        // lightTheme: lightTheme,
        themeMode: _themeManager.themeMode,
        home: Admin("kajsdk"));
  }
}
