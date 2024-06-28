import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import 'package:firebase_database/firebase_database.dart';
import 'package:ipadel3/userauth.dart';

// class AuthService {
//   Future<void> register(
//       String email,
//       String password,
//       String fname,
//       String lname,
//       String dob,
//       String number,
//       String country,
//       String gender,
//       String username) async {
//     try {
//       UserCredential userCredential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: password);
//       CollectionReference _usersCollectionReference =
//           FirebaseFirestore.instance.collection("users");

//       String? uid = userCredential.user?.uid;

//       await _usersCollectionReference.doc(uid).set({
//         'firstName': fname,
//         'lastName': lname,
//         'email': email,
//         'dob': dob,
//         'number': number,
//         'nationality': country,
//         'gender': gender,
//         'uid': uid,
//         'username': username
//       });
//       userCredential.user?.sendEmailVerification();
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'weak-password') {
//         print('The password provided is too weak.');
//       } else if (e.code == 'email-already-in-use') {
//         print('The account already exists for that email.');
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
class AuthService {
  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<String?> register(
      String email,
      String password,
      String fname,
      String lname,
      // String dob,
      // String number,
      // String country,
      // String gender,
      String username) async {
    try {
      // Check if the username is available
      bool UsernameAvailable = await isUsernameAvailable(username);

      if (!UsernameAvailable) {
        print('Username $username is already taken.');
        return "Username not available"; // Exit the method if username is not available
      }

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      CollectionReference _usersCollectionReference =
          FirebaseFirestore.instance.collection("users");

      String? uid = userCredential.user?.uid;

      await _usersCollectionReference.doc(uid).set({
        'firstName': fname,
        'lastName': lname,
        'email': email,
        // 'dob': dob,
        // 'number': number,
        // 'nationality': country,
        // 'gender': gender,
        'uid': uid,
        'username': username
      });
      userCredential.user?.sendEmailVerification();

      // Add the username to the used usernames table
      await addUsernameToUsed(userCredential.user?.uid ?? '', username);
      return null; // Indicating success
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

//   Future<dynamic> login(String email, String password) async {
//     try {
//       final FirebaseAuth auth = FirebaseAuth.instance;
//       CollectionReference _usersCollectionReference =
//           FirebaseFirestore.instance.collection("users");
//       UserCredential? result = await auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       //final User? user = auth.currentUser;
//       //String uid = user!.uid;
//       DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
//           await _usersCollectionReference.doc(result.user?.uid ?? '').get()
//               as DocumentSnapshot<Map<String, dynamic>>;
//       Userauth? user;
//       if (documentSnapshot.exists) {
//         user = Userauth.fromJson(documentSnapshot.data() ?? {});
//       }
//       return result.user;
//     } on FirebaseAuthException catch (exception, s) {
//       debugPrint('$exception$s');
//       switch ((exception).code) {
//         case 'invalid-email':
//           return 'Email address is malformed.';
//         case 'wrong-password':
//           return 'Wrong password.';
//         case 'user-not-found':
//           return 'No user corresponding to the given email address.';
//         case 'user-disabled':
//           return 'This user has been disabled.';
//         case 'too-many-requests':
//           return 'Too many attempts to sign in as this user.';
//       }
//       return 'Unexpected firebase error, Please try again.';
//     } catch (e, s) {
//       debugPrint('$e$s');
//       return 'Login failed, Please try again.';
//     }
//   }
// }
  Future<User?> login(String email, String password) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      CollectionReference _usersCollectionReference =
          FirebaseFirestore.instance.collection("users");
      UserCredential result = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _usersCollectionReference.doc(result.user?.uid ?? '').get()
              as DocumentSnapshot<Map<String, dynamic>>;
      Userauth? user;
      if (documentSnapshot.exists) {
        user = Userauth.fromJson(documentSnapshot.data() ?? {});
      }
      return result.user;
    } catch (e, s) {
      debugPrint('$e$s');
      return null; // Return null in case of error
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<bool> isUsernameAvailable(String username) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection("used_usernames")
              .where('username', isEqualTo: username)
              .get();

      return querySnapshot.docs.isEmpty;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> addUsernameToUsed(String uid, String username) async {
    try {
      await FirebaseFirestore.instance
          .collection("used_usernames")
          .doc(uid)
          .set({'username': username});
    } catch (e) {
      print(e);
    }
  }
}
