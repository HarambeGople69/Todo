import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorlizer/colorlizer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class AddGalleryImage {
  ColorLizer colorlizer = ColorLizer();

  Future<void> uploadImage(BuildContext context) async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    final picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) {
      return null;
    }
    String filename = pickedImage.name;
    File imageFile = File(pickedImage.path);
    File compressedFiles = await compressImage(imageFile);
    try {
      final uploadTask = await firebaseStorage
          .ref("${FirebaseAuth.instance.currentUser!.uid}/$filename")
          .putFile(compressedFiles);

      if (uploadTask.state == TaskState.success) {
        String downloadUrl = await firebaseStorage
            .ref("${FirebaseAuth.instance.currentUser!.uid}/$filename")
            .getDownloadURL();

        await FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Gallery_Image")
            .add({
          "imageUrl": downloadUrl,
          "timestamp": DateTime.now(),
          "path": filename,
        }).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: colorlizer.getRandomColors()!.withOpacity(0.5),
              content: Text(
                "Image added",
                style: TextStyle(fontSize: ScreenUtil().setSp(15)),
              ),
            ),
          );
        });

        print("hiiiiiiiiiiiiiiiiiiiiiii");
      } else {}
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  Future<File> compressImage(File file) async {
    File compressedFile =
        await FlutterNativeImage.compressImage(file.path, quality: 50);
    print("original size ${file.lengthSync()}");
    print(compressedFile.lengthSync());
    return compressedFile;
  }

  Future<void> deleteImage(
      String path, String documentId, BuildContext context) async {
    try {
      FirebaseStorage firebaseStorage = FirebaseStorage.instance;
      await firebaseStorage
          .ref("${FirebaseAuth.instance.currentUser!.uid}/$path")
          .delete();
      //     .then(
      //       (value) => print(documentId),
      //     )
      //     .then((value) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       backgroundColor: colorlizer.getRandomColors()!.withOpacity(0.5),
      //       content: Text(
      //         "Image deleted",
      //         style: TextStyle(fontSize: ScreenUtil().setSp(15)),
      //       ),
      //     ),
      //   );
      // });
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Gallery_Image")
          .doc(documentId)
          .delete();
    } catch (e) {
      print(e);
    }
  }
}
