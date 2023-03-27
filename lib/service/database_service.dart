import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // reference for our collections
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection = FirebaseFirestore.instance.collection("groups");


  Future saveUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email" : email,
      "groups": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  // Getting User Data
  Future getUserData(String email) async {
    QuerySnapshot snapshot = await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // Get user groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  // Crating a Group



}
