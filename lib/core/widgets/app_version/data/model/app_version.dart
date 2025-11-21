import 'dart:convert';

class AppVersion {
  const AppVersion({required this.version, required this.buildNumber});

  final String version;
  final String buildNumber;

  factory AppVersion.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return AppVersion(
      version: json['version'] as String,
      buildNumber: json['build'] as String,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppVersion &&
          runtimeType == other.runtimeType &&
          version == other.version &&
          buildNumber == other.buildNumber;

  @override
  int get hashCode => version.hashCode ^ buildNumber.hashCode;

  @override
  String toString() {
    return 'AppVersion{version: $version, buildNumber: $buildNumber}';
  }
}
