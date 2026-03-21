class AdminEnv {
  static late AdminEnvironment env;

  static void init(AdminEnvironment environment) {
    env = environment;
  }

  static const _baseUrls = {
    AdminEnvironment.dev: "http://192.168.1.100:4000",
    AdminEnvironment.prod: "https://admin.opketme.uz/api",
  };

  static String get baseUrl => _baseUrls[env]!;

  static bool get isDev => AdminEnv.env == AdminEnvironment.dev;
}

enum AdminEnvironment { dev, prod }
