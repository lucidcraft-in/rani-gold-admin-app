import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import '../../providers/staff.dart';
import '../../providers/user.dart';

class StaffReprotScreen extends StatefulWidget {
  StaffReprotScreen({Key key, this.staff, this.db}) : super(key: key);
  Map staff;
  Staff db;

  // const StaffReprotScreen({ Key key }) : super(key: key);

  @override
  State<StaffReprotScreen> createState() => _StaffReprotScreenState();
}

class _StaffReprotScreenState extends State<StaffReprotScreen> {
  User dbUser;
  List userLst = [];
  double totalBalance = 0;
  String selectedValue = 'This Month';
  DateTime selectedDate = DateTime.now();
  initialise() {
    dbUser = User();
    dbUser.initiliase();
    dbUser
        .readBystaffIdAndDate(widget.staff['id'], selectedDate)
        .then((value) => {
              setState(() {
                userLst = value;
                totalBalance = userLst[0]['totalAmount'];
              })
            });
  }

  @override
  void initState() {
    super.initState();
    initialise();
    selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report"),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.person_pin),
          //   onPressed: () {
          //     showPlatformSearch(
          //       context: context,
          //       delegate: MaterialSearchDelegate(search),
          //     );
          //   },
          // ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                Text("select month"),
                FlatButton(
                    onPressed: () {
                      showMonthPicker(
                        context: context,
                        firstDate: DateTime(DateTime.now().year - 1, 5),
                        lastDate: DateTime(DateTime.now().year + 1, 9),
                        initialDate: selectedDate ?? DateTime.now(),
                        locale: Locale("en"),
                      ).then((date) {
                        if (date != null) {
                          setState(() {
                            selectedDate = date;
                            print('select date is s $selectedDate');
                          });
                        }
                        dbUser = User();
                        dbUser.initiliase();
                        dbUser
                            .readBystaffIdAndDate(
                                widget.staff['id'], selectedDate)
                            .then((value) => {
                                  setState(() {
                                    userLst = value;
                                    totalBalance = userLst[0]['totalAmount'];
                                  })
                                });
                      });
                    },
                    child: Icon(Icons.calendar_today)),
              ],
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
                              title: Row(children: [
                                Text("User Name : ",style: TextStyle(fontSize: 13,color: Colors.grey[700]),),
                                Text(' ${userLst[index]['name']}',style: TextStyle(fontSize: 17),)
                              ],),
                              subtitle: Row(children: [
                                 Text("Collection Amount : ",style: TextStyle(fontSize: 13),),
                                Text(userLst[index]['userMonthcollection'].toString(),style: TextStyle(color: Colors.black,fontSize: 15),)
                              ],),
                                  
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
                            ),
                          ],
                        );
                      }):Center(child: Text("No data Available",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),)
                  : Center(
                      child: CircularProgressIndicator(),
                    )),
          Divider(
            height: 20,
          ),
          Container(
              padding: EdgeInsets.only(top: 20, bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Total Collection",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    userLst != null ? totalBalance.toString() : 00.0,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          Divider(
            height: 10,
          )
        ],
      ),
    );
  }
}
