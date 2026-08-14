import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class ProfileService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _usersCollection {
    return _firestore.collection('users');
  }

  // Get the currently authenticated user's UID.
  String _getCurrentUid() {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No authenticated user found.');
    }

    return user.uid;
  }

  // Create a profile for the currently authenticated user.
  Future<void> createProfile({
    required String name,
    required String email,
    String? phone,
    String? photoUrl,
  }) async {
    final uid = _getCurrentUid();

    final userModel = UserModel(
      uid: uid,
      name: name.trim(),
      email: email.trim(),
      phone: phone?.trim(),
      photoUrl: photoUrl,
    );

    await _usersCollection.doc(uid).set({
      ...userModel.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get the currently authenticated user's profile.
  Future<UserModel?> getProfile() async {
    final uid = _getCurrentUid();

    final document = await _usersCollection
        .doc(uid)
        .get();

    if (!document.exists || document.data() == null) {
      return null;
    }

    return UserModel.fromMap(document.data()!);
  }

  // Update the currently authenticated user's profile.
  Future<void> updateProfile({
    String? name,
    String? phone,
    String? photoUrl,
  }) async {
    final uid = _getCurrentUid();

    final Map<String, dynamic> updates = {
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (name != null) {
      updates['name'] = name.trim();
    }

    if (phone != null) {
      updates['phone'] = phone.trim();
    }

    if (photoUrl != null) {
      updates['photoUrl'] = photoUrl;
    }

    await _usersCollection
        .doc(uid)
        .update(updates);
  }
}