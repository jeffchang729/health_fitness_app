// widgets/search/ai_recommendation_view.dart

import '../../themes/app_theme.dart';
import '../../utils/hex_color.dart';
import 'package:flutter/material.dart';

/// AI志向推薦視圖 - 漸層卡片展示不同志向領域
class AiRecommendationView extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const AiRecommendationView({Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// 志向推薦資料
    List<AspirationType> aspirations = [
      AspirationType(
        title: '成功企業家',
        description: '創業思維與商業洞察',
        icon: Icons.business_center,
        gradientColors: ['#FF6B6B', '#FF8E53'],
        bookCount: 24,
      ),
      AspirationType(
        title: '高效工作者',
        description: '時間管理與效率提升',
        icon: Icons.speed,
        gradientColors: ['#4ECDC4', '#44A08D'],
        bookCount: 18,
      ),
      AspirationType(
        title: '心理學家',
        description: '人性洞察與心理分析',
        icon: Icons.psychology,
        gradientColors: ['#667eea', '#764ba2'],
        bookCount: 15,
      ),
      AspirationType(
        title: '領導者',
        description: '領導力與團隊管理',
        icon: Icons.group,
        gradientColors: ['#f093fb', '#f5576c'],
        bookCount: 21,
      ),
      AspirationType(
        title: '創意思考者',
        description: '創新思維與設計思考',
        icon: Icons.lightbulb,
        gradientColors: ['#43e97b', '#38f9d7'],
        bookCount: 12,
      ),
      AspirationType(
        title: '理財專家',
        description: '投資理財與財富管理',
        icon: Icons.account_balance,
        gradientColors: ['#fa709a', '#fee140'],
        bookCount: 16,
      ),
    ];

    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: GridView.builder(
                padding: EdgeInsets.all(16),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: aspirations.length,
                itemBuilder: (context, index) {
                  return AspirationCard(
                    aspiration: aspirations[index],
                    delay: index * 100,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 志向卡片元件
class AspirationCard extends StatefulWidget {
  final AspirationType aspiration;
  final int delay;

  const AspirationCard({Key? key, required this.aspiration, this.delay = 0})
      : super(key: key);

  @override
  _AspirationCardState createState() => _AspirationCardState();
}

class _AspirationCardState extends State<AspirationCard>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.easeInOut),
    );

    // 延遲動畫
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller?.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation!,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation!.value,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.aspiration.gradientColors
                    .map((color) => HexColor(color))
                    .toList(),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
                topRight: Radius.circular(54.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: HexColor(widget.aspiration.gradientColors[0]).withOpacity(0.4),
                  offset: const Offset(1.1, 4.0),
                  blurRadius: 8.0,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                  topRight: Radius.circular(54.0),
                ),
                onTap: () {
                  _handleAspirationSelect(widget.aspiration);
                },
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 圖示和書籍數量
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppTheme.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              widget.aspiration.icon,
                              color: AppTheme.white,
                              size: 24,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${widget.aspiration.bookCount}本',
                              style: TextStyle(
                                fontFamily: AppTheme.fontName,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      Spacer(),
                      
                      // 標題
                      Text(
                        widget.aspiration.title,
                        style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.white,
                        ),
                      ),
                      
                      SizedBox(height: 8),
                      
                      // 描述
                      Text(
                        widget.aspiration.description,
                        style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontSize: 12,
                          color: AppTheme.white.withOpacity(0.8),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      SizedBox(height: 16),
                      
                      // 探索按鈕
                      Container(
                        width: double.infinity,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppTheme.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '探索書籍',
                            style: TextStyle(
                              fontFamily: AppTheme.fontName,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleAspirationSelect(AspirationType aspiration) {
    // TODO: 導航到對應的書籍推薦頁面
    print('選擇志向: ${aspiration.title}');
  }
}

/// 志向類型資料模型
class AspirationType {
  final String title;
  final String description;
  final IconData icon;
  final List<String> gradientColors;
  final int bookCount;

  AspirationType({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradientColors,
    required this.bookCount,
  });
}