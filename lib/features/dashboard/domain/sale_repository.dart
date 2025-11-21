import 'package:game_vault_seller/features/dashboard/data/account_model.dart';

abstract class SaleRepository {
  Future<void> addAccount(AccountModel account);

  Future<List<AccountModel>> getAccounts();

  Future<void> deleteAccount(AccountModel account);
}
