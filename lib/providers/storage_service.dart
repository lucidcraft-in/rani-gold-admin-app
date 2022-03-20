import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firbase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/services.dart';

class Storage {
  final firbase_storage.FirebaseStorage storage =
      firbase_storage.FirebaseStorage.instance;

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('slide');

  FirebaseFirestore firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  // Future<void> uploadFile(
  //   String filePath,
  //   String fileName,
  // ) async {
  //   File file = File(filePath);

  //   try {
  //     await storage.ref('images/$fileName').putFile(file);
  //   } on firebase_core.FirebaseException catch (e) {
  //     print(e);
  //   }
  // }

  Future<List> read() async {
    QuerySnapshot querySnapshot;
    List userlist = [];
    try {
      querySnapshot = await collectionReference.get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "name": doc['name'],
            "photo": doc["photo"],
          };
          userlist.add(a);
        }
       
        return userlist;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> uploadFile(
    String filePath,
    String fileName,
  ) async {
    File file = File(filePath);

    try {
      final Directory systemTempDir = Directory.systemTemp;

      firbase_storage.TaskSnapshot taskSnapshot =
          await storage.ref('images/$fileName').putFile(file);
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      await collectionReference.add({"photo": downloadUrl, "name": fileName});

      await storage.ref('images/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<firbase_storage.ListResult> listFiles() async {
    firbase_storage.ListResult result = await storage.ref('images').listAll();
    result.items.forEach((firbase_storage.Reference ref) {
      print('found file : $ref');
    });

    return result;
  }

  Future<String> downloadUrl(String ImageName) async {
    String downloadUrl =
        await storage.ref('images/$ImageName').getDownloadURL();
    return downloadUrl;
  }

  Future<List<Map<String, dynamic>>> loadImages() async {
    List<Map<String, dynamic>> files = [];

    final firbase_storage.ListResult result =
        await storage.ref('images').list();
    final List<firbase_storage.Reference> allFiles = result.items;

    await Future.forEach<firbase_storage.Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final firbase_storage.FullMetadata fileMeta = await file.getMetadata();
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
      });
    });
    print(files);
    return files;
  }

  Future<void> delete(String id, String ref) async {
  
    await collectionReference.doc(id).delete();

    await storage.ref(ref).delete();
    // Rebuild the UI
  }
}
