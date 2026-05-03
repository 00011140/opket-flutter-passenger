import 'package:opket/core/admin_env.dart';
import 'package:opket/core/env.dart';
import 'main.dart';

void main() async {
  Env.init(Environment.dev);
  AdminEnv.init(AdminEnvironment.dev);
  await startApp();
}

// Ilovadan foydalanish uchun quyidagilarni yoqing
// Lokatsiya - Yoqish
// Manzilingizni aniqlash uchun

// Bildirishnoma - Yoqish
// Sizga xabar yuborish uchun

// 1. Route animation
// 2. Map styling Passenger app, the pin as wellp
// 3. Driver Map navigation
// 4. Driver app, ride cancellation
// 5. Fare display passenger app
// 6. Ride completion passenger app

// CURRENT ISSUES
// 1. Inform passenger via FCM, ride accepted
// 2. if user requests and exits app, when user reopens app, refetch ride
// 3. When ride started, show the current fare, km and update fare live
// 4. When ride finsihed inform passenger

// EXCEPTION
// [ERROR:flutter/runtime/dart_vm_initializer.cc(40)] Unhandled Exception:
// PlatformException(recreating_view, trying to create an already created view, 
//view id: '0', null)