import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user.dart';
import '../../providers/user.dart';
import '../customer/customer_screen.dart';

class UpdateCustomerScreen extends StatefulWidget {
  static const routeName = '/update-customer';
  UpdateCustomerScreen({Key key, this.user, this.db}) : super(key: key);

  Map user;
  User db;
  @override
  _UpdateCustomerScreenState createState() => _UpdateCustomerScreenState();
}

class _UpdateCustomerScreenState extends State<UpdateCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  String selectedValue = 'Monthly';
  bool changeCustIdIS = false;
  var _isLoading = false;
  var _user = UserModel(
    id: '',
    name: '',
    custId: '',
    phoneNo: '',
    address: '',
    place: '',
    schemeType: '',
  );

  @override
  void initState() {
    super.initState();

    selectedValue = widget.user['schemeType'];

    _user = UserModel(
      name: _user.name,
      custId: _user.custId,
      phoneNo: _user.phoneNo,
      address: _user.address,
      place: _user.place,
      schemeType: selectedValue,
    );
  }

  Future<void> _delete() async {
    try {
      try {
        Provider.of<User>(context, listen: false).delete(widget.user['id']);
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Succes!'),
            content: Text('Deleted Successfully'),
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
    } catch (err) {}
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
      //  var result = await Provider.of<User>(context, listen: false)
      //     .update(widget.user['id'], _user, changeCustIdIS);
      var result = await Provider.of<User>(context, listen: false).update(widget.user['id'], _user, changeCustIdIS);
          
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
    // setState(() {
    //   _isLoading = false;
    //   // Navigator.of(context).pop();

    //   Navigator.pushNamed(context, CustomerScreen.routeName);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            title: Text(
              "Update Customer",
              style:
                  TextStyle(fontFamily: 'latto', fontWeight: FontWeight.bold),
            )),
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
                      initialValue: widget.user['name'],
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      initialValue: widget.user['custId'],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Cutomer id';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          changeCustIdIS = true;
                        });
                      },
                      onSaved: (value) {
                        _user = UserModel(
                          name: _user.name,
                          custId: value,
                          phoneNo: _user.phoneNo,
                          address: _user.address,
                          place: _user.place,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                     keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Phone ';
                        }
                        return null;
                      },
                      initialValue: widget.user['phoneNo'],
                      onSaved: (value) {
                        _user = UserModel(
                          name: _user.name,
                          custId: _user.custId,
                          phoneNo: value,
                          address: _user.address,
                          place: _user.place,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      maxLines: 4,
                      initialValue: widget.user['address'],
                      onSaved: (value) {
                        _user = UserModel(
                          name: _user.name,
                          custId: _user.custId,
                          phoneNo: _user.phoneNo,
                          address: value,
                          place: _user.place,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      initialValue: widget.user['place'],
                      onSaved: (value) {
                        _user = UserModel(
                          name: _user.name,
                          custId: _user.custId,
                          phoneNo: _user.phoneNo,
                          address: _user.address,
                          place: value,
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
                        FlatButton(
                          color: Colors.red,
                          onPressed: () {
                            _delete();
                            // Validate returns true if the form is valid, or false otherwise.
                            // if (_formKey.currentState.validate()) {
                            //   addUser();
                            //   // If the form is valid, display a snackbar. In the real world,
                            //   // you'd often call a server or save the information in a database.
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(content: Text('Processing Data')),
                            //   );
                            // }
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
