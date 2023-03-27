import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/pages/auth/login_page.dart';
import 'package:chatapp/pages/profile_page.dart';
import 'package:chatapp/pages/search_page.dart';
import 'package:chatapp/service/auth_service.dart';
import 'package:chatapp/service/database_service.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";
  String userEmail = "";
  AuthService authService = AuthService();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";



  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunction.getUserEmailFromSF().then((value) {
      setState(() {
        userEmail = value!;
      });
    });
    await HelperFunction.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });

    // Getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserGroups().then((snapshot){
      setState(() {
        groups = snapshot;
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, const SearchPage());
              },
              icon: const Icon(Icons.search))
        ],
        centerTitle: true,
        elevation: 2,
        title: const Text(
          "Groups",
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
            Text(userName.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey[650],
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 3),
            Text(userEmail.toLowerCase(),
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
                Navigator.pop(context);
              },
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
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
                nextScreenReplace(context, ProfilePage(
                  userEmail: userEmail,
                  userName: userName,
                ));
              },
              selectedColor: Theme.of(context).primaryColor,
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
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          popUpDialog(context);
        },
        elevation: 2,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, size: 30, color: Colors.white,),
      ),
    );
  }

  popUpDialog(BuildContext context){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context){
         return AlertDialog(
           title: const Text(
             "Create a Group",
             textAlign: TextAlign.left,
           ),
           content: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               _isLoading == true ? Center(
                 child: CircularProgressIndicator(
                   color: Theme.of(context).primaryColor,
                 ),
               )
             : TextField(
                 onChanged: (val){
                   setState(() {
                     groupName = val;
                   });
                 },
                 style: const TextStyle(color: Colors.black),
                 decoration: InputDecoration(
                   enabledBorder: OutlineInputBorder(
                     borderSide: BorderSide(color: Theme.of(context).primaryColor),
                     borderRadius: BorderRadius.circular(20),
                   ),
                   focusedBorder: OutlineInputBorder(
                       borderSide: BorderSide(color: Theme.of(context).primaryColor),
                       borderRadius: BorderRadius.circular(20),
                   ),
                   errorBorder: OutlineInputBorder(
                       borderSide: const BorderSide(color: Colors.red),
                       borderRadius: BorderRadius.circular(20),
                   )
                 ),
               ),
             ],
           ),
           actions: [
             TextButton(onPressed: (){
                Navigator.pop(context);
             }, child: Text(
               "Cancel",
               style: TextStyle(
                   color: Colors.grey[600],
                   fontSize: 16
               ),
             )),
             TextButton(onPressed: (){

             }, child: Text(
               "OK",
               style: TextStyle(
                   color: Theme.of(context).primaryColor,
                   fontSize: 16
               ),
             ))
           ],
         );
    });
  }

  groupList(){
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot){
          // make some checks
        if(snapshot.hasData){
          if(snapshot.data['groups'] != null){
            if(snapshot.data['groups'].length != 0){
              return Text("Helloooo....");
            }else{
              return noGroupWidget();
            }
          }else{
            return noGroupWidget();
          }
        }
        else{
          return Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor));
        }
      },
    );
  }

  noGroupWidget(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              popUpDialog(context);
            },
            child: Icon(
              Icons.add_circle, 
              color: Colors.grey[700], 
              size: 75,
            ),
          ),
          const SizedBox(height: 20,),
          const Text("You've not joined any groups, tap on the add icon to create "
              "group or also search from top search button.", textAlign: TextAlign.center,)
        ],
      ),
    );
  }
}
