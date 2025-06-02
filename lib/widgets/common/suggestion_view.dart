// widgets/common/suggestion_view.dart

import '../../utils/hex_color.dart';
import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';

/// AI建議提示視圖
/// 
/// 顯示智慧建議和激勵訊息
class SuggestionView extends StatelessWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const SuggestionView({Key? key, this.animationController, this.animation})
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
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 0, bottom: 24),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: HexColor("#D7E0F9"),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                bottomLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                                topRight: Radius.circular(8.0)),
                          ),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 68, bottom: 12, right: 16, top: 12),
                                child: Text(
                                  '準備好迎接今天的挑戰了嗎？讓我們一起完成目標吧！',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    letterSpacing: 0.0,
                                    color: AppTheme.nearlyDarkBlue
                                        .withOpacity(0.6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: -12,
                        left: 0,
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.nearlyDarkBlue.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.lightbulb_outline,
                              color: AppTheme.nearlyDarkBlue,
                              size: 40,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}