import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firbase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

import 'dart:convert';
// import './database.dart';

class SliderModel {
  final String id;
  final String name;
  final String photo;

  SliderModel({
    @required this.id,
    @required this.name,
    @required this.photo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'photo': photo,
    };
  }
}

class Slider with ChangeNotifier {
  FirebaseFirestore firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  final firbase_storage.FirebaseStorage storage =
      firbase_storage.FirebaseStorage.instance;

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('slide');
  // Map<String, UserModel> _user = {};
  List<SliderModel> _slider;

  Future<void> uploadFile(
    String filePath,
    String fileName,
  ) async {
    File file = File(filePath);

    try {
      print("hoi");
      final Directory systemTempDir = Directory.systemTemp;
      final byteData = await rootBundle.load(fileName);
      // final file = File('${systemTempDir.path}/$imageName.jpeg');
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      firbase_storage.TaskSnapshot taskSnapshot =
          await storage.ref('images/$fileName').putFile(file);
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      await collectionReference.add({"photo": downloadUrl, "name": fileName});
      print("check download url");
      print(downloadUrl);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<bool> create(SliderModel sliderModel) async {
    try {
      QuerySnapshot querySnapshot;

      await collectionReference.add({
        'name': sliderModel.name,
        'cust_id': sliderModel.photo,
        'timestamp': FieldValue.serverTimestamp()
      });
      notifyListeners();
      final newUser = SliderModel(
        id: sliderModel.id,
        name: sliderModel.name,
        photo: sliderModel.photo,
      );

      notifyListeners();

      return Future<bool>.value(false);
    } catch (e) {
      print(e);
    }
  }

  // Future<void> update(String id, UserModel userModel) async {
  //   try {
  //     await collectionReference.doc(id).update({
  //       'name': userModel.name,
  //       'cust_id': userModel.custId,
  //       'phone_no': userModel.phoneNo,
  //       'address': userModel.address,
  //       'place': userModel.place,
  //     });
  //     notifyListeners();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<List> read() async {
    QuerySnapshot querySnapshot;
    List userlist = [];
    try {
      querySnapshot = await collectionReference.orderBy('timestamp').get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "name": doc['name'],
            "custId": doc["cust_id"],
            "phoneNo": doc["phone_no"],
            "address": doc["address"],
            "place": doc["place"],
            "balance": doc["balance"],
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

  void removeItem(String productId) {
    _slider.remove(productId);
    notifyListeners();
  }
}
