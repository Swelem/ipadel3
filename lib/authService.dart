import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import 'package:firebase_database/firebase_database.dart';
import 'package:ipadel3/userauth.dart';

class AuthService {
  Future<void> register(
      String email,
      String password,
      String fname,
      String lname,
      String dob,
      String number,
      String country,
      String gender) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      CollectionReference _usersCollectionReference =
          FirebaseFirestore.instance.collection("users");

      String? uid = userCredential.user?.uid;

      await _usersCollectionReference.doc(uid).set({
        'firstName': fname,
        'lastName': lname,
        'email': email,
        'dob': dob,
        'number': number,
        'nationality': country,
        'gender': gender,
        'uid': uid
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> login(String email, String password) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      CollectionReference _usersCollectionReference =
          FirebaseFirestore.instance.collection("users");
      UserCredential result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      //final User? user = auth.currentUser;
      //String uid = user!.uid;
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _usersCollectionReference.doc(result.user?.uid ?? '').get()
              as DocumentSnapshot<Map<String, dynamic>>;
      Userauth? user;
      if (documentSnapshot.exists) {
        user = Userauth.fromJson(documentSnapshot.data() ?? {});
      }
      return user;
    } on FirebaseAuthException catch (exception, s) {
      debugPrint('$exception$s');
      switch ((exception).code) {
        case 'invalid-email':
          return 'Email address is malformed.';
        case 'wrong-password':
          return 'Wrong password.';
        case 'user-not-found':
          return 'No user corresponding to the given email address.';
        case 'user-disabled':
          return 'This user has been disabled.';
        case 'too-many-requests':
          return 'Too many attempts to sign in as this user.';
      }
      return 'Unexpected firebase error, Please try again.';
    } catch (e, s) {
      debugPrint('$e$s');
      return 'Login failed, Please try again.';
    }
  }
}
