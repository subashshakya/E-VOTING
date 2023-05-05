import 'package:evoting_ui/admin_view/admin/admin_login.dart';
import 'package:evoting_ui/admin_view/super_admin/super_admin_login.dart';
import 'package:evoting_ui/user_view/select_language.dart';
import 'package:flutter/material.dart';
import './home_button.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<IconData> iconNames = [
    Icons.admin_panel_settings_outlined,
    Icons.account_balance_sharp,
    Icons.account_circle_outlined
  ];

  List<String> roleNames = ["Super Admin", "Admin", "User"];

  void gotoAdmin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AdminLoginPannel()));
  }

  void gotoSuperAdmin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AdminLogin()));
  }

  void gotoVoter() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LanguageSelection()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              const SizedBox(height: 200),
              const Text("SELECT OPTION FOR VIEWING",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              HomeButton(
                  title: roleNames[0],
                  func: gotoSuperAdmin,
                  iconName: iconNames[0]),
              HomeButton(
                  title: roleNames[1], func: gotoAdmin, iconName: iconNames[1]),
              HomeButton(
                  title: roleNames[2], func: gotoVoter, iconName: iconNames[2]),
            ],
          )),
    );
  }
}
