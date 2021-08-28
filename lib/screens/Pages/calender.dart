import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorlizer/colorlizer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calender extends StatefulWidget {
  const Calender({Key? key}) : super(key: key);

  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  bool loaded = false;
  MeetingDataSource? events;
  final databaseReference = FirebaseFirestore.instance;
  ColorLizer colorlizer = ColorLizer();

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
              colorlizer.getRandomColors()!.withOpacity(0.5),
              false,
            ))
        .toList();
    setState(() {
      events = MeetingDataSource(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ModalProgressHUD(
      inAsyncCall: loaded,
      child: SafeArea(
        child: SfCalendar(
          headerHeight: ScreenUtil().setSp(
            70,
          ),
          todayTextStyle: TextStyle(
            fontSize: ScreenUtil().setSp(15),
          ),
          headerStyle: CalendarHeaderStyle(
            textStyle: TextStyle(
              fontSize: ScreenUtil().setSp(
                25,
              ),
            ),
          ),
          view: CalendarView.month,
          monthViewSettings: MonthViewSettings(showAgenda: true),
          dataSource: events,
        ),
      ),
    ));
  }
}

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
