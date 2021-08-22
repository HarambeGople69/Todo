import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorlizer/colorlizer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo/firestore/firestore.dart';
import 'package:todo/models/taskmodel.dart';
import 'package:todo/screens/Pages/add_task.dart';
import 'package:todo/utils/styles.dart';
import 'package:intl/intl.dart';
import 'package:todo/widgets/our_task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String uid = "";
  ColorLizer colorlizer = ColorLizer();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      uid = FirebaseAuth.instance.currentUser!.uid;
    });
  }

  bool inprocess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setSp(20),
            vertical: ScreenUtil().setSp(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: ScreenUtil().setSp(50),
                // width: 250.0,
                child: DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                  child: AnimatedTextKit(
                    totalRepeatCount: 1000,
                    animatedTexts: [
                      FadeAnimatedText(
                        'Stop procrastinating ',
                        textStyle: MidBoldText.copyWith(
                          color: colorlizer.getRandomColors()!.withOpacity(1),
                        ),
                      ),
                      FadeAnimatedText(
                        'Get started',
                        textStyle: MidBoldText.copyWith(
                          color: colorlizer.getRandomColors()!.withOpacity(1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Text("data"),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Users")
                        .doc(uid)
                        .collection("Tasks")
                        .orderBy("timestamp", descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.length > 0) {
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                TaskModel taskModel = TaskModel.fromJson(
                                    snapshot.data!.docs[index]);

                                return OurListtile(
                                  onedit: () {
                                    print(taskModel.uid);
                                  },
                                  ondelete: () async {
                                    await Firestore().deleteTask(
                                      uid,
                                      taskModel.uid,
                                      context,
                                    );
                                  },
                                  uid: taskModel.uid,
                                  title: taskModel.title,
                                  description: taskModel.description,
                                  time: taskModel.timeAdded,
                                );
                              });
                        }
                      }
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "images/task.png",
                              height: ScreenUtil().setSp(200),
                              width: ScreenUtil().setSp(200),
                              fit: BoxFit.cover,
                            ),
                            Text("No task", style: SmallBoldText)
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) {
                    return AddTask();
                  }));
        },
      ),
    );
  }
}
