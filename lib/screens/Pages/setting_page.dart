import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:todo/authentication/authentication.dart';
import 'package:todo/models/usermodel.dart';
import 'package:todo/provider/theme_provider.dart';
import 'package:todo/widgets/our_setting_tile.dart';
import 'package:todo/widgets/our_sized_box.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  UserModel? userModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // getInfo(){
  //   var querySnapshot =  FirebaseFirestore.instance
  //                       .collection("Users")
  //                       .doc(FirebaseAuth.instance.currentUser!.uid)
  //                       .collection("User Detail")
  //                       .snapshots();

  //                       var data = querySnapshot[0];

  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setSp(20),
            vertical: ScreenUtil().setSp(10),
          ),
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                  radius: ScreenUtil().setSp(100),
                  backgroundImage: AssetImage("images/face.jpg"),
                ),
              ),
              OurSizedHeight(),
              Expanded(
                flex: 2,
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("User Detail")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.length > 0) {
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                UserModel userModel = UserModel.fromJson(
                                    snapshot.data!.docs[index]);
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    OurSettingListTile(
                                        title: "User name: ",
                                        data: userModel.name),
                                    OurSettingListTile(
                                        title: "Email: ",
                                        data: userModel.email),
                                    OurSettingListTile(
                                        title: "Account created on: ",
                                        data: userModel.AddedOn),
                                  ],
                                );
                              });
                        }
                      }
                      return Center(child: CircularProgressIndicator());
                    }),
              ),
              SwitchListTile(
                title: Text(
                  "Light mode",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(
                      16,
                    ),
                  ),
                ),
                value: !Provider.of<CurrentTheme>(context).darkTheme,
                onChanged: (values) {
                  Provider.of<CurrentTheme>(context, listen: false)
                      .toggleTheme();
                },
              ),
              ListTile(
                onTap: () async {
                  await Auth().logout(context);
                },
                title: Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(
                      16,
                    ),
                  ),
                ),
                trailing: Icon(
                  Icons.logout,
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
