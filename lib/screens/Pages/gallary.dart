import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo/addImages/gallery_image.dart';
import 'package:todo/models/galleryModal.dart';
import 'package:todo/utils/styles.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  String url = "";
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  Future<void> uploadImage() async {
    final picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) {
      return null;
    }
    String filename = pickedImage.name;
    File imageFile = File(pickedImage.path);
    try {
      final uploadTask = await firebaseStorage.ref(filename).putFile(imageFile);

      if (uploadTask.state == TaskState.success) {
        String downloadUrl =
            await firebaseStorage.ref(filename).getDownloadURL();
        // await FirebaseFirestore.instance
        //     .collection("ImagesUrl")
        //     .add({"url": downloadUrl}).then((value) => print("UtsavUrls"));

        var list = await FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("User Detail")
            .get();
        var a = list.docs[0].id;
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("User Detail")
            .doc(a)
            .update({"imageUrl": downloadUrl});
        print(a);
        print("hiiiiiiiiiiiiiiiiiiiiiii");

        // print("Download Url:::    $downloadUrl");
      } else {}
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  Future<List> loadImage() async {
    List<Map> files = [];
    final ListResult result = await firebaseStorage.ref().listAll();
    final List<Reference> allFiles = result.items;
    await Future.forEach(allFiles, (Reference file) async {
      final String fileUrl = await file.getDownloadURL();
      files.add({"url": fileUrl, "path": file.fullPath});
    });
    print(files);
    return files;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                            (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),

                        mainAxisSpacing: ScreenUtil().setSp(10),
                        crossAxisSpacing: ScreenUtil().setSp(10),
                        itemBuilder: (context, index) {
                          GalleryModel galleryModel =
                              GalleryModel.fromJson(snapshot.data!.docs[index]);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AddGalleryImage().uploadImage(context);
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
