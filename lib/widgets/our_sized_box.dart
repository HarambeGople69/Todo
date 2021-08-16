import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OurSizedHeight extends StatelessWidget {
  const OurSizedHeight({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenUtil().setSp(
        15,
      ),
    );
  }
}
