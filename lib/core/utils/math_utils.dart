// lib/core/utils/math_utils.dart (最终版)

import 'package:big_decimal/big_decimal.dart';

// (核心) 
// 1. 
//    我们*导出* (export) 
//    这个库, 
//    这样你的 Logic 
//    文件
//    只需要 *import 'math_utils.dart'* //    
//    就可以*同时*获得 
//    BigDecimal 
//    类和你的扩展
export 'package:big_decimal/big_decimal.dart';

// --- (A) 
//     构造器 (Constructors) 
//     (不变) ---
//     (来自你上传的文件 
//    )
extension StringMoneyExtension on String {
  BigDecimal toBd() {
    return BigDecimal.parse(this);
  }
}

extension IntMoneyExtension on int {
  BigDecimal toBd() {
    return BigDecimal.parse(toString());
  }
}

extension DoubleMoneyExtension on double {
  BigDecimal toBd() {
    return BigDecimal.parse(toString());
  }
}


// --- (B) 
//     (!! 
//     核心新增 
//     !!) 
//     操作器 (Operations) ---
//
// (我们*扩展* 'BigDecimal' 
//  类本身)
extension BigDecimalMoneyExtension on BigDecimal {

  // (私有) 
  //    创建一个'1'
  //    , 
  //    用于 'divide' 
  //    (除法) 
  //    技巧
  static final BigDecimal _one = BigDecimal.parse('1');

  /// (核心) 
  /// 1. 
  ///    (你的需求) 
  ///    "保留几位小数" 
  ///    (setScale)
  ///    
  ///    (默认使用"四舍五入")
  /// 
  /// 用法: 
  /// myValue.setScale(2)
  BigDecimal setScale(
      int scale, {
        RoundingMode roundingMode = RoundingMode.HALF_UP,
      }) {
    // (核心) 
    //    我们*封装*了那个"除以1"
    //    的技巧
    return divide(
      _one,
      scale: scale,
      roundingMode: roundingMode,
    );
  }

  /// (核心) 
  /// 2. 
  ///    (你的需求) 
  ///    "直接截取" 
  ///    (Truncate)
  /// 
  /// 用法: 
  /// myValue.truncate(2)
  BigDecimal truncate(int scale) {
    // (核心) 
    //    这只是 setScale 
    //    的一个"快捷方式"
    return setScale(scale, roundingMode: RoundingMode.DOWN);
  }

// (你还可以继续添加...)
// bool isGreaterThan(BigDecimal other) {
//   return this > other;
// }
}