import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:todo/firestore/firestore.dart';
import 'package:todo/utils/styles.dart';
import 'package:todo/widgets/our_gradient_button.dart';
import 'package:todo/widgets/our_sized_box.dart';
import 'package:todo/widgets/our_textfield.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final FocusNode titleNode = FocusNode();
  final FocusNode descNode = FocusNode();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
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
    });
  }

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
                    Center(
                      child: SizedBox(
                        width: double.infinity * 0.75,
                        child: OurGradientButton(
                          function: () async {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                storing = true;
                              });
                              print("Valid");
                              await Firestore()
                                  .addTask(uid, title, description, context);
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
