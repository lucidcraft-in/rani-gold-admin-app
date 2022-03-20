import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import '../../providers/transaction.dart';
import 'package:provider/provider.dart';
import 'customer_view.dart';
import './customer_screen.dart';

class PurchaseAmountScreen extends StatefulWidget {
  static const routeName = "/purchase-amount";
  const PurchaseAmountScreen({Key key, this.userid, this.token, this.balance})
      : super(key: key);

  final String userid;
  final String token;
  final double balance;

  @override
  _PurchaseAmountScreenState createState() => _PurchaseAmountScreenState();
}

class _PurchaseAmountScreenState extends State<PurchaseAmountScreen> {
  final _formKey = GlobalKey<FormState>();
     var Staff;
  AndroidNotificationChannel channel;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var _isLoading = false;
  var _isInit = true;
  String selectedValue = 'Gold';
  var _transaction = TransactionModel(
    id: '',
    customerName: '',
    customerId: '',
    date: DateTime.now(),
    amount: 0,
    transactionType: 1,
    note: '',
    invoiceNo: '',
    category: '',
    discount: 0,
     staffId: '',
  );

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("user granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("user granted provisional permission");
    } else {
      print('user declained or has not accepted permission');
    }
  }

  @override
  void initState() {
    super.initState();

    requestPermission();
  }

  sendNotification(String title, String token, double amt) async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': 1,
      'status': 'done',
      'message': title,
    };
    try {
      http.Response response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization':
                    'key=AAAAdDFGnxw:APA91bFNLXvG0N42nuug2LA059HuOse1I-lVPjopQxGSM6aMTVYlQ0MzhMHdtNnJpNxDrxmmd7ZNlrUhWBe1ocgRbgw37KMxGnHhatHyCiwCgC5-CCyq2WZtRL0lnHE7mdQ_F41ZAaVU'
              },
              body: jsonEncode(<String, dynamic>{
                'notification': <String, dynamic>{
                  'title': title,
                  'body': 'Reduce RS  $amt from your account'
                },
                'priority': 'high',
                'data': data,
                'to': "$token"
              }));

      if (response.statusCode == 200) {
        print("notification is sended");
      } else {
        print("error");
      }
    } catch (e) {}
  }

  @override
  void didChangeDependencies() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      Staff = jsonDecode(prefs.getString('staff'));
    });
    if (_isInit) {
      // final userId = ModalRoute.of(context).settings.arguments as String;

      _transaction = TransactionModel(
        customerName: _transaction.customerName,
        customerId: widget.userid,
        date: _transaction.date,
        amount: _transaction.amount,
        transactionType: _transaction.transactionType,
        note: _transaction.note,
        invoiceNo: _transaction.invoiceNo,
        category: selectedValue,
        discount: _transaction.discount,
        staffId: Staff['id'],
      );
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      Provider.of<Transaction>(context, listen: false).create(
        _transaction,
      );
      sendNotification(
          "Transaction Completed", widget.token, _transaction.amount);
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Succes!'),
          content: Text('Saved Successfully'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.pushNamed(context, CustomerScreen.routeName);
                setState(() {});
              },
            )
          ],
        ),
      );
    } catch (err) {
      print('error check =======================');
      print(err);
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          content: Text('Something went wrong. ${err}'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }
    setState(() {
      _isLoading = false;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Purchase'),
            actions: [],
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new CustomerScreen())),
            ),
          ),
          body: Container(
            child: new SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Amount';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _transaction = TransactionModel(
                            customerName: _transaction.customerName,
                            customerId: _transaction.customerId,
                            date: _transaction.date,
                            amount: double.tryParse(value),
                            transactionType: _transaction.transactionType,
                            note: _transaction.note,
                            invoiceNo: _transaction.invoiceNo,
                            category: _transaction.category,
                            discount: _transaction.discount,
                            staffId:_transaction.staffId,
                          );
                        },
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.greenAccent,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          labelText: 'Enter amount given',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextFormField(
                        onSaved: (value) {
                          _transaction = TransactionModel(
                            customerName: _transaction.customerName,
                            customerId: _transaction.customerId,
                            date: _transaction.date,
                            amount: _transaction.amount,
                            transactionType: _transaction.transactionType,
                            note: _transaction.note,
                            invoiceNo: value,
                            category: _transaction.category,
                            discount: _transaction.discount,
                            staffId:_transaction.staffId,
                          );
                        },
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.greenAccent,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          labelText: 'Enter Invoice No',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Select Category',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          contentPadding: EdgeInsets.all(10),
                        ),
                        child: ButtonTheme(
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          child: DropdownButton<String>(
                            hint: const Text("Category"),
                            isExpanded: true,
                            value: selectedValue,
                            elevation: 16,
                            underline: DropdownButtonHideUnderline(
                              child: Container(),
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                selectedValue = newValue;
                              });

                              _transaction = TransactionModel(
                                customerName: _transaction.customerName,
                                customerId: _transaction.customerId,
                                date: _transaction.date,
                                amount: _transaction.amount,
                                transactionType: _transaction.transactionType,
                                note: _transaction.note,
                                invoiceNo: _transaction.invoiceNo,
                                category: selectedValue,
                                discount: _transaction.discount,
                                staffId:_transaction.staffId,
                              );
                            },
                            items: <String>[
                              'Gold',
                              'Silver',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Note';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _transaction = TransactionModel(
                            customerName: _transaction.customerName,
                            customerId: _transaction.customerId,
                            date: _transaction.date,
                            amount: _transaction.amount,
                            transactionType: _transaction.transactionType,
                            note: value,
                            invoiceNo: _transaction.invoiceNo,
                            category: _transaction.category,
                            discount: _transaction.discount,
                            staffId:_transaction.staffId,
                          );
                        },
                        maxLines: 8,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.greenAccent,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          labelText: 'Enter Description',
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 8, vertical: 16),
                    //   child: TextFormField(
                    //     initialValue: 0.toString(),
                    //     onSaved: (value) {
                    //       _transaction = TransactionModel(
                    //         customerName: _transaction.customerName,
                    //         customerId: _transaction.customerId,
                    //         date: _transaction.date,
                    //         amount: _transaction.amount,
                    //         transactionType: _transaction.transactionType,
                    //         note: _transaction.note,
                    //         invoiceNo: _transaction.invoiceNo,
                    //         category: _transaction.category,
                    //         discount: double.tryParse(value),
                    //         staffId:_transaction.staffId,
                    //       );
                    //     },
                    //     decoration: const InputDecoration(
                    //       focusedBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(
                    //           color: Colors.greenAccent,
                    //           width: 1.0,
                    //         ),
                    //       ),
                    //       enabledBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(
                    //           color: Colors.black,
                    //           width: 1.0,
                    //         ),
                    //       ),
                    //       labelText: 'Enter Discount Amount',
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _saveForm();
                          // Validate returns true if the form is valid, or false otherwise.
                          // if (_formKey.currentState.validate()) {
                          //   // If the form is valid, display a snackbar. In the real world,
                          //   // you'd often call a server or save the information in a database.
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     const SnackBar(content: Text('Processing Data')),
                          //   );
                          // }
                        },
                        child: const Text('Save'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
