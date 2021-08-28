import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorlizer/colorlizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/services/notification/notification.dart';
import 'dart:math';

class Firestore {
  ColorLizer colorlizer = ColorLizer();
  Random rng = new Random();
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
        "imageUrl": "",
      }).then((value) => print("Done =========================="));
    } catch (e) {
      print(e);
    }
  }

  addTask(String uid, String title, String description, DateTime fromDate,
      DateTime todate, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .collection("Tasks")
          .add({
        "taskid": rng.nextInt(1000000000),
        "title": title,
        "description": description,
        "timeAdded": DateFormat('yyy-MM--dd').format(
          DateTime.now(),
        ),
        "fromDate": fromDate,
        "todate": todate,
        "timestamp": DateTime.now(),
      }).then((value) {
        // OurNotification().displayNotification(title, fromDate, description);
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
            "$e",
            style: TextStyle(fontSize: ScreenUtil().setSp(15)),
          ),
        ),
      );
    }
  }

  EditTask(String uid, String docUID, String title, String description,
      DateTime fromDate, DateTime todate, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .collection("Tasks")
          .doc(docUID)
          .update({
        "title": title,
        "description": description,
        "timeAdded": DateFormat('yyy-MM--dd').format(
          DateTime.now(),
        ),
        "fromDate": fromDate,
        "todate": todate,
        "timestamp": DateTime.now(),
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: colorlizer.getRandomColors()!.withOpacity(0.5),
            content: Text(
              "Task Updated",
              style: TextStyle(fontSize: ScreenUtil().setSp(15)),
            ),
          ),
        );
      });
      //     .add({
      //   "title": title,
      //   "description": description,
      //   "timeAdded": DateFormat('yyy-MM--dd').format(
      //     DateTime.now(),
      //   ),
      //   "fromDate":fromDate,
      //   "todate":todate,
      //   "timestamp": DateTime.now(),
      // }).then((value) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       backgroundColor: colorlizer.getRandomColors()!.withOpacity(0.5),
      //       content: Text(
      //         "Task added",
      //         style: TextStyle(fontSize: ScreenUtil().setSp(15)),
      //       ),
      //     ),
      //   );
      // });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "$e",
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
