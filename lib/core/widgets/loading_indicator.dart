// lib/core/widgets/loading_indicator.dart
import 'package:flutter/material.dart';
import '../config/app_theme.dart';

/// 載入指示器元件
/// 
/// 功能特色：
/// - 優雅的載入動畫
/// - 可自訂載入訊息
/// - 符合應用主題設計
class LoadingIndicator extends StatefulWidget {
  final String message;
  final Color? color;

  const LoadingIndicator({
    Key? key,
    this.message = '載入中...',
    this.color,
  }) : super(key: key);

  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  /// 初始化動畫控制器
  void _initializeAnimations() {
    // 旋轉動畫
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    // 脈衝動畫
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // 啟動動畫
    _rotationController.repeat();
    _pulseController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 載入動畫
          AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Transform.rotate(
                      angle: _rotationAnimation.value * 2.0 * 3.14159,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              widget.color ?? Color(0xFF6F72CA),
                              (widget.color ?? Color(0xFF6F72CA)).withOpacity(0.3),
                              widget.color ?? Color(0xFF1E1466),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: (widget.color ?? Color(0xFF6F72CA)).withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.psychology,
                            color: AppTheme.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          
          const SizedBox(height: 24),
          
          // 載入文字
          Text(
            widget.message,
            style: TextStyle(
              fontFamily: AppTheme.fontName,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppTheme.grey,
            ),
          ),
        ],
      ),
    );
  }
}