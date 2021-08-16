import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:todo/authentication/authentication.dart';

import 'package:todo/widgets/our_sized_box.dart';
import 'package:todo/widgets/our_textfield.dart';
import 'package:todo/widgets/password_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _email_Controller = TextEditingController();
  String emailValue = "";
  String passwordValue = "";
  String confirmpasswordValue = "";
  TextEditingController _password_Controller = TextEditingController();
  TextEditingController _password_confirm_Controller = TextEditingController();
  bool see = true;
  bool see_confirm = true;
  bool authenticate = false;
  // final TapGestureRecognizer OnTap = TapGestureRecognizer()
  //   ..onTap = () {
  //     print("Its tapped");
  //   };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ModalProgressHUD(
      inAsyncCall: authenticate,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setSp(20),
          vertical: ScreenUtil().setSp(10),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: ScreenUtil().setSp(105),
                ),
                Text(
                  "Create account",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(30),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                OurSizedHeight(),
                // CustomTextField(
                //   type: TextInputType.name,
                //   title: "Full name",
                //   icon: Icons.person,
                //   validator: (value) {
                //     if (value.isNotEmpty) {
                //       return null;
                //     } else {s
                //       return "Cannot be empty";
                //     }
                //   },
                //   controller: _email_Controller,
                // ),

                OurSizedHeight(),
                CustomTextField(
                  type: TextInputType.emailAddress,
                  title: "Email",
                  icon: Icons.email,
                  validator: (value) {
                    if (value.isNotEmpty && value.contains("@")) {
                      return null;
                    } else {
                      return "Invalid email";
                    }
                  },
                  onchange: (value) {
                    setState(() {
                      emailValue = value;
                    });
                  },
                  controller: _email_Controller,
                ),
                OurSizedHeight(),
                PasswordForm(
                  onchange: (value) {
                    setState(() {
                      passwordValue = value;
                    });
                  },
                  validator: (value) {
                    if (value.isNotEmpty) {
                      return null;
                    } else {
                      return "Cannot be empty";
                    }
                  },
                  title: "Password",
                  controller: _password_Controller,
                  see: see,
                  changesee: () {
                    setState(() {
                      see = !see;
                    });
                  },
                ),
                OurSizedHeight(),
                PasswordForm(
                  onchange: (value) {
                    setState(() {
                      confirmpasswordValue = value;
                    });
                  },
                  validator: (value) {
                    if (_password_Controller.text ==
                        _password_confirm_Controller.text) {
                      return null;
                    } else {
                      return "Password didn't match";
                    }
                  },
                  title: "Confirm password",
                  controller: _password_confirm_Controller,
                  see: see_confirm,
                  changesee: () {
                    setState(() {
                      see_confirm = !see_confirm;
                    });
                  },
                ),
                OurSizedHeight(),
                Row(
                  children: [
                    Spacer(),
                    InkWell(
                      onTap: () async {
                        setState(() {
                          authenticate = true;
                          print(authenticate);
                        });
                        if (_formKey.currentState!.validate()) {
                          print(emailValue);
                          print(passwordValue);
                          print(_password_confirm_Controller.text);
                          await Auth().createAccount(
                              emailValue, passwordValue, context);
                        }
                        setState(() {
                          authenticate = false;
                          print(authenticate);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(
                          15,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            30,
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Color(
                                0xfff7c457,
                              ),
                              Color(
                                0xfffea23b,
                              ),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "SIGN UP ",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setSp(60),
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(20),
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            )
                            // style: paratext,
                            ),
                        TextSpan(
                          text: 'Sign in',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
                            },
                          style: TextStyle(
                            color: Color(
                              0xfffea23b,
                            ),
                            fontWeight: FontWeight.w600,
                            fontSize: ScreenUtil().setSp(20),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 30,
                // ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
