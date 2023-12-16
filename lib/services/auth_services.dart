import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:thread_clone/models/user_model.dart';
import 'package:thread_clone/services/storage_services.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<UserModel> getCurrentUser() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return UserModel.fromJSON(snapshot.data() as Map<String, dynamic>);
  }

  //register new user
  Future<String> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List profilePic,
  }) async {
    String res = 'Something went wrong';
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty &&
          profilePic.isNotEmpty) {
        //create new user
        final UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        print("### userCredential =$userCredential");
        //upload Profile pic
        String? profilePicUrl = await StorageServices().uploadImage(
            folderName: 'ProfileImages', isPost: false, file: profilePic);
        print("### profilePicUrl =$profilePicUrl");
        UserModel userModel = UserModel(
          uid: _auth.currentUser!.uid,
          bio: bio,
          email: email,
          profilePic: profilePicUrl,
          followers: [],
          following: [],
          username: username,
        );
        print("### userCredential.user =${userCredential.user}");
        if (userCredential.user != null) {
          print("### 123467 ");
          await _firestore
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .set(userModel.toJson());
          res = 'success';
          print("### res =$res");
        }
      } else {}
    } on FirebaseAuthException catch (e) {
      print("### FirebaseAuthException =$e");
      if (e.code == 'invalid-email') {
        res = 'invalid email';
      } else if (e.code == 'weak-password') {
        res = 'weak password';
      } else if (e.code == 'email-already-in-use') {
        res = 'Email already in use';
      }
      return res;
    } catch (e) {
      print("### FirebaseAuthException 1 =$e");
      res = e.toString();
      return res;
    }
    return res;
  }

  //login user
  Future<String> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    String res = "An error occured";

    try {
      //if the inputs are not empty
      if (email.isNotEmpty && password.isNotEmpty) {
        //login the user with email and password
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        res = "success";
      } else {
        res = "Please check email and password";
      }
    }

    //catch the errors extra error handling
    on FirebaseAuthException catch (error) {
      if (error.code == "invalid-email") {
        res = "Invalid email";
      } else if (error.code == "weak-password") {
        res = "Weak password";
      } else if (error.code == "email-already-in-use") {
        res = "Email already in use";
      }
    } catch (error) {
      res = error.toString();
    }

    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
