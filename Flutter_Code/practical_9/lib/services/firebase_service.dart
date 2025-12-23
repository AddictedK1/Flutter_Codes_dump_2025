import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';

class FirebaseService {
  static final _firestore = FirebaseFirestore.instance;
  static final _storage = FirebaseStorage.instance;

  static Stream<List<Post>> postsStream() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Post.fromDocument(d)).toList());
  }

  static Future<String?> _uploadImage(XFile image) async {
    final id = const Uuid().v4();
    final ref = _storage.ref().child('post_images/$id');
    final file = File(image.path);
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    final url = await snapshot.ref.getDownloadURL();
    return url;
  }

  static Future<void> createPost({
    required String title,
    required String content,
    XFile? image,
  }) async {
    String? imageUrl;
    if (image != null) {
      imageUrl = await _uploadImage(image);
    }

    final doc = _firestore.collection('posts').doc();
    final post = Post(
      id: doc.id,
      title: title,
      content: content,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
    );

    await doc.set(post.toMap());
  }
}
