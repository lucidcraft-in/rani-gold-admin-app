import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:rani_gold_admin/service/local_push_notification.dart';
import '../../providers/transaction.dart';
import 'package:provider/provider.dart';
import 'customer_view.dart';
import './customer_screen.dart';

class PayAmountScreen extends StatefulWidget {
  static const routeName = "/pay-amount";
  final String userid;
  final String token;
  final double balance;
  const PayAmountScreen({Key key, this.userid, this.token, this.balance})
      : super(key: key);

  @override
  _PayAmountScreenState createState() => _PayAmountScreenState();
}

class _PayAmountScreenState extends State<PayAmountScreen> {
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
    transactionType: 0,
    note: '',
    invoiceNo: '',
    category: '',
    discount: 0,
    staffId: '',
  );

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        'This channel is used for important notifications.', // description
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

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
    // FirebaseMessaging.instance.getInitialMessage();
    // FirebaseMessaging.onMessage.listen((event) {
    //   LocalNotificationService.display(event);
    // });
    requestPermission();
    // loadFCM();
    // listenFCM();
  }

  sendNotification(String title, String token, double amt) async {
    print("check notifictionnn");
    print(token);
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
                  'body': 'Add RS $amt to your account'
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
  void didChangeDependencies() async {
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
    print("check tokennnnn ${widget.token}");
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      var result = Provider.of<Transaction>(context, listen: false).create(
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
            title: Text('Reciept'),
            actions: [],
            leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () { 
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new CustomerScreen()));
                }),
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
                       keyboardType: TextInputType.number,
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
                            staffId: _transaction.staffId,
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
                            staffId: _transaction.staffId,
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
                                staffId: _transaction.staffId,
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
                            staffId: _transaction.staffId,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextFormField(
                         keyboardType: TextInputType.number,
                        initialValue: 0.toString(),
                        onSaved: (value) {
                          _transaction = TransactionModel(
                            customerName: _transaction.customerName,
                            customerId: _transaction.customerId,
                            date: _transaction.date,
                            amount: _transaction.amount,
                            transactionType: _transaction.transactionType,
                            note: _transaction.note,
                            invoiceNo: _transaction.invoiceNo,
                            category: _transaction.category,
                            discount: double.tryParse(value),
                            staffId: _transaction.staffId,
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
                          labelText: 'Enter Discount Amount',
                        ),
                      ),
                    ),
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
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
