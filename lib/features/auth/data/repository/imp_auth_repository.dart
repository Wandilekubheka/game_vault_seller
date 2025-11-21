import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:game_vault_seller/core/data/model/firebase_expection.dart';
import 'package:game_vault_seller/core/data/model/user_model.dart';
import 'package:game_vault_seller/features/auth/data/service/firebase.dart';
import 'package:game_vault_seller/features/auth/domain/reporitory.dart';

class ImpAuthRepository implements AuthRepository {
  final FirebaseService _firebaseService;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  ImpAuthRepository(this._firebaseService, this._firestore);

  @override
  Future<void> signInWithEmail(String email, String password) async {
    try {
      final user = await _firebaseService.signInWithEmail(email, password);
      if (user == null) {
        throw Exception("User sign-in failed");
      }
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler(e.code);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseService.signOut();
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler(e.code);
    }
  }

  @override
  Future<void> deleteUserData() async {
    try {
      // get uid from firebase service to avoid mismatch
      final String uid = await _firebaseService.deleteUserData();
      await _firestore.collection('users').doc(uid).delete();
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler(e.code);
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FormatException("No authenticated user");
    }

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) {
      throw FormatException("User data not found");
    }
    return UserModel.fromMap(doc.data()!);
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      await _firebaseService.sendEmailVerification();
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler(e.code);
    }
  }

  @override
  Future<void> createUserData(String username) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception("No authenticated user found");
      }

      final appUser = UserModel.fromFirebaseUser(user, username);
      await user.updateDisplayName(username);
      await _firestore.collection('users').doc(user.uid).set(appUser.toMap());
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler(e.code);
    }
  }

  @override
  Future<void> updateUserData(UserModel user) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("No authenticated user found");
      }

      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .update(user.toMap());
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler(e.code);
    }
  }
}
