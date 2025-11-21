import 'package:game_vault_seller/features/dashboard/data/account_model.dart';

class AccountState {}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountLoaded extends AccountState {
  final List<AccountModel> accounts;
  AccountLoaded({required this.accounts});
}

class AccountError extends AccountState {
  final String message;
  AccountError(this.message);
}
