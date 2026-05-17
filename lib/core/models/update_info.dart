class UpdateInfo {
  final bool isAvailable;
  final bool isMandatory;

  const UpdateInfo({required this.isAvailable, required this.isMandatory});

  static const none = UpdateInfo(isAvailable: false, isMandatory: false);
}
