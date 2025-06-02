// screens/profile_screen.dart

import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import '../utils/hex_color.dart';

/// 個人中心頁面
/// 
/// 功能包含：
/// - 個人資料展示
/// - 閱讀統計
/// - 書庫管理
/// - 設定選項
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, this.animationController}) : super(key: key);
  final AnimationController? animationController;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          controller: scrollController,
          slivers: [
            // 個人資料頭部
            _buildProfileHeader(),
            // 統計數據
            _buildStatsSection(),
            // 功能選項
            _buildFunctionsSection(),
          ],
        ),
      ),
    );
  }

  /// 建構個人資料頭部
  Widget _buildProfileHeader() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 20,
          left: 24,
          right: 24,
          bottom: 24,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.nearlyDarkBlue,
              HexColor('#8A98E8'),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
        child: Column(
          children: [
            // 頂部設定按鈕
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '個人中心',
                  style: TextStyle(
                    color: AppTheme.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.settings,
                    color: AppTheme.white,
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // 頭像和基本資訊
            Row(
              children: [
                // 頭像
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.white,
                      width: 3,
                    ),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: AppTheme.nearlyDarkBlue,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 20),
                // 使用者資訊
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '讀書愛好者',
                        style: TextStyle(
                          color: AppTheme.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'book_lover@email.com',
                        style: TextStyle(
                          color: AppTheme.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '加入 Book Me 已 180 天',
                        style: TextStyle(
                          color: AppTheme.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 建構統計數據區域
  Widget _buildStatsSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.grey.withOpacity(0.1),
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '我的閱讀統計',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkerText,
                  ),
                ),
                const SizedBox(height: 20),
                // 統計數據網格
                Row(
                  children: [
                    _buildStatItem('已讀書籍', '23', '本', Icons.menu_book),
                    _buildStatItem('閱讀時間', '156', '小時', Icons.access_time),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatItem('讀書筆記', '47', '篇', Icons.note_alt),
                    _buildStatItem('好友互動', '89', '次', Icons.favorite),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 建構單個統計項目
  Widget _buildStatItem(String title, String value, String unit, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppTheme.nearlyDarkBlue,
              size: 24,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkerText,
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 建構功能選項區域
  Widget _buildFunctionsSection() {
    return SliverList(
      delegate: SliverChildListDelegate([
        const SizedBox(height: 8),
        _buildFunctionGroup('我的書庫', [
          _buildFunctionItem('收藏書籍', Icons.bookmark, () {}),
          _buildFunctionItem('閱讀進度', Icons.timeline, () {}),
          _buildFunctionItem('讀書筆記', Icons.note_alt, () {}),
        ]),
        _buildFunctionGroup('社群互動', [
          _buildFunctionItem('我的貼文', Icons.post_add, () {}),
          _buildFunctionItem('好友列表', Icons.people, () {}),
          _buildFunctionItem('互動記錄', Icons.favorite, () {}),
        ]),
        _buildFunctionGroup('設定', [
          _buildFunctionItem('個人資料', Icons.person, () {}),
          _buildFunctionItem('隱私設定', Icons.security, () {}),
          _buildFunctionItem('通知設定', Icons.notifications, () {}),
          _buildFunctionItem('關於應用', Icons.info, () {}),
        ]),
        const SizedBox(height: 100), // 底部留白
      ]),
    );
  }

  /// 建構功能群組
  Widget _buildFunctionGroup(String title, List<Widget> items) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.grey.withOpacity(0.1),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkerText,
                ),
              ),
            ),
            ...items,
          ],
        ),
      ),
    );
  }

  /// 建構功能選項項目
  Widget _buildFunctionItem(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.nearlyDarkBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppTheme.nearlyDarkBlue,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppTheme.darkerText,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppTheme.grey,
            ),
          ],
        ),
      ),
    );
  }
}