

abstract class AppRoutes {

  // 定义路由名称为常量
  static const splash = '/splash'; // 根目录, 作为闪屏页
  static const authLogin = '/authLogin'; // 登录页
  static const shell = '/shell'; // App 框架 (带底部导航)

  // 你可以为 Shell 内部的页面也定义路由
  static const home = '/home';
  static const list = '/list';
  static const profile = '/profile';

  static const sendEvent = '/sendEvent';

}
