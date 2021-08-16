import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OurGoogleButton extends StatelessWidget {
  final Function function;
  const OurGoogleButton({
    Key? key,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenUtil().setSp(
        250,
      ),
      height: ScreenUtil().setSp(
        50,
      ),
      child: ElevatedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  ScreenUtil().setSp(30),
                ),
              ),
            ),
            padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(
                horizontal: ScreenUtil().setSp(20),
              ),
            )),
        onPressed: () {
          function();
        },
        child: Text(
          " Connect with google",
          style: TextStyle(
            fontSize: ScreenUtil().setSp(20),
          ),
        ),
      ),
    );
  }
}
