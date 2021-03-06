import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String title;
  final String description;
  final String timeAdded;
  final Timestamp timestamp;
  final String uid;
  final Timestamp fromDate;
  final Timestamp todate;
  final int taskid;

  TaskModel({
    required this.title,
    required this.description,
    required this.timeAdded,
    required this.timestamp,
    required this.uid,
    required this.fromDate,
    required this.todate,
    required this.taskid,
  });

  factory TaskModel.fromJson(DocumentSnapshot querySnapshot) {
    return TaskModel(
      title: querySnapshot["title"],
      description: querySnapshot["description"],
      timeAdded: querySnapshot["timeAdded"],
      timestamp: querySnapshot["timestamp"],
      uid: querySnapshot.id,
      fromDate: querySnapshot["fromDate"],
      todate: querySnapshot["todate"],
      taskid: querySnapshot["taskid"],
    );
  }
}
