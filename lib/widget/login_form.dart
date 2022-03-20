
import 'package:flutter/material.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../providers/staff.dart';
import '../screens/home_screen.dart';

class LoginForm extends StatefulWidget {
  

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
   Staff db;

  List staffList = [];
  List filterList = [];
  var index;

   initialise() {
    db = Staff();
    db.initiliase();
    db.read().then((value) => {
          setState(() {
           
            staffList = value;
          })
        });

  }

@override
  void initState() {
    super.initState();
    initialise();
  }

   TextEditingController _staffPhoneNo = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

 final _form = GlobalKey<FormState>();
  TextStyle style = TextStyle(
    fontFamily: 'latto',
    fontSize: 20.0,
    color: Colors.white,
  );

  login() async {
   
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   

    filterList = staffList.where((element) => (element['phoneNo'].toLowerCase().contains(_staffPhoneNo.text.toLowerCase())
        )).toList();
 

    if (filterList.isNotEmpty && filterList[0]['phoneNo']==_staffPhoneNo.text) {
      if (filterList[0]['password'] == _passwordController.text) {
      
        sharedPreferences.setString("staff", json.encode(filterList[0]));

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => HomeScreen()),
          (Route<dynamic> route) => false);
      } else {
        final snackBar = SnackBar(
            content: const Text('Wrong password!'),
           );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
         
      }
    } else {
       final snackBar = SnackBar(
            content: const Text('Staff phone number is invalid!'),
           );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _form,
        child: Container(
          padding: EdgeInsets.only(left: 25, right: 25),
          child: Column(children: <Widget>[
            TextFormField(
              controller: _staffPhoneNo,
              textAlign: TextAlign.left,
              // controller: _emailController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please provide Valid Phone No.';
                }
                return null;
              },
              obscureText: false,
              style: TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                hintText: "Phone Number",
                hintStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.orangeAccent),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _passwordController,
              textAlign: TextAlign.left,
              // controller: _emailController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please provide a value.';
                }
                return null;
              },
              obscureText: false,
              style: TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.orangeAccent),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Material(
              elevation: 1.0,
              borderRadius: BorderRadius.circular(12.0),
              color: Theme.of(context).accentColor,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                onPressed: () {
                  // Navigator.of(context).pushNamed(TransactionScreen.routeName);
                  login();
                },
                child: Text("Login",
                    textAlign: TextAlign.center,
                    style: style.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}