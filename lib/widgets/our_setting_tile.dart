import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OurSettingListTile extends StatelessWidget {
  final String title;
  final String data;
  const OurSettingListTile({
    Key? key,
    required this.title,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(
                17,
              ),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            data,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(
                16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
