// widgets/library/my_books_view.dart

import '../../themes/app_theme.dart';
import '../../utils/hex_color.dart';
import 'package:flutter/material.dart';

/// 我的書籍視圖 - 展示用戶收藏的書籍
class MyBooksView extends StatefulWidget {
  const MyBooksView(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _MyBooksViewState createState() => _MyBooksViewState();
}

class _MyBooksViewState extends State<MyBooksView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  
  /// 我的書籍範例資料
  List<MyBookData> booksData = [
    MyBookData(
      title: '原子習慣',
      author: '詹姆斯·克利爾',
      cover: 'assets/bookme/book_atomic_habits.png',
      progress: 75,
      status: BookStatus.reading,
      rating: 0.0,
      gradientColors: ['#FF6B6B', '#FF8E53'],
    ),
    MyBookData(
      title: '刻意練習',
      author: '安德斯·艾瑞克森',
      cover: 'assets/bookme/book_deliberate_practice.png',
      progress: 100,
      status: BookStatus.completed,
      rating: 5.0,
      gradientColors: ['#4ECDC4', '#44A08D'],
    ),
    MyBookData(
      title: '快思慢想',
      author: '丹尼爾·康納曼',
      cover: 'assets/bookme/book_thinking_fast_slow.png',
      progress: 45,
      status: BookStatus.reading,
      rating: 0.0,
      gradientColors: ['#667eea', '#764ba2'],
    ),
    MyBookData(
      title: '深度工作力',
      author: '卡爾·紐波特',
      cover: 'assets/bookme/book_deep_work.png',
      progress: 0,
      status: BookStatus.wishlist,
      rating: 0.0,
      gradientColors: ['#f093fb', '#f5576c'],
    ),
  ];

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child: Container(
              height: 216,
              width: double.infinity,
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 0, bottom: 0, right: 16, left: 16),
                itemCount: booksData.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int count = booksData.length > 10 ? 10 : booksData.length;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController!,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn)));
                  animationController?.forward();

                  return MyBookView(
                    bookData: booksData[index],
                    animation: animation,
                    animationController: animationController!,
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

/// 單個書籍視圖
class MyBookView extends StatelessWidget {
  const MyBookView(
      {Key? key, this.bookData, this.animationController, this.animation})
      : super(key: key);

  final MyBookData? bookData;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation!.value), 0.0, 0.0),
            child: SizedBox(
              width: 130,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 32, left: 8, right: 8, bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: HexColor(bookData!.gradientColors[0]).withOpacity(0.6),
                              offset: const Offset(1.1, 4.0),
                              blurRadius: 8.0),
                        ],
                        gradient: LinearGradient(
                          colors: <HexColor>[
                            HexColor(bookData!.gradientColors[0]),
                            HexColor(bookData!.gradientColors[1]),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(54.0),
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(54.0),
                          ),
                          onTap: () {
                            // TODO: 導航到書籍詳情頁面
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 54, left: 16, right: 16, bottom: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // 書籍標題
                                Text(
                                  bookData!.title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    letterSpacing: 0.2,
                                    color: AppTheme.white,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                
                                // 作者
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    bookData!.author,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      letterSpacing: 0.2,
                                      color: AppTheme.white.withOpacity(0.8),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                
                                Spacer(),
                                
                                // 進度條或狀態
                                if (bookData!.status == BookStatus.reading) ...[
                                  // 閱讀進度
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${bookData!.progress}%',
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: AppTheme.white,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Container(
                                          height: 4,
                                          decoration: BoxDecoration(
                                            color: AppTheme.white.withOpacity(0.3),
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                          child: FractionallySizedBox(
                                            alignment: Alignment.centerLeft,
                                            widthFactor: bookData!.progress / 100,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppTheme.white,
                                                borderRadius: BorderRadius.circular(2),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ] else if (bookData!.status == BookStatus.completed) ...[
                                  // 已完成 - 顯示評分
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        bookData!.rating.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          letterSpacing: 0.2,
                                          color: AppTheme.white,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        '已完成',
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10,
                                          letterSpacing: 0.2,
                                          color: AppTheme.white,
                                        ),
                                      ),
                                    ],
                                  )
                                ] else ...[
                                  // 想讀清單 - 顯示添加按鈕
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppTheme.nearlyWhite,
                                      shape: BoxShape.circle,
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: AppTheme.nearlyBlack.withOpacity(0.4),
                                            offset: Offset(8.0, 8.0),
                                            blurRadius: 8.0),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Icon(
                                        Icons.add,
                                        color: HexColor(bookData!.gradientColors[1]),
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 狀態指示器
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        color: AppTheme.nearlyWhite.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getStatusColor(bookData!.status),
                        ),
                        child: Icon(
                          _getStatusIcon(bookData!.status),
                          color: AppTheme.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(BookStatus status) {
    switch (status) {
      case BookStatus.reading:
        return Colors.orange;
      case BookStatus.completed:
        return Colors.green;
      case BookStatus.wishlist:
        return Colors.blue;
    }
  }

  IconData _getStatusIcon(BookStatus status) {
    switch (status) {
      case BookStatus.reading:
        return Icons.menu_book;
      case BookStatus.completed:
        return Icons.check_circle;
      case BookStatus.wishlist:
        return Icons.bookmark_border;
    }
  }
}

/// 書籍狀態枚舉
enum BookStatus {
  reading,    // 閱讀中
  completed,  // 已完成
  wishlist,   // 想讀清單
}

/// 我的書籍資料模型
class MyBookData {
  final String title;
  final String author;
  final String cover;
  final int progress;
  final BookStatus status;
  final double rating;
  final List<String> gradientColors;

  MyBookData({
    required this.title,
    required this.author,
    required this.cover,
    required this.progress,
    required this.status,
    required this.rating,
    required this.gradientColors,
  });
}