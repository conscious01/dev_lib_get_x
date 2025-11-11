import 'package:dev_lib_getx/core/lang/app_translations.dart';
import 'package:dev_lib_getx/core/services/app_data_service.dart';
import 'package:dev_lib_getx/core/services/dio_service.dart';
import 'package:dev_lib_getx/routes/app_pages.dart';
import 'package:dev_lib_getx/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'core/repository/app_network.dart';
import 'core/services/logger_service.dart';
import 'core/services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(LoggerService(), permanent: true);
  await Get.putAsync(() => StorageService().init());

  await Get.putAsync(() => AppDataService(storage: Get.find()).init(),
      permanent: true);


  Get.put(DioService(storage: Get.find()), permanent: true);
  Get.put(
      AppNetwork(),
      permanent: true
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true, // (推荐) 文本是否也按照屏幕宽度缩放
        splitScreenMode: true, // (推荐) 支持分屏模式
        builder: (context, child) {
          return GetMaterialApp(
            translations: AppTranslations(),
            // 3. 设置默认语言 (推荐: 使用 Get.deviceLocale)
            //    Get.deviceLocale 会自动检测用户的*系统语言*
            locale: Get.deviceLocale,

            // (你也可以硬编码一个, 比如 Locale('zh', 'CN'))

            // 4. 设置“回退”语言
            //    (如果用户的系统语言是 'ja_JP' (日语),
            //    但你的 keys 里没有, GetX 会自动使用这个)
            fallbackLocale: const Locale('zh', 'CN'),
            builder: (context, widget) {
              return MediaQuery(
                //(重要) 设置全局字体缩放为 1.0,
                //       防止系统字体大小影响 .sp 缩放
                data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
                child: widget!,
              );
            },
            title: 'DevLibGetX',
            initialRoute: AppRoutes.splash,
            theme: ThemeData(primarySwatch: Colors.blue),
            getPages: AppPages.routes,
            // home: MyHomePage(),
          );
        }
    );
  }
}
