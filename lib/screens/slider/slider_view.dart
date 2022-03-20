import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart' as firbase_storage;
import 'package:file_picker/file_picker.dart';
import '../home_screen.dart';
import '../../providers/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewSlidersScreen extends StatefulWidget {
  static const routeName = '/view-slider';
  const ViewSlidersScreen({Key key}) : super(key: key);

  @override
  _ViewSlidersScreenState createState() => _ViewSlidersScreenState();
}

class _ViewSlidersScreenState extends State<ViewSlidersScreen> {
  Stream slides;
  Storage db;
  List userList = [];
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('slide');

  Stream _queryDb() {
    slides = FirebaseFirestore.instance.collection('slide').snapshots().map(
          (list) => list.docs.map((doc) => doc.data()),
        );
  }

  @override
  void initState() {
    _queryDb();
    super.initState();
    initialise();
  }

  initialise() {
    db = Storage();
    db.initiliase();
    db.read().then((value) => {
          setState(() {
            userList = value;
          })
        });
    print("usersliss");

    print(userList);
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    return new WillPopScope(
     onWillPop: () async => false,
     child: new  Scaffold(
      appBar: AppBar(
        title: Text('Slider'),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () =>  Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new HomeScreen())),
          ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: () async {
          final result = await FilePicker.platform.pickFiles(
            allowMultiple: false,
            type: FileType.custom,
            allowedExtensions: ['png', 'jpg'],
          );

          if (result == null) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No file selected')));
            return null;
          }

          final path = result.files.single.path;
          final fileName = result.files.single.name;

          storage
              .uploadFile(path, fileName)
              .then((value) => print('done'))
              .then((value) =>
                  Navigator.pushNamed(context, ViewSlidersScreen.routeName));
        },
      ),
      body: StreamBuilder(
        stream: slides,
        builder: (context, AsyncSnapshot snap) {
          List slideList = snap.data.toList();
          if (snap.hasError) {
            return Text(snap.error);
          }
          if (snap.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final Map<String, dynamic> image = slideList[index];
            
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  dense: false,
                  leading: Image.network(image['photo']),
                  // title: Text(image['uploaded_by']),
                  // subtitle: Text(image['description']),
                  trailing: IconButton(
                    onPressed: () {
                     
                      Widget cancelButton = FlatButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      );
                      Widget continueButton = FlatButton(
                        child: Text("Continue"),
                        onPressed: () => storage
                            .delete(
                              userList[index]['id'],
                              'images/${userList[index]['name']}',
                            )
                            .then((value) => Navigator.pushNamed(
                                context, ViewSlidersScreen.routeName)),
                      );
                      // set up the AlertDialog
                      AlertDialog alert = AlertDialog(
                        title: Text("AlertDialog"),
                        content:
                            Text("Would you like to continue deleting slide ?"),
                        actions: [
                          cancelButton,
                          continueButton,
                        ],
                      );
                      // show the dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    ),
    
    );
  }
}
