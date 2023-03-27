import 'package:chatapp/pages/home_page.dart';
import 'package:chatapp/service/auth_service.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart';
import 'auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  String userName;
  String userEmail;
  ProfilePage({Key? key, required this.userName, required this.userEmail}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
              fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),

      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: [
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 12),
            Text(widget.userName.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey[650],
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 3),
            Text(widget.userEmail.toLowerCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 30),
            const Divider(height: 2),
            ListTile(
              onTap: () {
                nextScreen(context, const HomePage());
              },
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              leading: const Icon(Icons.group),
              title: const Text(
                "Groups",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
              },
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              leading: const Icon(Icons.group),
              title: const Text(
                "Profile",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Logout"),
                        content:
                        const Text("Are your sure you want to logout?"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 16),
                              )
                          ),
                          TextButton(
                              onPressed: () async {
                                await authService.signOut();
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginPage()),
                                        (route) => false);
                              },
                              child: Text(
                                "OK",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16),
                              )
                          ),
                        ],
                      );
                    });
              },
              selectedColor: Theme.of(context).primaryColor,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.account_circle,
              size: 200,
              color: Colors.grey[700],
            ),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.person, color: Colors.grey[700], size: 30,),
                const SizedBox(width: 10),
                Text(widget.userName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold), textAlign: TextAlign.start,),
              ],
            ),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.email, color: Colors.grey[700], size: 30,),
                const SizedBox(width: 10),
                Text(widget.userEmail, style: const TextStyle(fontSize: 17),),
              ],
            )

          ],
        ),
      ),
    );
  }
}
