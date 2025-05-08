class Partner {
  final String appName;
  final String appKey;
  final String env;

  Partner(
    this.appName,
    this.appKey,
    this.env
  );

  Partner.fromJson(Map<String, dynamic> json)
      : appName = json['app_name'],
        appKey = json['app_key'],
        env = json['environment'];
}