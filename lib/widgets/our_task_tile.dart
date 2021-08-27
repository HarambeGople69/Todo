import 'package:colorlizer/colorlizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/widgets/our_sized_box.dart';

class OurListtile extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final String uid;
  final Function ondelete;
  final Function onedit;
  final DateTime todate;
  OurListtile({
    Key? key,
    required this.title,
    required this.description,
    required this.time,
    required this.uid,
    required this.ondelete,
    required this.onedit,
    required this.todate,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
  final date2 = DateTime.now();

    ColorLizer colorlizer = ColorLizer();
    return Slidable(
        secondaryActions: [
          IconSlideAction(
            onTap: () {
              onedit();
            },
            caption: "Edit",
            color: colorlizer.getRandomColors()!.withOpacity(0.7),
            icon: Icons.edit,
          ),
          IconSlideAction(
            onTap: () {
              ondelete();
            },
            caption: "Delete",
            color: colorlizer.getRandomColors()!.withOpacity(0.7),
            icon: Icons.delete,
          ),
        ],
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              colorlizer.getRandomColors()!.withOpacity(0.8),
              colorlizer.getRandomColors()!.withOpacity(0.8),
            ]),
            color: colorlizer.getRandomColors()!.withOpacity(0.6),
            borderRadius: BorderRadius.circular(
              ScreenUtil().setSp(20),
            ),
          ),
          margin: EdgeInsets.symmetric(
            vertical: ScreenUtil().setSp(5),
          ),
          padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setSp(10),
            horizontal: ScreenUtil().setSp(10),
          ),
          height: ScreenUtil().setSp(80),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(22),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setSp(5),
                    ),
                    Text(
                      description,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(20),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              (todate.difference(date2).inDays != 0)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Remaining time",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(17),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "${todate.difference(date2).inDays} days",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(15),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Alert",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(17),
                              fontWeight: FontWeight.w600,
                              color: Colors.red),
                        ),
                        Text(
                          "${todate.difference(date2).inDays} days",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(15),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
            ],
          ),
        ),
        actionPane: SlidableDrawerActionPane());
  }
}
