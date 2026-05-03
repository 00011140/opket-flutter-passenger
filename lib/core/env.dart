class Env {
  static late Environment env;

  static void init(Environment environment) {
    env = environment;
  }

  static const _baseUrls = {
    Environment.dev: "http://192.168.1.106:3000",
    Environment.prod: "https://opketme.uz/api",
  };

  static String get baseUrl => _baseUrls[env]!;

  static bool get isDev => Env.env == Environment.dev;
}

enum Environment { dev, prod }
