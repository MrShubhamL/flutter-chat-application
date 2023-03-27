import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/pages/auth/registration_page.dart';
import 'package:chatapp/service/auth_service.dart';
import 'package:chatapp/service/database_service.dart';
import 'package:chatapp/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../home_page.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPage();
  }
}

class _LoginPage extends State<LoginPage>{
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor)) : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 80),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:  <Widget> [
                 const Text(
                  "Groupie",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Login now to see what they are talking!",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,),
                ),
                Image.asset("images/login.png"),
                TextFormField(
                  decoration: textInoutDecoration.copyWith(
                    labelText: "Email",
                    prefixIcon: Icon(
                        Icons.email,
                        color: Theme.of(context).primaryColor,
                    )),
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                  // Check The validation...
                  validator: (val){
                    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(val!) ? null : "Please enter a valid email";
                  }
                  ),
                const SizedBox(height: 15),
                TextFormField(
                  obscureText: true,
                  decoration: textInoutDecoration.copyWith(
                      labelText: "Password",
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Theme.of(context).primaryColor,
                      )),
                  validator: (val){
                    if(val!.length<6){
                      return "Password must be at least 6 characters";
                    }
                    else{
                      return null;
                    }
                  },
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: (){
                      login();
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Text.rich(
                  TextSpan(
                    text: "Don't have an account? ",
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    children: <TextSpan> [
                      TextSpan(
                      text: "Register here",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                        recognizer: TapGestureRecognizer()..onTap = (){
                            nextScreen(context, const RegisterPage());
                        }
                      )
                    ]
                  )
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithEmailAndPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
              .getUserData(email);
          // Saving the values in share preferences
          await HelperFunction.saveUserLoggedInStatus(true);
          await HelperFunction.saveUserEmailSf(email);
          await HelperFunction.saveUserNameSf(
            snapshot.docs[0]['fullName']
          );
          nextScreenReplace(context, const HomePage());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

}