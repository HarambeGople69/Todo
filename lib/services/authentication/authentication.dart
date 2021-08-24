import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo/services/firestore/firestore.dart';

class Auth {
  createAccount(
      String email, String password, String name, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then(
            (value) => Firestore().addUser(
              FirebaseAuth.instance.currentUser!.uid,
              email,
              name,
            ),
          );
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "User registered successfully",
            style: TextStyle(fontSize: ScreenUtil().setSp(15)),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            e.message!,
            style: TextStyle(fontSize: ScreenUtil().setSp(15)),
          ),
        ),
      );
    }
  }

  loginAccount(String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text("User logged in successfully"),
          ),
        );
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.message!),
        ),
      );
    }
  }

  logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut().then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text("User logged out successfully"),
          ),
        );
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.message!),
        ),
      );
    }
  }
}
