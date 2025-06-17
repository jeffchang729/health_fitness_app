// lib/features/home/screen_controller.dart

import '../../core/models/tab_icon_data.dart';
import '../search/search_screen.dart';
import '../profile/profile_screen.dart';
import '../chat/chat_screen.dart';
import 'package:flutter/material.dart';
import '../../core/widgets/bottom_bar_view.dart';
import '../../core/config/app_theme.dart';
import 'home_screen.dart';

/// 畫面控制器
///
/// 管理整個應用程式的畫面切換和導航邏輯
class ScreenController extends StatefulWidget {
  const ScreenController({super.key});

  @override
  _ScreenControllerState createState() => _ScreenControllerState();
}

class _ScreenControllerState extends State<ScreenController>
    with TickerProviderStateMixin {
  /// 頁面切換動畫控制器
  AnimationController? animationController;

  /// 底部導航資料清單
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  /// 當前顯示的頁面內容
  Widget tabBody = Container(
    color: AppTheme.background,
  );

  @override
  void initState() {
    // 初始化導航狀態 - 預設選中第一個分頁（首頁）
    for (var tab in tabIconsList) {
      tab.isSelected = false;
    }
    tabIconsList[0].isSelected = true;

    // 初始化動畫控制器
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    // 設定預設頁面為首頁
    tabBody = HomeScreen(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody, // 當前選中的頁面內容
                  bottomBar(), // 底部導航列
                ],
              );
            }
          },
        ),
      ),
    );
  }

  /// 異步獲取資料（模擬載入延遲）
  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  /// 建構底部導航列
  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {
            // 中央添加按鈕功能
            _showAddDialog();
          },
          changeIndex: (int index) {
            _handleTabChange(index);
          },
        ),
      ],
    );
  }

  /// 處理分頁切換邏輯
  ///
  /// 根據選中的索引切換到對應的頁面
  void _handleTabChange(int index) {
    if (!mounted) return;

    animationController?.reverse().then<dynamic>((data) {
      if (!mounted) return;

      setState(() {
        switch (index) {
          case 0: // 首頁動態流
            tabBody = HomeScreen(animationController: animationController);
            break;
          case 1: // 搜尋功能
            tabBody = SearchScreen(animationController: animationController);
            break;
          case 2: // 聊天互動
            tabBody = ChatScreen(animationController: animationController);
            break;
          case 3: // 個人中心
            tabBody = ProfileScreen(animationController: animationController);
            break;
        }
      });
    });
  }

  /// 顯示新增內容對話框
  ///
  /// 中央添加按鈕被點擊時的功能
  void _showAddDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // 拖拉指示器
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: AppTheme.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // 標題
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                '新增內容',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkerText,
                ),
              ),
            ),
            // 內容區域（可根據需求自訂）
            const Expanded(
              child: Center(
                child: Text(
                  '功能開發中...',
                  style: TextStyle(
                    color: AppTheme.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}