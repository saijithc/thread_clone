import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class StorageServices {
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<String?> uploadImage(
      {required String folderName,
      required bool isPost,
      required Uint8List file}) async {
    try {
      Reference ref =
          storage.ref().child(folderName).child(auth.currentUser!.uid);
      if (isPost) {
        String postId = Uuid().v4();
        ref = ref.child(postId);
      }
      UploadTask uploadTask = ref.putData(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
