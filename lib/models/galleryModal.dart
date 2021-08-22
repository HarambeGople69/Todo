import 'package:cloud_firestore/cloud_firestore.dart';

class GalleryModel {
  final String imageUrl;
  final Timestamp timestamp;

  GalleryModel({
    required this.imageUrl,
    required this.timestamp,
  });

  factory GalleryModel.fromJson(DocumentSnapshot querySnapshot) {
    return GalleryModel(
      imageUrl: querySnapshot["imageUrl"],
      timestamp: querySnapshot["timestamp"],
    );
  }
}
