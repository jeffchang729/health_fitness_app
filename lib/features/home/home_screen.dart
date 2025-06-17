// lib/features/home/home_screen.dart

import '../../core/widgets/progress_view.dart';
import '../../core/widgets/suggestion_view.dart';
import '../../core/widgets/stats_view.dart';
import '../../core/widgets/title_view.dart';
import '../../core/config/app_theme.dart';
import '../../core/widgets/book_recommendations_view.dart';
import '../../core/widgets/companion_view.dart';
import 'social_feed_screen.dart';
import 'package:flutter/material.dart';

/// 首頁畫面 - 包含IG風格社群動態和個人統計
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  /// 頁面控制器
  PageController pageController = PageController();

  /// 當前頁面索引
  int currentPageIndex = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            // 頂部分頁切換
            _buildTabSelector(),
            // 頁面內容
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentPageIndex = index;
                  });
                },
                children: [
                  // IG風格社群動態
                  SocialFeedScreen(animationController: widget.animationController),
                  // 個人統計頁面
                  _buildPersonalStatsPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 建構分頁選擇器
  Widget _buildTabSelector() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 8,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.white,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.background,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // 社群動態標籤
          Expanded(
            child: GestureDetector(
              onTap: () {
                pageController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: currentPageIndex == 0
                          ? AppTheme.nearlyDarkBlue
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people,
                      color: currentPageIndex == 0
                          ? AppTheme.nearlyDarkBlue
                          : AppTheme.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '社群動態',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: currentPageIndex == 0
                            ? AppTheme.nearlyDarkBlue
                            : AppTheme.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 個人統計標籤
          Expanded(
            child: GestureDetector(
              onTap: () {
                pageController.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: currentPageIndex == 1
                          ? AppTheme.nearlyDarkBlue
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.analytics,
                      color: currentPageIndex == 1
                          ? AppTheme.nearlyDarkBlue
                          : AppTheme.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '我的統計',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: currentPageIndex == 1
                            ? AppTheme.nearlyDarkBlue
                            : AppTheme.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 建構個人統計頁面
  Widget _buildPersonalStatsPage() {
    return PersonalStatsScreen(animationController: widget.animationController);
  }
}

/// 個人統計頁面
class PersonalStatsScreen extends StatefulWidget {
  const PersonalStatsScreen({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;

  @override
  _PersonalStatsScreenState createState() => _PersonalStatsScreenState();
}

class _PersonalStatsScreenState extends State<PersonalStatsScreen>
    with TickerProviderStateMixin {
  /// 頁面內容元件清單
  List<Widget> listViews = <Widget>[];

  /// 滾動控制器
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 添加所有頁面內容
    addAllListData();
  }

  /// 添加所有頁面內容元件
  void addAllListData() {
    const int count = 9;

    // 1. 今日統計區標題
    listViews.add(
      TitleView(
        titleTxt: '今日狀況',
        subTxt: '查看詳情',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                const Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );

    // 2. 今日統計卡片
    listViews.add(
      StatsView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                const Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );

    // 3. 推薦內容區標題
    listViews.add(
      TitleView(
        titleTxt: '為你推薦',
        subTxt: '探索更多',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                const Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );

    // 4. 推薦內容橫向滾動區
    listViews.add(
      BookRecommendationsView(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController!,
                curve: const Interval((1 / count) * 3, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
      ),
    );

    // 5. 個人進度標題
    listViews.add(
      TitleView(
        titleTxt: '本月進度',
        subTxt: '今日',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                const Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );

    // 6. 個人進度統計卡片
    listViews.add(
      ProgressView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                const Interval((1 / count) * 5, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );

    // 7. AI助手標題
    listViews.add(
      TitleView(
        titleTxt: 'AI 助手',
        subTxt: '智慧陪伴',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                const Interval((1 / count) * 6, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );

    // 8. AI助手互動視圖
    listViews.add(
      CompanionView(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController!,
                curve: const Interval((1 / count) * 7, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController!,
      ),
    );

    // 9. 今日建議提示卡片
    listViews.add(
      SuggestionView(
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: widget.animationController!,
                  curve: const Interval((1 / count) * 8, 1.0,
                      curve: Curves.fastOutSlowIn))),
          animationController: widget.animationController!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.only(
            top: 16,
            bottom: 24,
          ),
          itemCount: listViews.length,
          itemBuilder: (context, index) {
            widget.animationController?.forward();
            return listViews[index];
          },
        ),
      ),
    );
  }
}