import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OurGradientButton extends StatelessWidget {
  final Function function;
  final String title;
  const OurGradientButton({
    Key? key,
    required this.function,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        function();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setSp(
            20,
          ),
          vertical: ScreenUtil().setSp(
            10,
          ),
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
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(25),
                fontWeight: FontWeight.w800,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// () async {
//         setState(() {
//           authenticate = true;
//           print(authenticate);
//         });
//         if (_formKey.currentState!.validate()) {
//           await Auth().loginAccount(emailValue, passwordValue, context);
//         }
//         setState(() {
//           authenticate = false;
//           print(authenticate);
//         });
//       },