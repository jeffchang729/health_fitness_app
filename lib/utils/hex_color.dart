import 'dart:ui';

/// 十六進位顏色轉換工具類別
/// 
/// 將十六進位字串轉換為 Flutter Color 物件
class HexColor extends Color {
  /// 從十六進位字串建立顏色
  /// 
  /// 支援格式：
  /// - "#RRGGBB" (如: "#FF0000")
  /// - "#AARRGGBB" (如: "#80FF0000")
  /// - "RRGGBB" (如: "FF0000")
  /// - "AARRGGBB" (如: "80FF0000")
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  /// 將十六進位字串轉換為顏色值
  static int _getColorFromHex(String hexColor) {
    // 移除 # 符號（如果存在）
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    
    // 如果只有 6 位數，自動加上 FF 作為 alpha 值
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    
    // 轉換為整數並返回
    return int.parse(hexColor, radix: 16);
  }

  /// 建立帶有指定透明度的顏色
  /// 
  /// [opacity] 透明度值，範圍 0.0-1.0
  HexColor withOpacity(double opacity) {
    return HexColor('#${(opacity * 255).toInt().toRadixString(16).padLeft(2, '0')}${value.toRadixString(16).substring(2)}');
  }

  /// 將顏色轉換為十六進位字串
  String toHexString({bool includeAlpha = true}) {
    if (includeAlpha) {
      return '#${value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
    } else {
      return '#${value.toRadixString(16).substring(2).padLeft(6, '0').toUpperCase()}';
    }
  }
}