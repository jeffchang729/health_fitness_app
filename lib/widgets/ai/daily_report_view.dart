// widgets/ai/daily_report_view.dart

import '../../themes/app_theme.dart';
import '../../utils/hex_color.dart';
import 'package:flutter/material.dart';

/// 每日報告視圖 - AI 生成的個人化分析報告
class DailyReportView extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const DailyReportView({Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [AppTheme.nearlyDarkBlue, HexColor("#6F56E8")],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: AppTheme.grey.withOpacity(0.6),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                        topRight: Radius.circular(68.0)),
                    onTap: () {
                      // TODO: 顯示完整報告
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // 標題區域
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppTheme.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.analytics_outlined,
                                  color: AppTheme.white,
                                  size: 28,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '今日分析報告',
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        letterSpacing: 0.0,
                                        color: AppTheme.white,
                                      ),
                                    ),
                                    Text(
                                      'AI 為你生成專屬洞察',
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12,
                                        letterSpacing: 0.0,
                                        color: AppTheme.white.withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: 20),
                          
                          // 統計數據區域
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildStatItem(
                                        '閱讀時間',
                                        '2.5小時',
                                        Icons.access_time,
                                        Colors.orange,
                                      ),
                                    ),
                                    Container(
                                      width: 1,
                                      height: 40,
                                      color: AppTheme.white.withOpacity(0.2),
                                    ),
                                    Expanded(
                                      child: _buildStatItem(
                                        '互動次數',
                                        '8次',
                                        Icons.favorite,
                                        Colors.pink,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildStatItem(
                                        '學習重點',
                                        '習慣養成',
                                        Icons.lightbulb,
                                        Colors.amber,
                                      ),
                                    ),
                                    Container(
                                      width: 1,
                                      height: 40,
                                      color: AppTheme.white.withOpacity(0.2),
                                    ),
                                    Expanded(
                                      child: _buildStatItem(
                                        '心情指數',
                                        '積極',
                                        Icons.mood,
                                        Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: 16),
                          
                          // AI 洞察摘要
                          Text(
                            'AI 洞察',
                            style: TextStyle(
                              fontFamily: AppTheme.fontName,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: AppTheme.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '今天你在閱讀「原子習慣」時表現出很高的專注度，特別關注習慣養成的實踐方法。建議明天可以嘗試將書中的一個小習慣應用到日常生活中。',
                            style: TextStyle(
                              fontFamily: AppTheme.fontName,
                              fontWeight: FontWeight.normal,
                              fontSize: 13,
                              letterSpacing: 0.0,
                              color: AppTheme.white.withOpacity(0.9),
                              height: 1.4,
                            ),
                          ),
                          
                          SizedBox(height: 20),
                          
                          // 查看完整報告按鈕
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '查看完整報告',
                                style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  letterSpacing: 0.0,
                                  color: AppTheme.white,
                                ),
                              ),
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppTheme.nearlyWhite,
                                  shape: BoxShape.circle,
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: AppTheme.nearlyBlack.withOpacity(0.4),
                                        offset: Offset(4.0, 4.0),
                                        blurRadius: 8.0),
                                  ],
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: HexColor("#6F56E8"),
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color iconColor) {
    return Column(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppTheme.white,
          ),
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w400,
            fontSize: 10,
            color: AppTheme.white.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}