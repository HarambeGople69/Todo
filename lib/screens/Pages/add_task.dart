import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:todo/utils/styles.dart';
import 'package:todo/utils/utils.dart';
import 'package:todo/widgets/our_gradient_button.dart';
import 'package:todo/widgets/our_sized_box.dart';
import 'package:todo/widgets/our_textfield.dart';
import 'package:todo/services/firestore/firestore.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final FocusNode titleNode = FocusNode();
  final FocusNode descNode = FocusNode();
  final FocusNode fromNode = FocusNode();
  final FocusNode toNode = FocusNode();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final fromEventController = TextEditingController();
  final toEventController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String title = "";
  String description = "";
  String uid = "";
  bool storing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      uid = FirebaseAuth.instance.currentUser!.uid;
      fromdate = DateTime.now();
      fromEventController.text = Utils().customDate(fromdate);
      todate = DateTime.now().add(
        Duration(
          hours: 2,
        ),
      );
      toEventController.text = Utils().customDate(todate);
    });
  }

  late DateTime fromdate;
  late DateTime todate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add task"),
        ),
        body: ModalProgressHUD(
          inAsyncCall: storing,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setSp(20),
                  vertical: ScreenUtil().setSp(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Title",
                      style: SmallBoldText,
                    ),
                    OurSizedHeight(),
                    CustomTextField(
                      number: 0,
                      start: titleNode,
                      end: descNode,
                      onchange: (value) {
                        setState(() {
                          title = value;
                        });
                      },
                      controller: titleController,
                      validator: (value) {
                        if (value.isNotEmpty) {
                          return null;
                        } else {
                          return "Can't be empty";
                        }
                      },
                      title: "Title",
                      type: TextInputType.name,
                    ),
                    OurSizedHeight(),
                    Text(
                      "Description",
                      style: SmallBoldText,
                    ),
                    OurSizedHeight(),
                    CustomTextField(
                      number: 1,
                      start: descNode,
                      end: toNode,
                      onchange: (value) {
                        setState(() {
                          description = value;
                        });
                      },
                      length: 5,
                      controller: titleController,
                      validator: (value) {
                        if (value.isNotEmpty) {
                          return null;
                        } else {
                          return "Can't be empty";
                        }
                      },
                      title: "Add description",
                      type: TextInputType.name,
                    ),
                    OurSizedHeight(),

                    Text(
                      "From",
                      style: SmallBoldText,
                    ),
                    OurSizedHeight(),

                    TextFormField(
                      focusNode: toNode,
                      controller: fromEventController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        errorStyle: TextStyle(
                          fontSize: ScreenUtil().setSp(
                            15,
                          ),
                        ),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime initialTime = DateTime.now();
                        DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: fromdate,
                          firstDate: DateTime(2021),
                          lastDate: DateTime(2022),
                        );
                        if (date == null) {
                          return null;
                        }
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                              hour: initialTime.hour,
                              minute: initialTime.minute),
                        );
                        if (time == null) {
                          return null;
                        }
                        setState(() {
                          fromdate = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                          fromEventController.text =
                              Utils().customDate(fromdate);
                        });
                      },
                    ),

                    OurSizedHeight(),

                    Text(
                      "To",
                      style: SmallBoldText,
                    ),
                    OurSizedHeight(),
                    TextField(
                      controller: toEventController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        errorStyle: TextStyle(
                          fontSize: ScreenUtil().setSp(
                            15,
                          ),
                        ),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime initialTime = DateTime.now();
                        DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: fromdate,
                          firstDate: fromdate
                          lastDate: DateTime(2022),
                        );
                        if (date == null) {
                          return null;
                        }
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                              hour: initialTime.hour,
                              minute: initialTime.minute),
                        );
                        if (time == null) {
                          return null;
                        }
                        setState(() {
                          todate = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                          toEventController.text = Utils().customDate(todate);
                        });
                      },
                    ),
                    // InkWell(
                    //   onTap: () async {
                    //     showDatePicker(
                    //       context: context,
                    //       initialDate: DateTime.now(),
                    //       firstDate: DateTime(2030),
                    //       lastDate: DateTime(2030),
                    //     );
                    //     // if (pickedDate != null) {
                    //     //   setState(() {
                    //     //     todate = pickedDate;
                    //     //   });
                    //     // } else {}
                    //   },
                    //   child: OurTimeTile(
                    //     Utils().toDate(todate),

                    //     // () async {
                    //     // DateTime? pickedDate = await showDatePicker(
                    //     //   context: context,
                    //     //   initialDate: fromdate,
                    //     //   firstDate: DateTime(2030),
                    //     //   lastDate: DateTime(2030),
                    //     // );
                    //     // if (pickedDate != null) {
                    //     //   setState(() {
                    //     //     todate = pickedDate;
                    //     //   });
                    //     // } else {}
                    //     // },
                    //   ),
                    // ),
                    // OurTimeTile(
                    //   Utils().toTime(todate),
                    //   // () {},
                    // ),

                    OurSizedHeight(),
                    Center(
                      child: SizedBox(
                        width: double.infinity * 0.75,
                        child: OurGradientButton(
                          // function: () {
                          //   print(todate);
                          // },
                          function: () async {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                storing = true;
                              });
                              print("Valid");
                              await Firestore().addTask(
                                uid,
                                title,
                                description,
                                fromdate,
                                todate,
                                context,
                              );
                              storing = false;
                              Navigator.pop(context);
                            } else {
                              print("Invalid");
                            }
                          },
                          title: "Add",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
