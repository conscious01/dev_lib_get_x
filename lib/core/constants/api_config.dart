class ApiConfig {
  // 私有构造, 防止被实例化
  ApiConfig._();

  static const String showLoading = "showLoading";
  static const String showToast = "showToast";

  static const String resCode = "code";
  static const String resData = "data";
  static const String resMsg = "msg";

  static const successCode = 200;

  static const String baseUrl = "http://192.168.1.69:3001";

  static const String authLogin = "/login";
}
