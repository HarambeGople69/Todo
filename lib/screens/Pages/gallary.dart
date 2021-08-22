import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:todo/addImages/gallery_image.dart';
import 'package:todo/models/galleryModal.dart';
import 'package:todo/utils/styles.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  bool process = false;

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
            child: Container(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("Gallery_Image")
                      .orderBy("timestamp", descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.length > 0) {
                        // return ListView.builder(
                        // shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        //   itemCount: snapshot.data!.docs.length,
                        //   itemBuilder: (context, index) {
                        // GalleryModel galleryModel = GalleryModel.fromJson(
                        //     snapshot.data!.docs[index]);
                        // return ClipRRect(
                        //   borderRadius: BorderRadius.circular(
                        //     ScreenUtil().setSp(50),
                        //   ),
                        //   child: Container(
                        //     height: ScreenUtil().setSp(200),
                        //     width: ScreenUtil().setSp(175),
                        //     child: CachedNetworkImage(
                        //       imageUrl: galleryModel.imageUrl,
                        //       placeholder: (context, url) => Image.asset(
                        //         "images/imageplaceholder.png",
                        //       ),
                        //     ),
                        //   ),
                        // );
                        //   },
                        // );
                        return StaggeredGridView.countBuilder(
                          // shrinkWrap: true,
                          // physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          crossAxisCount: 3,
                          staggeredTileBuilder: (index) => StaggeredTile.count(
                              (index % 7 == 0) ? 2 : 1,
                              (index % 7 == 0) ? 2 : 1),

                          mainAxisSpacing: ScreenUtil().setSp(10),
                          crossAxisSpacing: ScreenUtil().setSp(10),
                          itemBuilder: (context, index) {
                            GalleryModel galleryModel = GalleryModel.fromJson(
                                snapshot.data!.docs[index]);
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(
                                ScreenUtil().setSp(10),
                              ),
                              child: Container(
                                // height: ScreenUtil().setSp(200),
                                // width: ScreenUtil().setSp(175),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: galleryModel.imageUrl,
                                  placeholder: (context, url) => Image.asset(
                                    "images/placeholder.png",
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    }
                    return Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "images/notask.png",
                              height: ScreenUtil().setSp(200),
                              width: ScreenUtil().setSp(200),
                              fit: BoxFit.contain,
                            ),
                            Text("Create Memories...", style: SmallBoldText)
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            process = true;
          });
          await AddGalleryImage().uploadImage(context);
          setState(() {
            process = false;
          });
        },
        child: Icon(
          Icons.camera_alt_outlined,
          size: ScreenUtil().setSp(
            25,
          ),
        ),
      ),
    );
  }
}
