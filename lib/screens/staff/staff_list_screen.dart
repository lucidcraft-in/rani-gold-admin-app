import 'package:flutter/material.dart';

import '../../providers/staff.dart';
import './create_staff_screen.dart';
import '../home_screen.dart';
import './update_staff_scree.dart';
import './staff_view_screen.dart';

class StaffListScreen extends StatefulWidget {
  static const routeName = '/staff-list-screen';

  @override
  _StaffListScreenState createState() => _StaffListScreenState();
}

class _StaffListScreenState extends State<StaffListScreen> {
  Staff db;
  List staffList = [];
  bool isLoading = true;

  initialise() {
    db = Staff();
    db.initiliase();
    db.read().then((value) => {
          setState(() {
            staffList = value;

            isLoading = false;
          })
        });
  }

  @override
  void initState() {
    super.initState();
    initialise();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Staffs'),
          actions: [],
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                  Navigator.pop(context);
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new HomeScreen()));
              }),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          onPressed: () =>
              {Navigator.of(context).pushNamed(CreateStaffScreen.routeName)},
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: staffList != null
                    ? staffList.length > 0
                        ? ListView.builder(
                            itemCount: staffList.length,
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
                                    title: Text(
                                        ' ${staffList[index]['staffName']}'),
                                    subtitle: Text(staffList[index]['phoneNo']),
                                    leading: CircleAvatar(
                                        child: Icon(Icons.account_box)),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  StaffViewScreen(
                                                      db: db,
                                                      staff:
                                                          staffList[index])));
                                    },
                                    trailing: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateStaffScreen(
                                                        db: db,
                                                        staff:
                                                            staffList[index])));
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  )
                                ],
                              );
                            })
                        : Center(
                            child: Text(
                              "No data Available",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
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
