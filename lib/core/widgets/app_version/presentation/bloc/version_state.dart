class VersionState {}

class VersionInitial extends VersionState {}

class VersionLoading extends VersionState {}

class VersionLoaded extends VersionState {
  bool isUpToDate;

  VersionLoaded({required this.isUpToDate});
}

class VersionError extends VersionState {
  final String message;

  VersionError(this.message);
}
