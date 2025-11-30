import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:game_vault_seller/core/data/model/firebase_expection.dart';
import 'package:game_vault_seller/features/dashboard/data/account_model.dart';
import 'package:game_vault_seller/features/dashboard/domain/sale_repository.dart';

class ImpSaleRepository extends SaleRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  @override
  Future<void> addAccount(AccountModel account) async {
    try {
      await _firestore.collection('accounts').add(account.toMap());
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler(e.code);
    } on Exception catch (e) {
      throw FormatException('an error occurred: ${e.toString()}');
    }
  }

  @override
  Future<List<AccountModel>> getAccounts() async {
    log(_auth.currentUser!.uid);
    try {
      final uid = _auth.currentUser!.uid;
      final snapshot = await _firestore
          .collection('accounts')
          .where('accountId', isGreaterThanOrEqualTo: uid)
          .where('accountId', isLessThanOrEqualTo: '$uid\uf8ff')
          .get();
      return snapshot.docs
          .map((doc) => AccountModel.fromMap(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler(e.code);
    } on Exception catch (e) {
      throw FormatException('an error occurred: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAccount(AccountModel account) async {
    try {
      // remove from Firestore
      final docID = await _firestore
          .collection('accounts')
          .where('accountId', isEqualTo: account.accountId)
          .get()
          .then((snapshot) {
            if (snapshot.docs.isNotEmpty) {
              return snapshot.docs.first.id;
            } else {
              throw Exception('Account not found');
            }
          });
      await _firestore.collection('accounts').doc(docID).delete();
      // update user's total accounts count
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'totalAccounts': FieldValue.increment(-1),
      });
    } on FirebaseException catch (e) {
      throw FirebaseExceptionHandler(e.code);
    } on Exception catch (e) {
      throw FormatException('an error occurred: ${e.toString()}');
    }
  }
}
