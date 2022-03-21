import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/staff.dart';
import './staff_list_screen.dart';
import '../home_screen.dart';
class UpdateStaffScreen extends StatefulWidget {
  UpdateStaffScreen({Key key, this.staff, this.db}) : super(key: key);
  static const routeName = '/update-staff';

  Map staff;
  Staff db;
  @override
  _UpdateStaffScreenState createState() => _UpdateStaffScreenState();
}

class _UpdateStaffScreenState extends State<UpdateStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;
  var _staff = StaffModel(
    id: '',
    staffName: '',
    location: '',
    address: '',
    phoneNo: '',
    password: '',
  );

  Future<void> _delete() async {
    try {
      try {
        Provider.of<Staff>(context, listen: false).delete(widget.staff['id']);
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Succes!'),
            content: Text('Deleted Successfully'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.pushNamed(context, StaffListScreen.routeName);
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
      Provider.of<Staff>(context, listen: false)
          .update(widget.staff['id'], _staff);
        
       await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Succes!'),
            content: Text('Updated Successfully'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.pushNamed(context, StaffListScreen.routeName);
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
                "Update Staff",
                style:
                    TextStyle(fontFamily: 'latto', fontWeight: FontWeight.bold),
              ),
               leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new StaffListScreen())),
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
                        initialValue: widget.staff['staffName'],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Staff name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _staff = StaffModel(
                              staffName: value,
                              location: _staff.location,
                              address: _staff.address,
                              phoneNo: _staff.phoneNo,
                              password: _staff.password,
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
                          labelText: 'Enter Staff name',
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        initialValue: widget.staff['phoneNo'],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Phone ';
                          }
                          else if(value.length !=10 ){
                            return 'Please enter  valid number ';
                          }
                          return null;
                        },
                        onSaved: (value) {
                           _staff = StaffModel(
                              staffName: _staff.staffName,
                              location: _staff.location,
                              address: _staff.address,
                              phoneNo: value,
                              password: _staff.password,
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
                          labelText: 'Enter Phone Number',
                        ),
                      ),
                    ),
                    
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        maxLines: 4,
                        initialValue: widget.staff['address'],
                        onSaved: (value) {
                          _staff = StaffModel(
                              staffName: _staff.staffName,
                              location: _staff.location,
                              address: value,
                              phoneNo: _staff.phoneNo,
                              password: _staff.password,
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
                        initialValue: widget.staff['location'],
                        onSaved: (value) {
                          _staff = StaffModel(
                              staffName: _staff.staffName,
                              location: value,
                              address: _staff.address,
                              phoneNo: _staff.phoneNo,
                              password: _staff.password,
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
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        initialValue: widget.staff['password'],
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
          )),
    );
  }
}
