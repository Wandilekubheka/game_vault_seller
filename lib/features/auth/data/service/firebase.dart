import 'package:firebase_auth/firebase_auth.dart';
import 'package:game_vault_seller/core/data/model/firebase_expection.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseService _instance = FirebaseService._internal();
  FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  // Sign in with email and password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Register with email and password
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print("Error registering: $e");
      rethrow;
    }
  }

  Future<void> updateUserProfile(String? username) async {
    try {
      await _auth.currentUser?.updateDisplayName(username);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> deleteUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.delete();
        return user.uid;
      } else {
        throw FormatException("No authenticated user to delete");
      }
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler(e.code);
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception("No authenticated user found");
      }
      await user.sendEmailVerification();
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler(e.code);
    }
  }
}
