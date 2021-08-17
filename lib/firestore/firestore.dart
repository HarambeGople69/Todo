import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorlizer/colorlizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Firestore {
  ColorLizer colorlizer = ColorLizer();

  addUser(String uid, String email, String name) async {
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .collection("User Detail")
          .add({
        "email": email,
        "name": name,
        "AddedOn": DateFormat('yyy-MM--dd').format(
          DateTime.now(),
        ),
      }).then((value) => print("Done =========================="));
    } catch (e) {
      print(e);
    }
  }

  addTask(String uid, String title, String description,
      BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .collection("Tasks")
          .add({
        "title": title,
        "description": description,
        "timeAdded": DateFormat('yyy-MM--dd').format(
          DateTime.now(),
        ),
        "timestamp": DateTime.now(),
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: colorlizer.getRandomColors()!.withOpacity(0.5),
            content: Text(
              "Task added",
              style: TextStyle(fontSize: ScreenUtil().setSp(15)),
            ),
          ),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Error occured while adding task",
            style: TextStyle(fontSize: ScreenUtil().setSp(15)),
          ),
        ),
      );
    }
  }

  deleteTask(
    String uid,
    String taskUid,
    BuildContext context,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .collection("Tasks")
          .doc(taskUid)
          .delete()
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Task Deleted",
              style: TextStyle(fontSize: ScreenUtil().setSp(15)),
            ),
          ),
        );
      });
    } catch (e) {
      print(e);
    }
  }
}
