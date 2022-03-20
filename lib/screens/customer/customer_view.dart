import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'pay_amount.dart';
import 'purchase_amount.dart';
import '../../providers/user.dart';
import '../../providers/transaction.dart';
import 'update_transaction.dart';

class CustomerViewScreen extends StatefulWidget {
  static const routeName = '/customer-view';
  CustomerViewScreen({Key key, this.user, this.db}) : super(key: key);
  Map user;
  User db;

  @override
  _CustomerViewScreenState createState() => _CustomerViewScreenState();
}

class _CustomerViewScreenState extends State<CustomerViewScreen> {
  Transaction db;

  List transactionList = [];
  List filteredTransactionList = [];

  var _isInit = true;

  initialise() {
    db = Transaction();
    db.initiliase();
    db.read(widget.user['id']).then((value) => {
          setState(() {
            transactionList = value;
          })
        });

    filteredTransactionList =
        transactionList.where((customerId) => widget.user['id']).toList();
    print("object");
    print(filteredTransactionList);
  }

  @override
  void initState() {
    super.initState();
    initialise();
    // userId = ModalRoute.of(context).settings.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.user['name']),
          actions: [
            IconButton(
              icon: Icon(Icons.person_pin),
              onPressed: () {
                // showPlatformSearch(
                //   context: context,
                //   delegate: MaterialSearchDelegate(search),
                // );
              },
            ),
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding:
                                EdgeInsets.only(top: 10, left: 0, right: 0)),
                        Container(
                          padding: EdgeInsets.only(top: 0, left: 0, right: 0),
                          child: Text(
                            "Available balance is",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey[400], fontFamily: 'latto'),
                          ),
                        ),
                        Container(
                            padding:
                                EdgeInsets.only(top: 10, left: 0, right: 0),
                            child: Text(
                              " + ₹ ${widget.user['balance'].toString()}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'latto',
                                  fontSize: 15),
                            )),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PayAmountScreen(
                                              userid: widget.user['id'],
                                              token: widget.user['token'],
                                              balance:
                                                  widget.user['balance'])));
                                },
                               style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            side: BorderSide(
                                                color: Colors.green)))),
                                child: Row(
                                  // Replace with a Row for horizontal icon + text
                                  children: <Widget>[
                                    Icon(
                                      Icons.arrow_downward,
                                      color: Colors.green,
                                    ),
                                    Text(
                                      "Reciept",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PurchaseAmountScreen(
                                                  userid: widget.user['id'],
                                                  token: widget.user['token'],
                                                  balance:
                                                      widget.user['balance'])));
                                },
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            side: BorderSide(
                                                color: Colors.red)))),
                                child: Row(
                                  // Replace with a Row for horizontal icon + text
                                  children: <Widget>[
                                    Icon(
                                      Icons.arrow_upward,
                                      color: Colors.red,
                                    ),
                                    Text(
                                      "Purchase",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
              Expanded(
                  flex: 2,
                  child: Container(
                    child: transactionList != null
                        ? ListView.builder(
                            itemCount: transactionList.length,
                            itemBuilder: (BuildContext context, int index) {
                              DateTime myDateTime =
                                  (transactionList[index]['date']).toDate();

                              return Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    color: Colors.grey[200],
                                    width: double.infinity,
                                    height: 25,
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          DateFormat.yMMMd()
                                              .add_jm()
                                              .format(myDateTime)
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(5.0),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.6,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              child: transactionList[index]
                                                          ['transactionType'] ==
                                                      0
                                                  ? FaIcon(
                                                      FontAwesomeIcons
                                                          .plusCircle,
                                                      size: 22,
                                                      color: Colors.green[700],
                                                    )
                                                  : FaIcon(
                                                      FontAwesomeIcons
                                                          .minusCircle,
                                                      size: 22,
                                                      color: Colors.red[700],
                                                    ),
                                            ),
                                            Expanded(
                                                child: Text(
                                              transactionList[index]['note'],
                                              style: TextStyle(
                                                  fontFamily: 'latto',
                                                  fontSize: 13,
                                                  color: Colors.black87),
                                            )),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(4.0),
                                        width: 70.0,
                                        child: Text(
                                          " ₹ ${transactionList[index]['amount'].toString()}",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: "latto",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpdateTransaction(
                                                          db: db,
                                                          transaction:
                                                              transactionList[
                                                                  index])));
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            })
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                  ))
            ],
          ),
        ));
  }
}
