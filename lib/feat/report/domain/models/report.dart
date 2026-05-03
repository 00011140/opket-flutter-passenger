class Report {
  final bool notificationEnabled;
  final String appVersion;

  Report({required this.notificationEnabled, required this.appVersion});

  Map<String, dynamic> toMap() {
    return {
      'notificationEnabled': notificationEnabled,
      'appVersion': appVersion,
    };
  }
}
