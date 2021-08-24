import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:todo/services/authentication/authentication.dart';

import 'package:todo/utils/styles.dart';
import 'package:todo/widgets/our_gradient_button.dart';
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
  String name = "";
  final FocusNode emailNode = FocusNode();
  final FocusNode nameNode = FocusNode();
  final FocusNode passwordNode = FocusNode();
  final FocusNode confirmNode = FocusNode();
  TextEditingController _password_Controller = TextEditingController();
  TextEditingController _password_confirm_Controller = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool see = true;
  bool see_confirm = true;
  bool authenticate = false;

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
                Text("Create account", style: MidBoldText),

                OurSizedHeight(),
                CustomTextField(
                  number: 0,
                  start: emailNode,
                  end: nameNode,
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
                CustomTextField(
                  number: 0,
                  start: nameNode,
                  end: passwordNode,
                  type: TextInputType.name,
                  title: "Full name",
                  icon: Icons.person,
                  validator: (value) {
                    if (value.isNotEmpty) {
                      return null;
                    } else {
                      return "Can't be empty";
                    }
                  },
                  onchange: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                  controller: nameController,
                ),
                OurSizedHeight(),
                PasswordForm(
                  number: 0,
                  start: passwordNode,
                  end: confirmNode,
                  onchange: (value) {
                    setState(() {
                      passwordValue = value;
                    });
                  },
                  validator: (value) {
                    if (value.isNotEmpty) {
                      return null;
                    } else {
                      return "Can't be empty";
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
                  start: confirmNode,
                  number: 1,
                  // start: confirmNode,
                  // end: confirmNode,
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
                    OurGradientButton(
                        function: () async {
                          setState(() {
                            authenticate = true;
                            print(authenticate);
                          });
                          if (_formKey.currentState!.validate()) {
                            print(emailValue);
                            print(passwordValue);
                            print(_password_confirm_Controller.text);
                            await Auth().createAccount(
                              emailValue,
                              passwordValue,
                              name,
                              context,
                            );
                          }
                          setState(() {
                            authenticate = false;
                            print(authenticate);
                          });
                        },
                        title: "Sign Up")
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
