import 'package:cloud_firestore/cloud_firestore.dart';

class GalleryModel {
  final String imageUrl;
  final Timestamp timestamp;
  final String path;
  final String id;

  GalleryModel({
    required this.id,
    required this.imageUrl,
    required this.timestamp,
    required this.path,
  });

  factory GalleryModel.fromJson(DocumentSnapshot querySnapshot) {
    return GalleryModel(
      id:  querySnapshot.id,
      imageUrl: querySnapshot["imageUrl"],
      timestamp: querySnapshot["timestamp"],
      path: querySnapshot["path"],
    );
  }
}
