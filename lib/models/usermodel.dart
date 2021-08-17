import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String name;
  final String AddedOn;

  UserModel({
    required this.email,
    required this.name,
    required this.AddedOn,
  });

  factory UserModel.fromJson(DocumentSnapshot querySnapshot) {
    return UserModel(
      email: querySnapshot["email"],
      name: querySnapshot["name"],
      AddedOn: querySnapshot["AddedOn"],
    );
  }
}
