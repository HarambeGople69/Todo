import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OurButton extends StatelessWidget {
  final String title;
  final Function function;
  const OurButton({
    Key? key,
    required this.title,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenUtil().setSp(
        200,
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
          title,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(20),
          ),
        ),
      ),
    );
  }
}
