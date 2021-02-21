import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_odev/models/post.dart';
import 'package:flutter_odev/models/user.dart';


class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference collection = Firestore.instance.collection('users');

  // Post list from snapshot

  List<Post> _postListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Post.fromFirestore(doc);
    }).toList();
  }

  // get all posts
  Stream<List<Post>> get posts {
    return Firestore.instance
        .collectionGroup('posts')
        .snapshots()
        .map(_postListFromSnapshot);
  }

  // get individual user posts
  Stream<List<Post>> get individualPosts {
    return collection
        .document(uid)
        .collection('posts')
        .snapshots()
        .map(_postListFromSnapshot);
  }

  Future registerUser(String uid, String name, String email) async {
    try {
      return await collection.document(uid).setData({
        "name": name,
        "email": email,
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Hata oluştu!! : $e');
    }
  }

  Future getProfile(String uid) async {
    try {
      DocumentSnapshot result =
          await Firestore.instance
          .collection('users')
          .document(uid)
          .get();

          if(result.exists) {
            return User.fromFirestore(result);
          }
    } catch (e) {
      print('Hata oluştu!! : $e');
    }
  }

  Future editProfile(String uid, String name, String userImage) async {
    try {
      return await collection.document(uid).setData({
        "name": name,
        "userImage" : userImage,
        "updatedAt": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Hata oluştu!! : $e');
    }
  }

  Future createPost(String uid, String title, String content) async {
    try {
      await collection.document(uid).collection('posts').document().setData({
        "title": title,
        "content": content,
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      });
      return uid;
    } catch (e) {
      print('Hata oluştu!! : $e');
    }
  }

  Future deletePost(
    String id,
  ) async {
    try {
      return await collection
          .document(uid)
          .collection('posts')
          .document(id)
          .delete();
    } catch (e) {
      print('Hata oluştu!! : $e');
      return null;
    }
  }

  Future editPost(String id, String title, String content) async {
    try {
      await collection.document(uid).collection('posts').document(id).setData({
        "title": title,
        "content": content,
        "updatedAt": FieldValue.serverTimestamp(),
      });
      return uid;
    } catch (e) {
      print('Hata oluştu!! : $e');
      return null;
    }
  }
}
