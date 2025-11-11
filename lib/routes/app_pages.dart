import 'package:dev_lib_getx/features/login/login_binding.dart';
import 'package:dev_lib_getx/features/login/login_page.dart';
import 'package:dev_lib_getx/features/shell/shell_binding.dart';
import 'package:dev_lib_getx/features/shell/shell_page.dart';
import 'package:get/get.dart';

import '../features/splash/splash_binding.dart';
import '../features/splash/splash_page.dart';
import 'app_routes.dart';


class AppPages {

  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.splash, // 路由名称 '/
      page: () => SplashPage(), // 对应的页面
      binding: SplashBinding(), // (关键) 对应的 Binding
    ),

    GetPage(
      name: AppRoutes.authLogin,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),

    GetPage(
      name: AppRoutes.shell,
      page: () => ShellPage(),
      binding: ShellBinding(),
    ),
  ];
}
