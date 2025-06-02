// lib/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import '../widgets/common/reading_dashboard.dart';
import '../services/google_books_service.dart';

/// 儀表板頁面
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key, this.animationController}) : super(key: key);
  
  final AnimationController? animationController;

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<BookModel> recommendedBooks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecommendedBooks();
  }

  /// 載入推薦書籍
  void _loadRecommendedBooks() async {
    try {
      // 載入一些推薦書籍
      final books = await GoogleBooksService.searchBooks(
        query: 'personal development',
        maxResults: 10,
      );
      
      setState(() {
        recommendedBooks = books;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            // 頂部應用欄
            _buildAppBarUI(),
            
            // 可滾動內容區域
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // 主要儀表板
                    if (isLoading)
                      _buildLoadingWidget()
                    else
                      ReadingDashboard(
                        completedBooks: 127,
                        readingTimeMinutes: 85,
                        pendingBooks: 73,
                        recommendedBooks: recommendedBooks,
                      ),
                    
                    // 額外的統計卡片
                    _buildAdditionalStats(),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 建構頂部應用欄
  Widget _buildAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white.withOpacity(0.9),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32.0),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppTheme.grey.withOpacity(0.4),
            offset: const Offset(1.1, 1.1),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '閱讀統計',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        letterSpacing: 1.2,
                        color: AppTheme.darkerText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 建構載入中組件
  Widget _buildLoadingWidget() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppTheme.grey.withOpacity(0.15),
            offset: const Offset(0, 4),
            blurRadius: 20.0,
          ),
        ],
      ),
      child: const Column(
        children: [
          CircularProgressIndicator(
            color: AppTheme.nearlyDarkBlue,
          ),
          SizedBox(height: 16),
          Text(
            '載入推薦書籍中...',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// 建構額外統計卡片
  Widget _buildAdditionalStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              title: '本月目標',
              value: '15',
              unit: '本書',
              progress: 0.7,
              color: const Color(0xFF4A90E2),
              icon: Icons.flag,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              title: '連續天數',
              value: '12',
              unit: '天',
              progress: 0.6,
              color: const Color(0xFF50C878),
              icon: Icons.local_fire_department,
            ),
          ),
        ],
      ),
    );
  }

  /// 建構統計卡片
  Widget _buildStatCard({
    required String title,
    required String value,
    required String unit,
    required double progress,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppTheme.grey.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppTheme.grey.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }
}