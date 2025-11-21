import 'package:game_vault_seller/core/widgets/app_version/data/model/app_version.dart';
import 'package:http/http.dart' as http;

class VersionRepository {
  Future<AppVersion> _getAppVersion() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const AppVersion(version: '1.0.1', buildNumber: '100');
  }

  Future<AppVersion> _getLatestAppVersion() async {
    final versionUrl = Uri.parse(
      "https://raw.githubusercontent.com/Wandilekubheka/game-vault-release/refs/heads/main/termsAndPolicy/versionSeller.json",
    );
    final response = await http.get(versionUrl);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final json = response.body;
      return AppVersion.fromJson(json);
    } else {
      throw Exception('Failed to load latest app version');
    }
  }

  Future<bool> isUpdateAvailable() async {
    final currentVersion = await _getAppVersion();
    final latestVersion = await _getLatestAppVersion();

    return currentVersion != latestVersion;
  }
}
