// (核心)
// 这是一个"单一"的构建器, 你的"脚手架"中的所有 Logic 都可以用它
// 来构建 POST 的 body 或 GET 的 query map。

class ApiParamsBuilder {
  // 1. 内部持有一个 Map,
  //    final 确保它只能在类内部被修改
  final Map<String, dynamic> _params = {};

  // 2. (核心)
  //    一个私有的辅助方法, 负责 *安全* 地添加参数
  //    它会自动忽略 null, 这样你就不用在 Logic 里写 if (search != null) 了
  void _add(String key, dynamic value) {
    if (value != null) {
      if (value is String && value.isEmpty) {
        // (可选) 你甚至可以增加逻辑: 连空字符串也忽略
        return;
      }
      _params[key] = value;
    }
  }

  ApiParamsBuilder page(int? page) {
    _add('page', page);
    return this;
  }


  ApiParamsBuilder username(String? email) {
    _add('username', email);
    return this;
  }

  ApiParamsBuilder password(String? password) {
    _add('password', password);
    return this;
  }


  // --- 4. (核心) 最终的 "build" 方法 ---
  /// 返回构建好的 Map<String, dynamic>
  Map<String, dynamic> build() {
    return _params;
  }
}
