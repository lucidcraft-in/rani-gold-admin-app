import 'package:flutter/material.dart';
import '../../providers/staff.dart';
import '../../providers/user.dart';
import './staff_report_screen.dart';

class StaffViewScreen extends StatefulWidget {
  StaffViewScreen({Key key, this.staff, this.db}) : super(key: key);
  Map staff;
  Staff db;

  @override
  _StaffViewScreenState createState() => _StaffViewScreenState();
}

class _StaffViewScreenState extends State<StaffViewScreen> {
  User dbUser;
  List userLst = [];

  initialise() {
    dbUser = User();
    dbUser.initiliase();
    dbUser.readBystaffId(widget.staff['id']).then((value) => {
          setState(() {
            userLst = value;
          })
        });
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
        title: Text(" users of ${widget.staff['staffName']}"),
        actions: [
         
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            child: OutlineButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StaffReprotScreen(
                            db: widget.db, staff: widget.staff)));
              },
              child: Text(
                "Report",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
              child: userLst != null
                  ? userLst.length > 0 ? ListView.builder(
                      itemCount: userLst.length,
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
                              title: Text(' ${userLst[index]['name']}'),
                              subtitle: Text(userLst[index]['custId']),
                              leading:
                                  CircleAvatar(child: Icon(Icons.account_box)),
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             CustomerViewScreen(
                                //                 db: db,
                                //                 user: filterList[index])));
                              },
                              // trailing: IconButton(
                              //   onPressed: () {
                              //     Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (context) =>
                              //                 UpdateCustomerScreen(
                              //                     db: db,
                              //                     user: userList[index])));
                              //   },
                              //   icon: const Icon(
                              //     Icons.edit,
                              //     color: Colors.blue,
                              //   ),
                              // ),
                            )
                          ],
                        );
                      }):Center(child: Container( padding: EdgeInsets.all(10), child: Text("No data Available",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)),)
                  : Center(
                      child: CircularProgressIndicator(),
                    ))
        ],
      ),
    );
  }
}
