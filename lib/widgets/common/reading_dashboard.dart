// lib/widgets/common/reading_dashboard.dart

import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';

/// 閱讀統計儀表板組件 - 完全複製設計
class ReadingDashboard extends StatefulWidget {
  const ReadingDashboard({
    Key? key,
    this.completedBooks = 127,
    this.readingTimeMinutes = 85,
    this.pendingBooks = 73,
  }) : super(key: key);

  final int completedBooks;
  final int readingTimeMinutes;
  final int pendingBooks;

  @override
  _ReadingDashboardState createState() => _ReadingDashboardState();
}

class _ReadingDashboardState extends State<ReadingDashboard>
    with TickerProviderStateMixin {
  late AnimationController _progressAnimationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOut,
    ));

    _progressAnimationController.forward();
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8.0),
          bottomLeft: Radius.circular(8.0),
          bottomRight: Radius.circular(8.0),
          topRight: Radius.circular(68.0), // 特殊的右上角大圓角
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppTheme.grey.withOpacity(0.2),
            offset: const Offset(1.1, 1.1),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Column(
        children: [
          // 上半部：統計資訊和圓形進度
          Row(
            children: [
              // 左側統計
              Expanded(
                child: Column(
                  children: [
                    // 已完成統計
                    _buildStatItem(
                      icon: Icons.check_circle_outline,
                      color: const Color(0xFF6C7CE7),
                      title: '已完成',
                      value: widget.completedBooks,
                      unit: '項目',
                    ),
                    const SizedBox(height: 24),
                    // 使用時間統計
                    _buildStatItem(
                      icon: Icons.access_time,
                      color: const Color(0xFFFF6B9D),
                      title: '使用時間',
                      value: widget.readingTimeMinutes,
                      unit: '分鐘',
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 40),
              
              // 右側圓形進度
              _buildCircularProgress(),
            ],
          ),
          
          const SizedBox(height: 40),
          
          // 下半部：分類統計
          _buildCategoryStats(),
        ],
      ),
    );
  }

  /// 建構統計項目
  Widget _buildStatItem({
    required IconData icon,
    required Color color,
    required String title,
    required int value,
    required String unit,
  }) {
    return Row(
      children: [
        // 左側彩色邊線
        Container(
          width: 4,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 16),
        // 圖示
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(width: 12),
        // 文字內容
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.grey.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    value.toString(),
                    style: const TextStyle(
                      fontSize: 28,
                      color: AppTheme.darkerText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    unit,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.grey.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 建構圓形進度條
  Widget _buildCircularProgress() {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 背景圓圈
              const SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 8,
                  backgroundColor: Color(0xFFE8EAFF),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFFE8EAFF),
                  ),
                ),
              ),
              
              // 進度圓圈
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: _progressAnimation.value * 0.73, // 73%進度
                  strokeWidth: 8,
                  backgroundColor: Colors.transparent,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF6C7CE7),
                  ),
                ),
              ),
              
              // 中心數字
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    (widget.pendingBooks * _progressAnimation.value).round().toString(),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6C7CE7),
                    ),
                  ),
                  Text(
                    '項目待完成',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.grey.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// 建構分類統計
  Widget _buildCategoryStats() {
    final categories = [
      {
        'title': '分類一',
        'value': 3,
        'status': '項進行中',
        'color': const Color(0xFF6C7CE7),
      },
      {
        'title': '分類二',
        'value': 1,
        'status': '項已完成',
        'color': const Color(0xFFFF6B9D),
      },
      {
        'title': '分類三',
        'value': 2,
        'status': '項待完成',
        'color': const Color(0xFFFFB347),
      },
    ];

    return Row(
      children: categories.map((category) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 分類標題
                Text(
                  category['title'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.darkerText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                
                // 進度條
                Container(
                  width: double.infinity,
                  height: 6,
                  decoration: BoxDecoration(
                    color: (category['color'] as Color).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (category['value'] as int) / 4.0, // 相對進度
                    child: Container(
                      decoration: BoxDecoration(
                        color: category['color'] as Color,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // 狀態文字
                Text(
                  '${category['value']}${category['status']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.grey.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}