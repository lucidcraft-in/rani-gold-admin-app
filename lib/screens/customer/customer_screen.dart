import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import './create_customer_screen.dart';
import '../../providers/user.dart';
import 'customer_view.dart';
import '../customer/update_customer.dart';
import '../home_screen.dart';

class CustomerScreen extends StatefulWidget {
  static const routeName = '/customer-screen';

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  User db;
  List userList = [];
  // List filterList = [];
  var filterList = [];

  Widget appBarTitle = new Text(
    "Customers",
    style: new TextStyle(color: Colors.white),
  );
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  bool isLoading = true;

  bool _IsSearching;

  final TextEditingController _searchQuery = new TextEditingController();
  initialise() {
    db = User();
    db.initiliase();
    db.read().then((value) => {
          setState(() {
            userList = filterList = value;

            isLoading = false;
          })
        });
    _IsSearching = false;
  }

  @override
  void initState() {
    super.initState();
    initialise();
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "Customers",
        style: new TextStyle(color: Colors.white),
      );
      _IsSearching = false;
      _searchQuery.clear();
    });
  }

  void _handleSearchStart() {
    setState(() {
      _IsSearching = true;
    });
  }

  Widget buildBar(BuildContext context) {
    return new AppBar(
        centerTitle: true,
        title: appBarTitle,
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            
             Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new HomeScreen()));
              }),
        actions: <Widget>[
          new IconButton(
            icon: actionIcon,
            onPressed: () {
              setState(() {
                if (this.actionIcon.icon == Icons.search) {
                  this.actionIcon = new Icon(
                    Icons.close,
                    color: Colors.white,
                  );
                  this.appBarTitle = new TextField(
                    controller: _searchQuery,
                    style: new TextStyle(
                      color: Colors.white,
                    ),
                    decoration: new InputDecoration(
                        prefixIcon: new Icon(Icons.search, color: Colors.white),
                        hintText: "Search...",
                        hintStyle: new TextStyle(color: Colors.white)),
                    onChanged: (string) {
                      setState(() {
                        filterList = userList
                            .where((element) =>
                                (element['custId']
                                    .toLowerCase()
                                    .contains(string.toLowerCase())) ||
                                (element['name']
                                    .toLowerCase()
                                    .contains(string.toLowerCase())))
                            .toList();
                        print("check filterList.length");
                        print(filterList.length);
                      });
                    },
                  );
                  _handleSearchStart();
                } else {
                  _handleSearchEnd();
                }
              });
            },
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: buildBar(context),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          onPressed: () =>
              {Navigator.of(context).pushNamed(CreateCustomerScreen.routeName)},
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: userList != null
                    ? filterList.length != 0
                        ? ListView.builder(
                            itemCount: filterList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: <Widget>[
                                  //  Container(
                                  //     padding: EdgeInsets.fromLTRB(10,10,10,0),
                                  //     height: 100,
                                  //     width: double.maxFinite,
                                  //    child: Card(elevation: 5,),
                                  //  )
                                  ListTile(
                                    title:
                                        Text(' ${filterList[index]['name']}'),
                                    subtitle: Container(
                                      padding:
                                          EdgeInsets.only(top: 10, left: 6),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(filterList[index]['custId']),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(filterList[index]['schemeType']),
                                        ],
                                      ),
                                    ),
                                    leading: CircleAvatar(
                                        child: Icon(Icons.account_box)),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CustomerViewScreen(
                                                      db: db,
                                                      user:
                                                          filterList[index])));
                                      // Navigator.of(context).pushNamed(
                                      //     CustomerViewScreen.routeName,
                                      //     arguments: {
                                      //       userList: userList[index],
                                      //       db: db
                                      //     });
                                    },
                                    trailing: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateCustomerScreen(
                                                        db: db,
                                                        user:
                                                            userList[index])));
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    height: 20,
                                  ),
                                ],
                              );
                            })
                        : Container(
                            padding: EdgeInsets.all(5),
                            child: Center(
                              child: Text(
                                "No Result Found !",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                    : Center(
                        child: CircularProgressIndicator(),
                      ))
          ],
        ),
      ),
    );
  }
}
