import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:todo/authentication/authentication.dart';
import 'package:todo/screens/auth/register_page.dart';

import 'package:todo/widgets/our_sized_box.dart';
import 'package:todo/widgets/our_textfield.dart';
import 'package:todo/widgets/password_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email_Controller = TextEditingController();
  final _password_Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TapGestureRecognizer OnTap = TapGestureRecognizer()
    ..onTap = () {
      print("Its tapped");
    };
  String emailValue = "";
  String passwordValue = "";
  bool authenticate = false;

  bool see = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: authenticate,
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setSp(20),
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Spacer(),
                  SizedBox(
                    height: ScreenUtil().setSp(145),
                  ),
                  Text(
                    "Login",
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(40),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  OurSizedHeight(),
                  Text(
                    "Please sign in to continue",
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(20),
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  OurSizedHeight(),

                  CustomTextField(
                    onchange: (value) {
                      setState(() {
                        emailValue = value;
                      });
                    },
                    type: TextInputType.emailAddress,
                    title: "Email",
                    icon: Icons.email,
                    validator: (value) {
                      if (value.isNotEmpty && value.contains("@")) {
                        return null;
                      } else {
                        return "Enter valid email";
                      }
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
                            await Auth().loginAccount(
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
                                "LOGIN ",
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
                    height: ScreenUtil().setSp(150),
                  ),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(20),
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              )
                              // style: paratext,
                              ),
                          TextSpan(
                            text: 'Sign up',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return SignUp();
                                }));
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
                  OurSizedHeight(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
