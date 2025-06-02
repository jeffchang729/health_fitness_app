// widgets/navigation/bottom_bar_view.dart

import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';
import '../../models/tab_icon_data.dart';

/// 底部導航列視圖
/// 
/// 提供五個主要功能區的導航切換
class BottomBarView extends StatefulWidget {
  const BottomBarView({
    Key? key, 
    this.tabIconsList, 
    this.changeIndex, 
    this.addClick
  }) : super(key: key);

  /// 導航圖示清單
  final List<TabIconData>? tabIconsList;
  
  /// 分頁切換回調
  final Function(int)? changeIndex;
  
  /// 中央添加按鈕點擊回調
  final Function()? addClick;

  @override
  _BottomBarViewState createState() => _BottomBarViewState();
}

class _BottomBarViewState extends State<BottomBarView>
    with TickerProviderStateMixin {
  /// 動畫控制器
  AnimationController? animationController;

  @override
  void initState() {
    // 初始化動畫控制器
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    animationController?.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        // 底部導航背景
        AnimatedBuilder(
          animation: animationController!,
          builder: (BuildContext context, Widget? child) {
            return Transform(
              transform: Matrix4.translationValues(0.0, 0.0, 0.0),
              child: PhysicalShape(
                color: AppTheme.white,
                elevation: 16.0,
                clipper: TabClipper(radius: 38.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 62,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
                        child: Row(
                          children: <Widget>[
                            // 左側兩個分頁
                            Expanded(
                              child: TabIcons(
                                tabIconData: widget.tabIconsList?[0],
                                removeAllSelect: () {
                                  setRemoveAllSelection(widget.tabIconsList?[0]);
                                  widget.changeIndex!(0);
                                },
                              ),
                            ),
                            Expanded(
                              child: TabIcons(
                                tabIconData: widget.tabIconsList?[1],
                                removeAllSelect: () {
                                  setRemoveAllSelection(widget.tabIconsList?[1]);
                                  widget.changeIndex!(1);
                                },
                              ),
                            ),
                            
                            // 中央空白區域（為添加按鈕預留空間）
                            SizedBox(
                              width: 74.0,
                              height: 74.0,
                              child: Container(),
                            ),
                            
                            // 右側兩個分頁
                            Expanded(
                              child: TabIcons(
                                tabIconData: widget.tabIconsList?[2],
                                removeAllSelect: () {
                                  setRemoveAllSelection(widget.tabIconsList?[2]);
                                  widget.changeIndex!(2);
                                },
                              ),
                            ),
                            Expanded(
                              child: TabIcons(
                                tabIconData: widget.tabIconsList?[3],
                                removeAllSelect: () {
                                  setRemoveAllSelection(widget.tabIconsList?[3]);
                                  widget.changeIndex!(3);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom,
                    )
                  ],
                ),
              ),
            );
          },
        ),
        
        // 中央添加按鈕
        Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: SizedBox(
            width: 38 * 2.0,
            height: 38 + 62.0,
            child: Container(
              alignment: Alignment.topCenter,
              color: Colors.transparent,
              child: SizedBox(
                width: 38 * 2.0,
                height: 38 * 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ScaleTransition(
                    alignment: Alignment.center,
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: animationController!,
                            curve: const Interval(0.5, 1.0,
                                curve: Curves.fastOutSlowIn))),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.nearlyDarkBlue,
                        gradient: const LinearGradient(
                          colors: <Color>[
                            AppTheme.nearlyDarkBlue,
                            AppTheme.nearlyBlue,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: AppTheme.nearlyDarkBlue.withOpacity(0.4),
                            offset: const Offset(8.0, 16.0),
                            blurRadius: 16.0,
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.white.withOpacity(0.1),
                          highlightColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          borderRadius: const BorderRadius.all(Radius.circular(38.0)),
                          onTap: () {
                            if (widget.addClick != null) {
                              widget.addClick!();
                            }
                          },
                          child: const Icon(
                            Icons.add,
                            color: AppTheme.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 設定移除所有選擇並選中指定分頁
  void setRemoveAllSelection(TabIconData? tabIconData) {
    if (!mounted) return;
    setState(() {
      widget.tabIconsList?.forEach((TabIconData tab) {
        tab.isSelected = false;
        if (tabIconData!.index == tab.index) {
          tab.isSelected = true;
        }
      });
    });
  }
}

/// 單個分頁圖示組件
class TabIcons extends StatefulWidget {
  const TabIcons({Key? key, this.tabIconData, this.removeAllSelect})
      : super(key: key);

  final TabIconData? tabIconData;
  final Function()? removeAllSelect;

  @override
  _TabIconsState createState() => _TabIconsState();
}

class _TabIconsState extends State<TabIcons> with TickerProviderStateMixin {
  @override
  void initState() {
    // 初始化分頁動畫控制器
    widget.tabIconData?.animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          if (!mounted) return;
          widget.removeAllSelect!();
          widget.tabIconData?.animationController?.reverse();
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    widget.tabIconData?.animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Center(
        child: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            if (!widget.tabIconData!.isSelected) {
              widget.tabIconData?.animationController?.forward();
            }
          },
          child: IgnorePointer(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                // 選中狀態的縮放動畫
                ScaleTransition(
                  alignment: Alignment.center,
                  scale: Tween<double>(begin: 0.88, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.tabIconData!.animationController!,
                          curve: const Interval(0.1, 1.0,
                              curve: Curves.fastOutSlowIn))),
                  child: Image.asset(widget.tabIconData!.isSelected
                      ? widget.tabIconData!.selectedImagePath
                      : widget.tabIconData!.imagePath),
                ),
                // 選中狀態的位置動畫
                Positioned(
                  top: 4,
                  left: 6,
                  right: 0,
                  child: ScaleTransition(
                    alignment: Alignment.center,
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: widget.tabIconData!.animationController!,
                            curve: const Interval(0.2, 1.0,
                                curve: Curves.fastOutSlowIn))),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppTheme.nearlyDarkBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                // 選中狀態的位置動畫
                Positioned(
                  top: 0,
                  left: 24,
                  bottom: 8,
                  child: ScaleTransition(
                    alignment: Alignment.center,
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: widget.tabIconData!.animationController!,
                            curve: const Interval(0.5, 0.8,
                                curve: Curves.fastOutSlowIn))),
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: AppTheme.nearlyDarkBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                // 選中狀態的位置動畫
                Positioned(
                  top: 6,
                  right: 8,
                  bottom: 0,
                  child: ScaleTransition(
                    alignment: Alignment.center,
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: widget.tabIconData!.animationController!,
                            curve: const Interval(0.5, 0.6,
                                curve: Curves.fastOutSlowIn))),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppTheme.nearlyDarkBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 底部導航列裁剪器
/// 
/// 建立帶有中央圓形凹槽的形狀
class TabClipper extends CustomClipper<Path> {
  TabClipper({this.radius = 38.0});

  final double radius;

  @override
  Path getClip(Size size) {
    final Path path = Path();

    final double v = radius * 2;
    path.lineTo(0, 0);
    path.arcTo(Rect.fromLTWH(0, 0, radius, radius), degreeToRadians(180),
        degreeToRadians(90), false);
    path.arcTo(
        Rect.fromLTWH(
            ((size.width / 2) - v / 2) - radius + v * 0.04, 0, radius, radius),
        degreeToRadians(270),
        degreeToRadians(70),
        false);

    path.arcTo(Rect.fromLTWH((size.width / 2) - v / 2, -v / 2, v, v),
        degreeToRadians(160), degreeToRadians(-140), false);

    path.arcTo(
        Rect.fromLTWH(
            ((size.width / 2) - v / 2) + v - (radius - v * 0.04), 0, radius, radius),
        degreeToRadians(200),
        degreeToRadians(70),
        false);
    path.arcTo(Rect.fromLTWH(size.width - radius, 0, radius, radius),
        degreeToRadians(270), degreeToRadians(90), false);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(TabClipper oldClipper) => oldClipper.radius != radius;

  /// 角度轉弧度
  double degreeToRadians(double degree) {
    return (degree * 3.141592653589793) / 180;
  }
}