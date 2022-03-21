import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class StaffModel {
  final String id;
  final String staffName;
  final String location;
  final String address;
  final String phoneNo;
  final String password;
  final int type;
  StaffModel({
    @required this.id,
    @required this.staffName,
    @required this.location,
    @required this.address,
    @required this.phoneNo,
    @required this.password,
    @required this.type,
  });
}

class Staff with ChangeNotifier {
  FirebaseFirestore firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('staffs');

  List<StaffModel> _staffModel;

  // note
  // ======================
  //  type : 0 is staff,
  //  type : 1 is admin,
  // ============================

  Future<void> create(StaffModel staffModel) async {
    try {
      await collectionReference.add({
        'staffName': staffModel.staffName,
        'location': staffModel.location,
        'address': staffModel.address,
        'phoneNo': staffModel.phoneNo,
        'password': staffModel.password,
        'type': 0,
        'timestamp': FieldValue.serverTimestamp()
      });
      notifyListeners();
      final newStaffModel = StaffModel(
        id: staffModel.id,
        staffName: staffModel.staffName,
        location: staffModel.location,
        address: staffModel.address,
        phoneNo: staffModel.phoneNo,
        password: staffModel.password,
        type: 0,
      );

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> update(String id, StaffModel staffModel) async {
    try {
      await collectionReference.doc(id).update({
        'staffName': staffModel.staffName,
        'location': staffModel.location,
        'address': staffModel.address,
        'phoneNo': staffModel.phoneNo,
        'password': staffModel.password,
      });
    } catch (e) {
      print(e);
    }
  }

Future<void> updatePassword(String id, StaffModel staffModel) async {
    try {
      await collectionReference.doc(id).update({
        
        'password': staffModel.password,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List> read() async {
    QuerySnapshot querySnapshot;
    List userlist = [];
    try {
      querySnapshot = await collectionReference.orderBy('timestamp').get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "staffName": doc['staffName'],
            "location": doc["location"],
            "address": doc["address"],
            "phoneNo": doc["phoneNo"],
            "password": doc["password"],
            "type": doc["type"],
          };
          userlist.add(a);
        }

        return userlist;
      }
    } catch (e) {
      print(e);
    }
  }

  
  Future<void> delete(String id) async {
    try {
      await collectionReference.doc(id).delete();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
