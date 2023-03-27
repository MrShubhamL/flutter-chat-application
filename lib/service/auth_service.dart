import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Login
  Future loginWithEmailAndPassword(String email, String password) async {
    try{
      User user = (
          await firebaseAuth.signInWithEmailAndPassword(email: email, password: password))
          .user!;
      if(user != null){
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Register
  Future regsterUserWithEmailAndPassword(String fullName, String email, String password) async {
    try{
      User user = (
          await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password))
          .user!;
      if(user != null){
        // call our database service to update the user data.
        await DatabaseService(uid: user.uid).saveUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Signout

  Future signOut() async {
    try{
      await HelperFunction.saveUserLoggedInStatus(false);
      await HelperFunction.saveUserNameSf("");
      await HelperFunction.saveUserEmailSf("");
      await firebaseAuth.signOut();
    } catch(e){
      return null;
    }
  }
}