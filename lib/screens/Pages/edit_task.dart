import 'package:colorlizer/colorlizer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:todo/models/taskmodel.dart';
import 'package:todo/services/firestore/firestore.dart';
import 'package:todo/utils/styles.dart';
import 'package:todo/utils/utils.dart';
import 'package:todo/widgets/our_gradient_button.dart';
import 'package:todo/widgets/our_sized_box.dart';
import 'package:todo/widgets/our_textfield.dart';

class EditPage extends StatefulWidget {
  final TaskModel taskmodel;
  const EditPage({
    Key? key,
    required this.taskmodel,
  }) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final FocusNode titleNode = FocusNode();
  final FocusNode descNode = FocusNode();
  final FocusNode fromNode = FocusNode();
  final FocusNode toNode = FocusNode();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController fromEventController = TextEditingController();
  TextEditingController toEventController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String title = "";
  String description = "";
  String uid = "";
  bool storing = false;
  ColorLizer colorlizer = ColorLizer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateAll();
  }

  updateAll(){
    print("Update vayo??");
    setState(() {
      print(widget.taskmodel.description);
      print(widget.taskmodel.title);
      print(widget.taskmodel.fromDate);
      print(widget.taskmodel.timeAdded);
      print(widget.taskmodel.timestamp);
      title = widget.taskmodel.title;
      description = widget.taskmodel.description;
      titleController.text= widget.taskmodel.title;
      descriptionController.text = widget.taskmodel.description;
      uid = FirebaseAuth.instance.currentUser!.uid;
      fromdate =widget.taskmodel.fromDate.toDate();
      fromEventController.text = Utils().customDate( widget.taskmodel.fromDate.toDate());
      todate =widget.taskmodel.todate.toDate(); 
      toEventController.text = Utils().customDate( widget.taskmodel.todate.toDate());
    });
  }

  late DateTime fromdate;
  late DateTime todate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit task"),
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
                      initialValue: titleController.text,
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
                      initialValue: descriptionController.text,
                      number: 1,
                      start: descNode,
                      end: toNode,
                      onchange: (value) {
                        setState(() {
                          description = value;
                        });
                      },
                      length: 5,
                      controller: descriptionController,
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
                        // DateTime initialTime = DateTime.now();
                        DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: fromdate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2022),
                        );
                        if (date == null) {
                          return null;
                        }
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                              hour: fromdate.hour,
                              minute: fromdate.minute),
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
                        // DateTime initialTime = DateTime.now();
                        DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: todate,
                          firstDate: fromdate
                          lastDate: DateTime(2050),
                        );
                        if (date == null) {
                          return null;
                        }
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                              hour: todate.hour,
                              minute: todate.minute),
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
                    
                    OurSizedHeight(),
                    Center(
                      child: SizedBox(
                        width: double.infinity * 0.75,
                        child: OurGradientButton(
                          // function: () {
                          
                          // },
                          function: () async {
                            if (formKey.currentState!.validate()) {
                                final diff = todate.difference(fromdate);
                            if (diff.isNegative) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                
          SnackBar(
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
            content: Text(
              "Please check event date",
              style: TextStyle(fontSize: ScreenUtil().setSp(15)),
            ),
          ),
        );
                            } else {
                               setState(() {
                                storing = true;
                              });
                              print("Valid");
                              await Firestore().EditTask(uid, widget.taskmodel.uid, title, description, fromdate, todate,widget.taskmodel.taskid, context,);
                              storing = false;
                              Navigator.pop(context);
                            }
                             
                            } else {
                              print("Invalid");
                            }
                          },
                          title: "Update Task",
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
