import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_vault_seller/core/data/model/user_model.dart';
import 'package:game_vault_seller/features/dashboard/data/account_model.dart';
import 'package:game_vault_seller/features/dashboard/data/services/image_supabase.dart';
import 'package:game_vault_seller/features/dashboard/domain/sale_repository.dart';
import 'package:game_vault_seller/features/dashboard/screens/blocs/account_state.dart';
import 'package:image_picker/image_picker.dart';

class AccountsCubit extends Cubit<AccountState> {
  final ImageService _imageSupabase = ImageService();
  final SaleRepository _saleRepository;

  AccountsCubit(this._saleRepository) : super(AccountInitial());

  Future<void> loadAccounts() async {
    emit(AccountLoading());
    try {
      final List<AccountModel> accounts = await _saleRepository.getAccounts();

      emit(AccountLoaded(accounts: accounts));
    } catch (e) {
      emit(AccountError('Failed to load accounts'));
    }
  }

  Future<void> addAccount({
    required String accountName,
    required String accountDescription,
    required double price,
    List<XFile>? images,
    required UserModel user,
  }) async {
    emit(AccountLoading());
    try {
      // giving it a perfect .99 ending
      final taxedPrice =
          (price > 500 ? price + 50 : price + (price * 0.1)).ceilToDouble() -
          0.01;

      List<String> imageUrls = [];
      if (images != null) {
        for (var image in images) {
          final url = await _imageSupabase.uploadXFile(
            image,
            '${user.uid}/${accountName.replaceAll(' ', '_')}${DateTime.now().millisecondsSinceEpoch}',
          );
          imageUrls.add(url);
        }
      }

      final account = AccountModel(
        sellerName: user.username,
        accountTitle: accountName,
        accountDescription: accountDescription,
        price: taxedPrice,
        rating: user.rating,
        salesCount: user.totalSales,
        imageUrls: imageUrls,
        accountId: '${user.uid}_${DateTime.now().millisecondsSinceEpoch}',
      );
      await _saleRepository.addAccount(account);

      await loadAccounts(); // Reload accounts after adding a new one
    } catch (e) {
      emit(AccountError('Failed to add account'));
    }
  }

  Future<void> deleteAccount(AccountModel account) async {
    emit(AccountLoading());
    try {
      await _saleRepository.deleteAccount(account);
      await loadAccounts(); // Reload accounts after deletion
    } catch (e) {
      emit(AccountError('Failed to delete account'));
    }
  }
}
