import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rani_gold_admin/screens/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../widget/home_view.dart';
import './customer/customer_screen.dart';
import './gold_rate/gold_rate.dart';
import './slider/slider_view.dart';
import './staff/staff_list_screen.dart';
import './auth/login_screen.dart';
import 'package:http/http.dart' as http;
import './auth/password_change_screen.dart';
class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var staff;
  int staffType;

  bool _checkValue;

  @override
  void initState() {
    super.initState();
  }

  redirectLoginPage() {
    print('_checkValue');
    print(_checkValue);
    if (_checkValue == true) {
      Navigator.of(context).pushNamed(HomeScreen.routeName);
    } else {
      Navigator.of(context).pushNamed(LoginScreen.routeName);
    }
  }

  @override
  void didChangeDependencies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _checkValue = prefs.containsKey('staff');
    setState(() {
      staff = jsonDecode(prefs.getString('staff'));
    });
    staffType = staff['type'];

    super.didChangeDependencies();
    // user = prefs.containsKey('user');
  }

  

  @override
  Widget build(BuildContext context) {

    logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.getKeys();
    for (String key in preferences.getKeys()) {
      preferences.remove(key);
    }

  setState((){

  });

  //  Navigator.pop(context);
  //  Navigator.pop(context);
   Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => new LoginScreen()),
      (Route<dynamic> route) => false
);
  // Navigator.pushReplacement(context,
  //           new MaterialPageRoute(builder: (context) => new LoginScreen()));
   
  
    // Navigate Page
    // Navigator.of(context).pushNamed(HomeScreen.routeName);
  }
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "Rani Jewellery Admin",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: 'latto',
                fontWeight: FontWeight.bold),
          )),
      body: HomeView(),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: staffType == 1
            ? ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Color(0xFF612e3e),
                    ),
                    child: Text(
                      'Rani Jewellery',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // ListTile(
                  //   title: const Text('Login'),
                  //   onTap: () {
                  //  Navigator.of(context).pushNamed(LoginScreen.routeName);
                  //   },
                  // ),
                  ListTile(
                    title: const Text('Customer'),
                    onTap: () {
                        Navigator.pop(context);
                      Navigator.of(context)
                          .pushNamed(CustomerScreen.routeName);
                    },
                  ),

                  ListTile(
                    title: const Text('Gold Rate'),
                    onTap: () {
                       Navigator.pop(context);
                      Navigator.of(context).pushNamed(GoldRateScreen.routeName);
                    },
                  ),
                  // ListTile(
                  //   title: const Text('Slide'),
                  //   onTap: () {
                  //     Navigator.of(context)
                  //         .pushNamed(ViewSlidersScreen.routeName);
                  //   },
                  // ),
                  ListTile(
                    title: const Text('Staff'),
                    onTap: () {
                       Navigator.pop(context);
                      Navigator.of(context)
                          .pushNamed(StaffListScreen.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text('Change Password'),
                    onTap: () {
                       Navigator.pop(context);
                      Navigator.of(context).pushNamed(PasswordChangeScreen.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text('Logout'),
                    onTap: () {
                      logout();
                      // redirectLoginPage();
                    },
                  ),
                ],
              )
            : ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Color(0xFF612e3e),
                    ),
                    child: Text(
                      'Rani Jewellery',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // ListTile(
                  //   title: const Text('Login'),
                  //   onTap: () {
                  //  Navigator.of(context).pushNamed(LoginScreen.routeName);
                  //   },
                  // ),
                  ListTile(
                    title: const Text('Customer'),
                    onTap: () {
                       Navigator.pop(context);
                      Navigator.of(context).pushNamed(CustomerScreen.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text('Change Password'),
                    onTap: () {
                       Navigator.pop(context);
                      Navigator.of(context).pushNamed(PasswordChangeScreen.routeName);
                    },
                  ),
                  ListTile(
                    title: const Text('Logout'),
                    onTap: () {
                      logout();
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
