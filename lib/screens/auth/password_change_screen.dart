import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../../providers/staff.dart';
import '../home_screen.dart';
import './login_screen.dart';
class PasswordChangeScreen extends StatefulWidget {
  const PasswordChangeScreen({ Key key }) : super(key: key);
    static const routeName = '/password-change-screen';

  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  final _formKey = GlobalKey<FormState>();
   var _isLoading = false;
   var staff;
  var _staff = StaffModel(
      
      password: '',
     );

  @override
  void didChangeDependencies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      staff = jsonDecode(prefs.getString('staff'));
    });
    
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
      Provider.of<Staff>(context, listen: false)
          .updatePassword(staff['id'], _staff);
        
       await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Succes!'),
            content: Text(' password Change Successfully'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.routeName);
                  setState(() {});
                },
              )
            ],
          ),
        );
    } catch (err) {
      
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
              centerTitle: true,
              elevation: 0,
              title: Text(
                "Change Password",
                style:
                    TextStyle(fontFamily: 'latto', fontWeight: FontWeight.bold),
              ),
               leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new HomeScreen())),
            ),
              ),
          body: Container(
            child: new SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                  
                    
                    
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        initialValue: staff['password'],
                        validator: (value) {
                            if (value == null || value.isEmpty) {
                            return 'Please enter password ';
                          }
                          else if (value.length <= 5 ) {
                            return 'Password must be more than 5 charater ';
                          }
                         
                          return null;
                        },
                        onSaved: (value) {
                          _staff = StaffModel(
                              staffName: _staff.staffName,
                              location: _staff.location,
                              address: _staff.address,
                              phoneNo: _staff.phoneNo,
                              password: value,
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
                          labelText: 'Password',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Validate returns true if the form is valid, or false otherwise.
                              // if (_formKey.currentState.validate()) {
                              //   addUser();
                              //   // If the form is valid, display a snackbar. In the real world,
                              //   // you'd often call a server or save the information in a database.
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     const SnackBar(content: Text('Processing Data')),
                              //   );
                              // }

                              _saveForm();
                            },
                            child: const Text('Update'),
                          ),
                       
                        ],
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
