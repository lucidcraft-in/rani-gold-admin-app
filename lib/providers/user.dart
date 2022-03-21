import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// import './database.dart';

class UserModel {
  final String id;
  final String name;
  final String custId;
  final String phoneNo;
  final String address;
  final String place;
  final double balance;
  final String staffId;
  final String token;
  final String schemeType;
  UserModel({
    @required this.id,
    @required this.name,
    @required this.custId,
    @required this.phoneNo,
    @required this.address,
    @required this.place,
    @required this.balance,
    @required this.staffId,
    @required this.token,
    @required this.schemeType,
  });

  UserModel.fromData(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        custId = data['cust_id'],
        phoneNo = data['phonne_no'],
        address = data['address'],
        place = data['place'],
        balance = data['balance'],
        staffId = data['staffId'],
        token = data['token'],
        schemeType = data['schemeType'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cust_id': custId,
      'phone_no': phoneNo,
      'address': address,
      'place': place,
      'balance': balance,
      'staffId': staffId,
      'token': token,
      'schemeType': schemeType,
    };
  }
}

class User with ChangeNotifier {
  FirebaseFirestore firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('user');

  CollectionReference collectionReferenceTrans =
      FirebaseFirestore.instance.collection('transactions');
  // Map<String, UserModel> _user = {};
  List<UserModel> _user;
  List<UserModel> user;

  set listStaff(List<UserModel> val) {
    _user = val;
    notifyListeners();
  }

  List<UserModel> get listUsers => _user;
  // Map<String, UserModel> get users {
  //   return {..._user};
  // }

  int get userCount {
    return _user.length;
  }

