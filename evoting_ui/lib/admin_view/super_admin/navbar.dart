import 'package:evoting_ui/admin_view/super_admin/super_admin_login.dart';
import 'package:flutter/material.dart';
import './newcandidate.dart';
import './user_registration.dart';
import './admin_registration.dart';

class Navbar extends StatefulWidget {
  String token;

  Navbar(this.token);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  bool confirmation = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Colors.black12,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text("Super Admin"),
              accountEmail: const Text("superadmin@gmail.com"),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                    child: Image.asset('assets/admin.webp',
                        height: 70, width: 70, fit: BoxFit.cover)),
              ),
              decoration: const BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                    image: AssetImage("assets/admin_bd.webp"),
                    fit: BoxFit.cover),
              ),
            ),
            ListTile(
                leading: const Icon(Icons.assured_workload_outlined),
                title: const Text("Register Candidate"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewCandidate(widget.token)));
                }),
            ListTile(
              leading: const Icon(Icons.account_box_outlined),
              title: const Text("Register Voter"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserRegistration(widget.token)));
              },
            ),
            ListTile(
                leading: const Icon(Icons.add_moderator_outlined),
                title: const Text("Admin Registration"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AdminRegistration(widget.token)));
                }),
            ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text("Goto Dashboard"),
                onTap: () {
                  Navigator.pop(context);
                }),
            ListTile(
                leading: const Icon(Icons.login_outlined),
                title: const Text("Logout"),
                onTap: () {
                  setState(() {
                    widget.token = '';
                  });
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Material(
                            type: MaterialType.transparency,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black54),
                              padding: const EdgeInsets.all(15),
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  Container(
                                      alignment: Alignment.center,
                                      color: Colors.red,
                                      height: 60,
                                      width: MediaQuery.of(context).size.width,
                                      child: const Text('Logout Confirmation',
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold))),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Your Token Will Reset. Please Confirm The Process',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 40),
                                  SizedBox(
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        MaterialButton(
                                            onPressed: () {
                                              setState(() {
                                                confirmation = true;
                                              });

                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AdminLogin()));
                                            },
                                            child: const Icon(
                                                Icons.check_circle_outline,
                                                size: 50,
                                                color: Colors.red)),
                                        MaterialButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Icon(
                                                Icons.cancel_outlined,
                                                size: 50,
                                                color: Colors.red))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ));
                      });
                })
          ],
        ));
  }
}
