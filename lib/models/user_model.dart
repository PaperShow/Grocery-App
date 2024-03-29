import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const NUMBER = 'number';
  static const ID = 'ID';

  String? _number;
  String? _id;

  String? get number => _number;
  String? get id => _id;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    _number = (snapshot.data() as dynamic)[NUMBER];
    _id = (snapshot.data() as dynamic)[ID];
  }
}
