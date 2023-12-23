import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import 'package:firebase_database/firebase_database.dart';
import 'package:ipadel3/user.dart';



class AuthenticationService {

  Future signUpWithEmail({
    required User user,
    required String password,
    required String fullName,
    required String role,
  }) async {
    try {
      var authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email!,
        password: password,
      );
      // TODO: Create firestore user here and keep it locally.
      return authResult.user != null;
    } catch (e) {
      return e;
    }
  }
}
class FirestoreService {
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection("users");
  Future createUser(User user) async {
    try {
      await _usersCollectionReference.document(Userauth.id).setData(Userauth.toJson());
    } catch (e) {
      return e;
    }
  }
}