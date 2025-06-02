// main.dart

import 'dart:io';
import 'themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/screen_controller.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// 應用程式主入口點
void main() async {
  // 確保 Flutter 框架已初始化
  WidgetsFlutterBinding.ensureInitialized();
  
  // 設定裝置方向為僅支援直向
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(const MyApp()));
}

/// 應用程式主類別
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 設定系統 UI 樣式
    _configureSystemUI();
    
    return MaterialApp(
      title: 'Reading Community App',
      debugShowCheckedModeBanner: false,
      theme: _buildAppTheme(),
      home: const ScreenController(),
    );
  }

  /// 設定系統 UI 樣式（狀態列、導航列等）
  void _configureSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
  }

  /// 建立應用程式主題
  ThemeData _buildAppTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      textTheme: AppTheme.textTheme,
      platform: TargetPlatform.iOS,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }
}