  Future<bool> create(UserModel userModel) async {
    try {
      QuerySnapshot querySnapshot;

      querySnapshot = await collectionReference.orderBy('cust_id').get();
      var user =
          querySnapshot.docs.where((doc) => doc['cust_id'] == userModel.custId);

      if (user.length == 0) {
        await collectionReference.add({
          'name': userModel.name,
          'cust_id': userModel.custId,
          'phone_no': userModel.phoneNo,
          'address': userModel.address,
          'place': userModel.place,
          'balance': 0.00,
          'staffId': userModel.staffId,
          'timestamp': FieldValue.serverTimestamp(),
          'token': "",
          'schemeType': userModel.schemeType,
        });
        notifyListeners();
        final newUser = UserModel(
          id: userModel.id,
          name: userModel.name,
          custId: userModel.custId,
          phoneNo: userModel.phoneNo,
          address: userModel.address,
          place: userModel.place,
          balance: userModel.balance,
          staffId: userModel.staffId,
          token: userModel.token,
          schemeType: userModel.schemeType,
        );

        notifyListeners();

        return Future<bool>.value(false);
      } else {
        return Future<bool>.value(true);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> update(
      String id, UserModel userModel, bool changeCustIdIS) async {
    try {
      QuerySnapshot querySnapshot;

      querySnapshot = await collectionReference.orderBy('cust_id').get();
      var user =
          querySnapshot.docs.where((doc) => doc['cust_id'] == userModel.custId);

      if (changeCustIdIS == true) {
        if (user.length == 0) {
          await collectionReference.doc(id).update({
            'name': userModel.name,
            'cust_id': userModel.custId,
            'phone_no': userModel.phoneNo,
            'address': userModel.address,
            'place': userModel.place,
            'schemeType': userModel.schemeType,
          });
          notifyListeners();
          return Future<bool>.value(false);
        } else {
          return Future<bool>.value(true);
        }
      } else {
        await collectionReference.doc(id).update({
          'name': userModel.name,
          'cust_id': userModel.custId,
          'phone_no': userModel.phoneNo,
          'address': userModel.address,
          'place': userModel.place,
          'schemeType': userModel.schemeType,
        });
        notifyListeners();
        return Future<bool>.value(false);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List> read() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var Staff = jsonDecode(prefs.getString('staff'));

    QuerySnapshot querySnapshot;
    List userlist = [];
    String staffid = Staff['id'];
    int staffType = Staff['type'];

    try {
      querySnapshot =
          await collectionReference.orderBy("balance", descending: true).get();

      if (staffType == 1) {
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
              "staffId": doc["staffId"],
              "token": doc["token"],
              "schemeType": doc["schemeType"],
            };
            userlist.add(a);
          }

          return userlist;
        }
      } else if (staffType == 0) {
        if (querySnapshot.docs.isNotEmpty) {
          for (var doc in querySnapshot.docs.toList()) {
            if (staffid == doc["staffId"]) {
              Map a = {
                "id": doc.id,
                "name": doc['name'],
                "custId": doc["cust_id"],
                "phoneNo": doc["phone_no"],
                "address": doc["address"],
                "place": doc["place"],
                "balance": doc["balance"],
                "staffId": doc["staffId"],
                "token": doc["token"],
                "schemeType": doc["schemeType"],
              };
              userlist.add(a);
            }
          }

          return userlist;
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List> readBystaffId(String staffId) async {
    QuerySnapshot querySnapshot;
    List userlist = [];

    try {
      querySnapshot = await collectionReference.orderBy('timestamp').get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          if (staffId == doc['staffId']) {
            Map a = {
              "id": doc.id,
              "name": doc['name'],
              "custId": doc["cust_id"],
              "phoneNo": doc["phone_no"],
              "address": doc["address"],
              "place": doc["place"],
              "balance": doc["balance"],
              "staffId": doc["staffId"],
              "schemeType": doc["schemeType"],
            };
            userlist.add(a);
          }
        }

        return userlist;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List> readBystaffIdAndDate(
      String staffId, DateTime selectedDate) async {
    QuerySnapshot querySnapshot;
    QuerySnapshot querySnapshotTrans;
    double totalAmount = 0;
    List userlist = [];
    List staffIds = [];
    List transList = [];
    DateTime passedDate = selectedDate;
    final lastDayOfMonth =
        DateTime(selectedDate.year, selectedDate.month + 1, 0);
    final firstDayofMonth = DateTime(selectedDate.year, lastDayOfMonth.month);
    //      DateTime.parse(lastDayOfMonth.year-${lastDayOfMonth.month}-${1}");

    try {
      querySnapshot = await collectionReference.orderBy('timestamp').get();

      querySnapshotTrans = await collectionReferenceTrans
          .orderBy('timestamp', descending: true)
          .get();
      if (querySnapshotTrans.docs.isNotEmpty) {
        // && dbDate.isAfter(firstDayofMonth)
        for (var docss in querySnapshotTrans.docs.toList()) {
          DateTime dbDate = docss['date'].toDate();
          if (docss['staffId'] == staffId) {
            if (dbDate.isBefore(lastDayOfMonth) &&
                dbDate.isAfter(firstDayofMonth)) {
              if (docss['transactionType'] == 0) {
                totalAmount = totalAmount + docss['amount'];
                staffIds.add(docss['customerId']);
                Map tra = {
                  "custId": docss['customerId'],
                  "amount": docss['amount'],
                };
                transList.add(tra);
              }
            }
          }
        }
      }
      
      var filteredCustIds = staffIds.toSet().toList();

      List userTotalbalnaceList = [];
      double tempbalance = 0;
      if (filteredCustIds.length > 0) {
        for (var k = 0; k < filteredCustIds.length; k++) {
          for (var j = 0; j < transList.length; j++) {
            if (filteredCustIds[k] == transList[j]["custId"]) {
              tempbalance = tempbalance + transList[j]["amount"];
            }
          }
          userTotalbalnaceList
              .add({"custId": filteredCustIds[k], "totalAmount": tempbalance});
          tempbalance = 0;
        }
      }
    
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          if (staffId == doc['staffId']) {
            for (var i = 0; i < userTotalbalnaceList.length; i++) {
              if (userTotalbalnaceList[i]["custId"] == doc.id) {
                Map a = {
                  "id": doc.id,
                  "name": doc['name'],
                  "custId": doc["cust_id"],
                  "phoneNo": doc["phone_no"],
                  "address": doc["address"],
                  "place": doc["place"],
                  "balance": doc["balance"],
                  "staffId": doc["staffId"],
                  "schemeType": doc["schemeType"],
                  "totalAmount": totalAmount,
                  "userMonthcollection": userTotalbalnaceList[i]["totalAmount"],
                };
                userlist.add(a);
              }
            }
          }
        }
       
        return userlist;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List> readBycustd(String custId) async {
    QuerySnapshot querySnapshot;
    List userlist = [];

    try {
      querySnapshot = await collectionReference.orderBy('timestamp').get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          if (custId == doc.id) {
            Map a = {
              "id": doc.id,
              "name": doc['name'],
              "custId": doc["cust_id"],
              "phoneNo": doc["phone_no"],
              "address": doc["address"],
              "place": doc["place"],
              "balance": doc["balance"],
              "staffId": doc["staffId"],
              "schemeType": doc["schemeType"],
            };
            userlist.add(a);
          }
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
    _user.remove(productId);
    notifyListeners();
  }

  void clear() {
    _user = [];
    notifyListeners();
  }
}

class Direction {}
