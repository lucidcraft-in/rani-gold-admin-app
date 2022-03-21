import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import './customer_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/user.dart';

class CreateCustomerScreen extends StatefulWidget {
  static const routeName = '/create-customer';
  const CreateCustomerScreen({Key key}) : super(key: key);

  @override
  _CreateCustomerScreenState createState() => _CreateCustomerScreenState();
}

class _CreateCustomerScreenState extends State<CreateCustomerScreen> {
  var Staff;

  @override
  void didChangeDependencies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      Staff = jsonDecode(prefs.getString('staff'));
    });
    _user = UserModel(
      id: _user.id,
      name: _user.name,
      custId: _user.custId,
      phoneNo: _user.phoneNo,
      address: _user.address,
      place: _user.place,
      staffId: Staff['id'],
      schemeType: selectedValue,
    );
    super.didChangeDependencies();
    // user = prefs.containsKey('user');
  }

  final _formKey = GlobalKey<FormState>();

  String selectedValue = 'Monthly';

  var _isLoading = false;
  var _user = UserModel(
    id: '',
    name: '',
    custId: '',
    phoneNo: '',
    address: '',
    place: '',
    staffId: '',
    schemeType: '',
  );

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
      var result =
          await Provider.of<User>(context, listen: false).create(_user);
      print('result');
      print(result);
      if (result == false) {
        final snackBar = SnackBar(content: const Text('Saved successfully!'));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        setState(() {
          _isLoading = false;
          // Navigator.of(context).pop();
          Navigator.pushNamed(context, CustomerScreen.routeName);
        });
      } else {
        final snackBar = SnackBar(
          content: const Text('Customer id is exist!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
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
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Create Customer'),
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
                            return 'Please enter Cutomer name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _user = UserModel(
                            name: value,
                            custId: _user.custId,
                            phoneNo: _user.phoneNo,
                            address: _user.address,
                            place: _user.place,
                            staffId: _user.staffId,
                            schemeType: _user.schemeType,
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
                          labelText: 'Enter Cutomer name',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Cutomer id';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _user = UserModel(
                            name: _user.name,
                            custId: value,
                            phoneNo: _user.phoneNo,
                            address: _user.address,
                            place: _user.place,
                            staffId: _user.staffId,
                            schemeType: _user.schemeType,
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
                          labelText: 'Enter Customer Id',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Phone ';
                          }
                          else if(value.length != 10){

                           return 'Please enter valid Phone number ';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _user = UserModel(
                            name: _user.name,
                            custId: _user.custId,
                            phoneNo: value,
                            address: _user.address,
                            place: _user.place,
                            staffId: _user.staffId,
                            schemeType: _user.schemeType,
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
                          labelText: 'Phone number',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextFormField(
                        maxLines: 4,
                        onSaved: (value) {
                          _user = UserModel(
                            name: _user.name,
                            custId: _user.custId,
                            phoneNo: _user.phoneNo,
                            address: value,
                            place: _user.place,
                            staffId: _user.staffId,
                            schemeType: _user.schemeType,
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
                          labelText: 'Address',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextFormField(
                        onSaved: (value) {
                          _user = UserModel(
                              name: _user.name,
                              custId: _user.custId,
                              phoneNo: _user.phoneNo,
                              address: _user.address,
                              place: value,
                              staffId: _user.staffId,
                              schemeType: _user.schemeType);
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
                          labelText: 'Place',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Select Sheme Type',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          contentPadding: EdgeInsets.all(10),
                        ),
                        child: ButtonTheme(
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          child: DropdownButton<String>(
                            hint: const Text("Sheme Type"),
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

                              _user = UserModel(
                                name: _user.name,
                                custId: _user.custId,
                                phoneNo: _user.phoneNo,
                                address: _user.address,
                                place: _user.place,
                                staffId: _user.staffId,
                                schemeType: selectedValue,
                              );
                            },
                            items: <String>[
                              'Daily',
                              'Weekly',
                              'Monthly',
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
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
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
                        child: const Text('Submit'),
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
