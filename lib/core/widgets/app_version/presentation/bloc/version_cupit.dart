import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_vault_seller/core/widgets/app_version/data/repository/version_repository.dart';
import 'package:game_vault_seller/core/widgets/app_version/presentation/bloc/version_state.dart';

class VersionCupit extends Cubit<VersionState> {
  final VersionRepository versionRepository;
  VersionCupit(this.versionRepository) : super(VersionInitial());

  Future<void> checkForUpdate() async {
    emit(VersionLoading());
    try {
      final isUpdateAvailable = await versionRepository.isUpdateAvailable();
      emit(VersionLoaded(isUpToDate: !isUpdateAvailable));
    } catch (e) {
      emit(VersionError('Failed to check for updates'));
    }
  }
}
