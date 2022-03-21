import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class TransactionModel {
  final String id;
  final String customerName;
  final String customerId;
  final DateTime date;
  final double amount;
  final int transactionType;
  final String note;
  final String invoiceNo;
  final String category;
  final double discount;
  final String staffId;

  TransactionModel({
    @required this.id,
    @required this.customerName,
    @required this.customerId,
    @required this.date,
    @required this.amount,
    @required this.transactionType,
    @required this.note,
    @required this.invoiceNo,
    @required this.category,
    @required this.discount,
    @required this.staffId,
  });

  TransactionModel.fromData(Map<String, dynamic> data)
      : id = data['id'],
        customerName = data['customerName'],
        customerId = data['customerId'],
        date = data['date'],
        amount = data['amount'],
        transactionType = data['transactionType'],
        note = data['note'],
        invoiceNo = data['invoiceNo'],
        category = data['category'],
        discount = data['discount'],
        staffId = data['staffId'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'customerId': customerId,
      'date': date,
      'amount': amount,
      'transactionType': transactionType,
      'note': note,
      'invoiceNo': invoiceNo,
      'category': category,
      'discount': discount,
      'staffId': staffId,
    };
  }
}

class Transaction with ChangeNotifier {
  FirebaseFirestore firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('transactions');

  CollectionReference collectionReferenceUser =
      FirebaseFirestore.instance.collection('user');

  List<TransactionModel> _transaction;
  double newbalance = 0;
  double oldBalance = 0;
  Future<void> create(TransactionModel transactionModel) async {
    QuerySnapshot querySnapshot;
    List userlist = [];
    String usrId = transactionModel.customerId;
    try {
      //  oldBalance = oldBal;

      querySnapshot = await collectionReferenceUser.get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs
            .where((element) => element.id.toString() == usrId.toString())
            .toList()) {
          oldBalance = doc["balance"];
        }
      }

      if (transactionModel.transactionType == 0) {
        newbalance = oldBalance + transactionModel.amount;
        if (transactionModel.discount != 0) {
          newbalance = newbalance - transactionModel.discount;
        }
      } else if (transactionModel.transactionType == 1) {
        newbalance = oldBalance - transactionModel.amount;
      }

      await collectionReference.add({
        'customerName': transactionModel.customerName,
        'customerId': transactionModel.customerId,
        'date': transactionModel.date,
        'amount': transactionModel.amount,
        'transactionType': transactionModel.transactionType,
        'note': transactionModel.note,
        'timestamp': FieldValue.serverTimestamp(),
        'invoiceNo': transactionModel.invoiceNo,
        'category': transactionModel.category,
        'discount': transactionModel.discount,
        'staffId': transactionModel.staffId,
      });
      await collectionReferenceUser.doc(transactionModel.customerId).update({
        'balance': newbalance,
      });
      notifyListeners();
      final newGoldrate = TransactionModel(
        id: transactionModel.id,
        customerName: transactionModel.customerName,
        customerId: transactionModel.customerId,
        date: transactionModel.date,
        amount: transactionModel.amount,
        transactionType: transactionModel.transactionType,
        note: transactionModel.note,
        invoiceNo: transactionModel.invoiceNo,
        category: transactionModel.category,
        discount: transactionModel.discount,
        staffId: transactionModel.staffId,
      );

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> update(String id, TransactionModel transactionModel,
      String transactionType, double oldValueFromDb) async {
    QuerySnapshot querySnapshot;
    QuerySnapshot querySnapshotTran;
    String usrId = transactionModel.customerId;
    int transType = 0;
    double oldval = 0.0;
    double curtrentBal = 0.0;
    // if (transactionType != "") {
    //   if (transactionType == 'in') {
    //     transType = 0;
    //   } else {
    //     transType = 1;
    //   }
    // }

    querySnapshotTran = await collectionReference.get();
    if (querySnapshotTran.docs.isNotEmpty) {
      for (var doc in querySnapshotTran.docs
          .where((element) => element.id.toString() == id.toString())
          .toList()) {
        transType = doc["transactionType"];
        oldval = doc["amount"];
        usrId = doc['customerId'];
      }
    }
    try {
      querySnapshot = await collectionReferenceUser.get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs
            .where((element) => element.id.toString() == usrId.toString())
            .toList()) {
          if (transType == 0) {
            oldBalance = doc["balance"] - oldValueFromDb;
          } else {
            print("inside elseee");
            oldBalance = doc["balance"] + oldValueFromDb;
          }
        }
      }

      if (transType == 0) {
        newbalance = oldBalance + transactionModel.amount;
        print(newbalance);
      } else if (transType == 1) {
        newbalance = oldBalance - transactionModel.amount;
      }

      await collectionReferenceUser.doc(transactionModel.customerId).update({
        'balance': newbalance,
      });

      await collectionReference.doc(id).update({
        'customerName': transactionModel.customerName,
        'customerId': transactionModel.customerId,
        'date': transactionModel.date,
        'amount': transactionModel.amount,
        'note': transactionModel.note,
        'invoiceNo': transactionModel.invoiceNo,
        'category': transactionModel.category,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List> read(String id) async {
    QuerySnapshot querySnapshot;
    List transactionList = [];
    try {
      querySnapshot = await collectionReference
          .orderBy('timestamp', descending: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          if (id == doc['customerId']) {
            Map a = {
              "id": doc.id,
              'customerName': doc['customerName'],
              'customerId': doc['customerId'],
              'date': doc['date'],
              'amount': doc['amount'],
              'transactionType': doc['transactionType'],
              'note': doc['note'],
              'invoiceNo': doc['invoiceNo'],
              'category': doc['category'],
              'discount': doc['discount'],
              'staffId': doc['staffId'],
            };
            transactionList.add(a);
          }
        }

        return transactionList;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete(String id, TransactionModel transactionModel,
      String transactionType, double oldValueFromDb) async {
    QuerySnapshot querySnapshot;
    QuerySnapshot querySnapshotTran;
    String usrId = "";
    int transType = 0;
    double oldval = 0.0;
    double curtrentBal = 0.0;

    // if (transactionType != "") {
    //   if (transactionType == 'in') {
    //     transType = 0;
    //   } else {
    //     transType = 1;
    //   }
    // } else {
    querySnapshotTran = await collectionReference.get();
    if (querySnapshotTran.docs.isNotEmpty) {
      for (var doc in querySnapshotTran.docs
          .where((element) => element.id.toString() == id.toString())
          .toList()) {
        transType = doc["transactionType"];
        oldval = doc["amount"];
        usrId = doc['customerId'];
      }
    }
    // }
    try {
      querySnapshot = await collectionReferenceUser.get();

      if (querySnapshot.docs.isNotEmpty) {
        print("helloo");

        print(usrId);
        print(transType);
        for (var doc in querySnapshot.docs
            .where((element) => element.id.toString() == usrId.toString())
            .toList()) {
          if (transType == 0) {
            print("inside iffff");
            newbalance = doc["balance"] - oldval;
          } else {
            print("inside elseee");
            newbalance = doc["balance"] + oldval;
          }
          // oldBalance = doc["balance"] - oldValueFromDb;
        }
      }

      print("iam here inside");
      print(transType);
      print(newbalance);
      await collectionReferenceUser.doc(usrId).update({
        'balance': newbalance,
      });
      await collectionReference.doc(id).delete();

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
