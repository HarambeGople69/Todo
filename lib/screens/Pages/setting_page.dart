import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:todo/services/authentication/authentication.dart';
import 'package:todo/services/addImages/profile_image..dart';
import 'package:todo/models/usermodel.dart';
import 'package:todo/provider/theme_provider.dart';
import 'package:todo/widgets/our_setting_tile.dart';
import 'package:todo/widgets/our_sized_box.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  UserModel? userModel;
  bool process = false;
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
        body: ModalProgressHUD(
      inAsyncCall: process,
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setSp(20),
            vertical: ScreenUtil().setSp(10),
          ),
          child: Column(
            children: [
              // Spacer(),
              OurSizedHeight(),
              Container(
                color: Colors.transparent,
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
                                    userModel.imageUrl == ""
                                        ? Center(
                                            child: CircleAvatar(
                                              radius: ScreenUtil().setSp(100),
                                              backgroundImage: AssetImage(
                                                  "images/profile.png"),
                                            ),
                                          )
                                        : Center(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                ScreenUtil().setSp(50),
                                              ),
                                              child: Container(
                                                height: ScreenUtil().setSp(200),
                                                width: ScreenUtil().setSp(175),
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  imageUrl: userModel.imageUrl,
                                                  placeholder: (context, url) =>
                                                      Image.asset(
                                                    "images/imageplaceholder.png",
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                    OurSizedHeight(),
                                    OurSettingListTile(
                                        title: "User name: ",
                                        data: userModel.name),
                                    OurSettingListTile(
                                        title: "Email: ",
                                        data: userModel.email),
                                    OurSettingListTile(
                                        title: "Account created on: ",
                                        data: userModel.AddedOn),
                                    ListTile(
                                      onTap: () async {
                                        setState(() {
                                          process = true;
                                        });
                                        await AddProfile().uploadImage(context);
                                        setState(() {
                                          process = false;
                                        });
                                      },
                                      title: userModel.imageUrl == ""
                                          ? Text(
                                              "Add profile picture",
                                              style: TextStyle(
                                                fontSize: ScreenUtil().setSp(
                                                  16,
                                                ),
                                              ),
                                            )
                                          : Text(
                                              "Change profile picture",
                                              style: TextStyle(
                                                fontSize: ScreenUtil().setSp(
                                                  16,
                                                ),
                                              ),
                                            ),
                                      trailing: Icon(Icons.person),
                                    ),
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
              // Spacer(),
            ],
          ),
        ),
      ),
    ));
  }
}
