import 'package:get/get.dart';

// 1. (核心)
//    你的翻译类必须 "extends Translations"
class AppTranslations extends Translations {

  // 2. (核心)
  //    "keys" 是一个 Map<String, Map<String, String>>
  //    - 第一个 String: 语言代码 (例如 'en_US' 或 'zh_CN')
  //    - 第二个 Map:   是这个语言对应的 "翻译键" -> "值"
  @override
  Map<String, Map<String, String>> get keys => {

    // --- 中文 (简体, 中国) ---
    'zh_CN': {
      // 登录页
      'login_welcome': '欢迎登录',
      'login_username': '用户名',
      'login_password': '密码',
      'login_button': '登 录',
      'login_error_empty': '此字段不能为空',
      'login_error_min_length': '密码必须大于6位',
      'login_error_max_length': '密码必须小于10位',
      'login_error_api_default': '登录失败，请重试',

      // 个人中心页
      'profile_title': '个人中心',
      'profile_change_language': '切换语言',
      'profile_switch_to_en': '切换到英文',
      'profile_switch_to_zh': '切换到中文',
      'profile_logout': '退出登录',
      'input_username':'请输入用户名',
      'input_cant_be_empty':'用户名输入不能为空',

      'password_cant_be_empty':'密码不能为空',
      'password_length_error1':'密码必须大于等于6位',
      'password_length_error2':'密码必须小于等于10位',
      'splash_skip': 'Jump @count s',

    },

    // --- 英文 (美国) ---
    'en_US': {
      // 登录页
      'login_welcome': 'Welcome Back',
      'login_username': 'Username',
      'login_password': 'Password',
      'login_button': 'LOGIN',
      'login_error_empty': 'This field cannot be empty',
      'login_error_min_length': 'Password must be >= 6 chars',
      'login_error_max_length': 'Password must be <= 10 chars',
      'login_error_api_default': 'Login failed, please try again',

      // 个人中心页
      'profile_title': 'Profile',
      'profile_change_language': 'Change Language',
      'profile_switch_to_en': 'Switch to English',
      'profile_switch_to_zh': 'Switch to Chinese',
      'profile_logout': 'Logout',
      'input_username':'Input UserName',
      'input_cant_be_empty':'User Name cant be empty',
      'password_cant_be_empty':'Password cant be empty',
      'password_length_error1':'Password must be >= 6 chars',
      'password_length_error2':'Password must be <= 10 chars',
      //    为你之前的 "跳过..." 添加一个 Key
      //    并使用 "count" (你可以任意命名) 作为占位符
      'splash_skip': 'Jump @count s',
    },

  };
}