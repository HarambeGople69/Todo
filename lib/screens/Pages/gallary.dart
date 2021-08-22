import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

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
      body: FutureBuilder(
          future: loadImage(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data.length ?? 0,
                itemBuilder: (context, index) {
                  final Map image = snapshot.data[index];
                  return Expanded(child: Image.network(image["url"]));
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          uploadImage();
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
