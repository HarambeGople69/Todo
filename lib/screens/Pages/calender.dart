import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorlizer/colorlizer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calender extends StatefulWidget {
  const Calender({Key? key}) : super(key: key);

  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  List<Color> _colorCollection = <Color>[];
  bool loaded = false;
  MeetingDataSource? events;
  final databaseReference = FirebaseFirestore.instance;

  @override
  void initState() {
    setState(() {
      print("true");
      loaded = true;
    });
    getDataFromFireStore().then((results) {
      SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });
    setState(() {
      print("false");
      loaded = false;
    });

    super.initState();
  }

  Future<void> getDataFromFireStore() async {
    var snapShotsValue = await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Tasks")
        .get();

    List<Meeting> list = snapShotsValue.docs
        .map((e) => Meeting(
              e.data()['title'],
              e.data()["fromDate"].toDate(),
              e.data()["todate"].toDate(),
              Colors.indigoAccent,
              false,
            ))
        .toList();
    setState(() {
      events = MeetingDataSource(list);
    });
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getDataFromFireStore().then((result) {
  //     SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
  //       setState(() {});
  //     });
  //   });
  // }

  // Future<void> getDataFromFireStore() async {
  //   var snapShotsValue = await FirebaseFirestore.instance
  //       .collection("Users")
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .collection("Tasks")
  //       .get();

  //   List<Meeting> lists = snapShotsValue.docs
  //       .map((e) => Meeting(
  //           e.data()["title"],
  //           e.data()["fromDate"],
  //           e.data()["todate"],
  //           colorlizer.getRandomColors()!.withOpacity(0.7),
  //           false))
  //       .toList();
  //   setState(() {
  //     events = MeetingDataSource(lists);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ModalProgressHUD(
      inAsyncCall: loaded,
      child: SafeArea(
        child: SfCalendar(
          view: CalendarView.month,
          monthViewSettings: MonthViewSettings(showAgenda: true),
          dataSource: events,
        ),
      ),
    ));
  }
}

// Future<List<Meeting>> _getDataSource()  {
//   // final DateTime today = DateTime.now();
//   // final DateTime startTime =
//   //     DateTime(today.year, today.month, today.day, 9, 0, 0);
//   // final DateTime endTime = startTime.add(const Duration(hours: 2));
//   var snapShotsValue = await FirebaseFirestore.instance
//       .collection("Users")
//       .doc(FirebaseAuth.instance.currentUser!.uid)
//       .collection("Tasks")
//       .get();

//   List<Meeting> meetings = snapShotsValue.docs
//       .map(
//         (e) => Meeting(
//           e.data()["title"],
//           e.data()["fromData"],
//           e.data()["todate"],
//           Colors.green,
//           false,
//         ),
//       )
//       .toList();

//   // meetings.add(Meeting(
//   //     'Conference', startTime, endTime, const Color(0xFF0F8644), false));
//   return meetings;
// }

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
