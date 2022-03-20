import 'package:flutter/material.dart';
import '../../providers/goldrate.dart';
import 'package:provider/provider.dart';

class GoldRateScreen extends StatefulWidget {
  static const routeName = '/gold-rate';
  const GoldRateScreen({Key key}) : super(key: key);

  @override
  _GoldRateScreenState createState() => _GoldRateScreenState();
}

class _GoldRateScreenState extends State<GoldRateScreen> {
  final _formKey = GlobalKey<FormState>();

  var _isLoading = false;
  var _goldRate = GoldrateModel(
    id: '',
    gram: 0,
    pavan: 0,
    up: 0,
    down: 0,
  );
  Goldrate db;

  List goldrateList = [];
  initialise() {
    db = Goldrate();
    db.initiliase();
    db.read().then((value) => {
          print(value),
          setState(() {
            goldrateList = value;
          })
        });

    // print(goldrateList[0]['gram']);
  }

  @override
  void initState() {
    super.initState();
    initialise();
  }

  Future<void> _saveForm(String id) async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      print(_goldRate.up);
      Provider.of<Goldrate>(context, listen: false).update(id, _goldRate);
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Succes!'),
          content: Text('Updated Successfully'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, GoldRateScreen.routeName);
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
    return Scaffold(
        appBar: AppBar(
          title: Text('Gold Rate'),
          actions: [],
        ),
        body: Container(
          child: goldrateList.length > 0
              ? new SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 16),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            initialValue: goldrateList[0]['gram'].toString(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Rate in gram';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _goldRate = GoldrateModel(
                                gram: double.tryParse(value),
                                pavan: _goldRate.pavan,
                                up: _goldRate.up,
                                down: _goldRate.down,
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
                              labelText: 'Enter rate in gram',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 16),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            initialValue: goldrateList[0]['pavan'].toString(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Rate in 8 gram';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _goldRate = GoldrateModel(
                                gram: _goldRate.gram,
                                pavan: double.tryParse(value),
                                up: _goldRate.up,
                                down: _goldRate.down,
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
                              labelText: 'Enter rate 8 in gram',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 16),
                          child: Column(
                            children: <Widget>[
                              Row(children: <Widget>[
                                Expanded(
                                    child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  initialValue:goldrateList[0]['up'] != null ?
                                      goldrateList[0]['up'].toString(): 0.0.toString(),
                                  onSaved: (value) {
                                    _goldRate = GoldrateModel(
                                      gram: _goldRate.gram,
                                      pavan: _goldRate.pavan,
                                      up: double.tryParse(value),
                                      down: _goldRate.down,
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
                                    labelText: 'Up',
                                  ),
                                )),
                                Expanded(
                                    child: TextFormField(
                                  keyboardType: TextInputType.number,
                                
                                  initialValue:  goldrateList[0]['down'] != null ?
                                      goldrateList[0]['down'].toString(): 0.0.toString(),
                                  onSaved: (value) {
                                    _goldRate = GoldrateModel(
                                      gram: _goldRate.gram,
                                      pavan: _goldRate.pavan,
                                      up: _goldRate.up,
                                      down: double.tryParse(value),
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
                                    labelText: 'Down',
                                  ),
                                ))
                              ])
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding:
                        //       const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        //   child: TextFormField(
                        //     initialValue: goldrateList[0]['down'].toString(),
                        //     validator: (value) {
                        //       if (value == null || value.isEmpty) {
                        //         return 'Down';
                        //       }
                        //       return null;
                        //     },

                        //     onSaved: (value) {
                        //       _goldRate = GoldrateModel(
                        //         gram:_goldRate.gram,
                        //         pavan: _goldRate.pavan ,
                        //         down: double.tryParse(value),

                        //       );
                        //     },
                        //     decoration: const InputDecoration(
                        //       border: UnderlineInputBorder(),
                        //       labelText: 'Enter down rate',
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              _saveForm(goldrateList[0]['id']);
                              // Validate returns true if the form is valid, or false otherwise.
                              // if (_formKey.currentState.validate()) {
                              //   // If the form is valid, display a snackbar. In the real world,
                              //   // you'd often call a server or save the information in a database.
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     const SnackBar(content: Text('Processing Data')),
                              //   );
                              // }
                            },
                            child: const Text('Update'),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ));
  }
}
