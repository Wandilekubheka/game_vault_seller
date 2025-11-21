import 'package:game_vault_seller/core/data/model/user_model.dart';

abstract class AuthRepository {
  Future<void> deleteUserData();
  Future<void> signInWithEmail(String email, String password);
  Future<void> signOut();

  Future<void> sendEmailVerification();
  Future<UserModel> getCurrentUser();
  Future<void> createUserData(String username);
  Future<void> updateUserData(UserModel user);
}
