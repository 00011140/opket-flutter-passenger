import 'package:opket/core/admin_env.dart';
import 'package:opket/core/env.dart';

import 'main.dart';

void main() async {
  Env.init(Environment.prod);
  AdminEnv.init(AdminEnvironment.prod);
  await startApp();
}
