// widgets/search/aspiration_grid_view.dart

import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';
import '../../services/ai_recommendation_service.dart';

/// 志向分類網格視圖
/// 
/// 功能特色：
/// - 漸層卡片設計
/// - 交錯載入動畫
/// - 互動回饋效果
/// - 分類點擊處理
class AspirationGridView extends StatefulWidget {
  final List<AspirationCategory> categories;
  final Function(AspirationCategory) onCategorySelected;

  const AspirationGridView({
    Key? key,
    required this.categories,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  _AspirationGridViewState createState() => _AspirationGridViewState();
}

class _AspirationGridViewState extends State<AspirationGridView>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startStaggeredAnimation();
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  /// 初始化動畫控制器
  void _initializeAnimations() {
    _animationControllers = List.generate(
      widget.categories.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );

    _scaleAnimations = _animationControllers.map((controller) {
      return Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      );
    }).toList();

    _fadeAnimations = _animationControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutQuart),
      );
    }).toList();
  }

  /// 啟動交錯動畫
  void _startStaggeredAnimation() {
    for (int i = 0; i < _animationControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) {
          _animationControllers[i].forward();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categories.isEmpty) {
      return _buildLoadingView();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 標題區域
          _buildHeaderSection(),
          
          const SizedBox(height: 24),
          
          // 志向分類網格
          _buildAspirationGrid(),
          
          const SizedBox(height: 32),
          
          // 底部提示
          _buildBottomTip(),
        ],
      ),
    );
  }

  /// 建立標題區域
  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6F72CA), Color(0xFF1E1466)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF6F72CA).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                Icons.psychology,
                color: AppTheme.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '選擇您的志向領域',
                    style: TextStyle(
                      fontFamily: AppTheme.fontName,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: AppTheme.darkerText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'AI 會根據您的選擇推薦最適合的書籍',
                    style: TextStyle(
                      fontFamily: AppTheme.fontName,
                      fontSize: 14,
                      color: AppTheme.grey,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 建立志向分類網格
  Widget _buildAspirationGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: widget.categories.length,
      itemBuilder: (context, index) {
        final category = widget.categories[index];
        
        if (index < _scaleAnimations.length) {
          return AnimatedBuilder(
            animation: _animationControllers[index],
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimations[index].value,
                child: Opacity(
                  opacity: _fadeAnimations[index].value,
                  child: AspirationCard(
                    category: category,
                    onTap: () => widget.onCategorySelected(category),
                  ),
                ),
              );
            },
          );
        }
        
        return AspirationCard(
          category: category,
          onTap: () => widget.onCategorySelected(category),
        );
      },
    );
  }

  /// 建立載入視圖
  Widget _buildLoadingView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6F72CA)),
            ),
            const SizedBox(height: 24),
            Text(
              '載入志向分類中...',
              style: TextStyle(
                fontFamily: AppTheme.fontName,
                fontSize: 16,
                color: AppTheme.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 建立底部提示
  Widget _buildBottomTip() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF6F72CA).withOpacity(0.1),
            Color(0xFF1E1466).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFF6F72CA).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: Color(0xFF6F72CA),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '也可以直接描述您想成為什麼樣的人，AI 會理解您的需求並推薦合適的書籍',
              style: TextStyle(
                fontFamily: AppTheme.fontName,
                fontSize: 13,
                color: AppTheme.darkerText.withOpacity(0.8),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 志向卡片元件
class AspirationCard extends StatefulWidget {
  final AspirationCategory category;
  final VoidCallback onTap;

  const AspirationCard({
    Key? key,
    required this.category,
    required this.onTap,
  }) : super(key: key);

  @override
  _AspirationCardState createState() => _AspirationCardState();
}

class _AspirationCardState extends State<AspirationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _tapAnimationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _tapAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _tapAnimationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _tapAnimationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _tapAnimationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _tapAnimationController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _tapAnimationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = widget.category.colors.map((colorString) {
      return Color(int.parse('0xFF${colorString.substring(1)}'));
    }).toList();

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: widget.onTap,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: gradientColors.first.withOpacity(_isPressed ? 0.4 : 0.25),
                    blurRadius: _isPressed ? 15 : 12,
                    offset: Offset(0, _isPressed ? 8 : 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // 背景圖案
                    Positioned(
                      top: -20,
                      right: -20,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -30,
                      left: -30,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                    
                    // 內容
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 圖示區域
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppTheme.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppTheme.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              _getIconData(widget.category.icon),
                              color: AppTheme.white,
                              size: 24,
                            ),
                          ),
                          
                          const Spacer(),
                          
                          // 標題
                          Text(
                            widget.category.title,
                            style: TextStyle(
                              fontFamily: AppTheme.fontName,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.white,
                              height: 1.2,
                            ),
                          ),
                          
                          const SizedBox(height: 6),
                          
                          // 副標題
                          Text(
                            widget.category.subtitle,
                            style: TextStyle(
                              fontFamily: AppTheme.fontName,
                              fontSize: 13,
                              color: AppTheme.white.withOpacity(0.9),
                              height: 1.3,
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // 探索按鈕
                          Container(
                            width: double.infinity,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppTheme.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: AppTheme.white.withOpacity(0.4),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '探索書籍',
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.white,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: AppTheme.white,
                                    size: 12,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 根據字串取得對應的圖示
  IconData _getIconData(String iconString) {
    switch (iconString) {
      case 'trending_up':
        return Icons.trending_up;
      case 'groups':
        return Icons.groups;
      case 'lightbulb':
        return Icons.lightbulb;
      case 'speed':
        return Icons.speed;
      case 'forum':
        return Icons.forum;
      case 'business_center':
        return Icons.business_center;
      case 'psychology':
        return Icons.psychology;
      case 'account_balance':
        return Icons.account_balance;
      default:
        return Icons.book;
    }
  }
}