import 'package:flutter/material.dart';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo/screens/Pages/gallary.dart';
import 'package:todo/screens/Pages/homepage.dart';
import 'package:todo/screens/Pages/setting_page.dart';

import 'calender.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[HomePage(), Gallery(), Calender(), SettingPage()],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(
              Icons.apps,
              size: ScreenUtil().setSp(20),
            ),
            title: Text(
              'Home',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(15),
              ),
            ),
            activeColor: Colors.red,
          ),
          BottomNavyBarItem(
              icon: Icon(
                Icons.photo_album,
                size: ScreenUtil().setSp(20),
              ),
              title: Text(
                'Gallery',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(15),
                ),
              ),
              activeColor: Colors.purpleAccent),
          BottomNavyBarItem(
              icon: Icon(
                Icons.calendar_today,
                size: ScreenUtil().setSp(20),
              ),
              title: Text(
                'Calender',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(15),
                ),
              ),
              activeColor: Colors.pink),
          BottomNavyBarItem(
              icon: Icon(
                Icons.settings,
                size: ScreenUtil().setSp(20),
              ),
              title: Text(
                'Settings',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(15),
                ),
              ),
              activeColor: Colors.blue),
        ],
      ),
    );
  }
}
