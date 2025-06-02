// widgets/feed/recommended_books_view.dart - 修復溢出問題

import '../../themes/app_theme.dart';
import '../../models/books_list_data.dart';
import '../../utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// 熱門推薦書籍視圖 - 修復溢出問題
class RecommendedBooksView extends StatefulWidget {
  const RecommendedBooksView(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _RecommendedBooksViewState createState() => _RecommendedBooksViewState();
}

class _RecommendedBooksViewState extends State<RecommendedBooksView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<BooksListData> booksListData = BooksListData.tabIconsList;

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
              height: 216, // 保持原有健身APP的高度
              width: double.infinity,
              child: ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: booksListData.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int count =
                      booksListData.length > 10 ? 10 : booksListData.length;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController!,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn)));
                  animationController?.forward();

                  return BookView(
                    booksListData: booksListData[index],
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

/// 單個書籍卡片視圖 - 修復文字溢出問題
class BookView extends StatelessWidget {
  const BookView(
      {Key? key, this.booksListData, this.animationController, this.animation})
      : super(key: key);

  final BooksListData? booksListData;
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
              width: 130, // 保持健身APP的寬度
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 32, left: 8, right: 8, bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: HexColor(booksListData!.endColor)
                                  .withOpacity(0.6),
                              offset: const Offset(1.1, 4.0),
                              blurRadius: 8.0),
                        ],
                        gradient: LinearGradient(
                          colors: <HexColor>[
                            HexColor(booksListData!.startColor),
                            HexColor(booksListData!.endColor),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(54.0), // 保持特殊圓角
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 54, left: 12, right: 12, bottom: 8), // 🔧 減少左右 padding
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // 書籍標題 - 🔧 添加溢出處理
                            Text(
                              booksListData!.titleTxt,
                              textAlign: TextAlign.left, // 🔧 改為左對齊
                              style: TextStyle(
                                fontFamily: AppTheme.fontName,
                                fontWeight: FontWeight.bold,
                                fontSize: 15, // 🔧 稍微縮小字體
                                letterSpacing: 0.1, // 🔧 減少字母間距
                                color: AppTheme.white,
                              ),
                              maxLines: 1, // 🔧 限制行數
                              overflow: TextOverflow.ellipsis, // 🔧 溢出顯示省略號
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 6, bottom: 6), // 🔧 減少 padding
                                child: Column( // 🔧 改為 Column 避免 Row 溢出
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    // 🔧 使用 Flexible 包裝文字避免溢出
                                    Flexible(
                                      child: Text(
                                        booksListData!.books!.join('\n'),
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 9, // 🔧 縮小字體
                                          letterSpacing: 0.1,
                                          color: AppTheme.white,
                                          height: 1.2, // 🔧 調整行高
                                        ),
                                        maxLines: 3, // 🔧 限制最大行數
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // 評分或新增按鈕 - 🔧 確保不溢出
                            booksListData?.rating != null && booksListData!.rating! > 0
                                ? Container(
                                    width: double.infinity, // 🔧 佔滿可用寬度
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min, // 🔧 最小尺寸
                                      children: <Widget>[
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 14, // 🔧 縮小圖示
                                        ),
                                        SizedBox(width: 2), // 🔧 減少間距
                                        Flexible( // 🔧 使用 Flexible 避免溢出
                                          child: Text(
                                            booksListData!.rating.toString(),
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontName,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20, // 🔧 稍微縮小
                                              letterSpacing: 0.1,
                                              color: AppTheme.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 2),
                                        Text(
                                          'stars',
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 8, // 🔧 縮小
                                            letterSpacing: 0.1,
                                            color: AppTheme.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      color: AppTheme.nearlyWhite,
                                      shape: BoxShape.circle,
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: AppTheme.nearlyBlack
                                                .withOpacity(0.4),
                                            offset: Offset(4.0, 4.0), // 🔧 減少陰影偏移
                                            blurRadius: 6.0), // 🔧 減少模糊半徑
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0), // 🔧 減少 padding
                                      child: Icon(
                                        Icons.add,
                                        color: HexColor(booksListData!.endColor),
                                        size: 20, // 🔧 縮小圖示
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // 左上角圓形裝飾 - 調整大小避免與中央書籍封面重疊
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 60, // 縮小避免重疊
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppTheme.nearlyWhite.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // 書籍封面圖片 - 支援網路圖片 🔧 縮小一半
                  Positioned(
                    top: 20, // 🔧 調整位置讓縮小的圖片居中
                    left: 28, // 🔧 調整位置讓縮小的圖片居中
                    child: Container(
                      width: 40, // 🔧 從 80 縮小到 40
                      height: 40, // 🔧 從 80 縮小到 40
                      child: booksListData!.isNetworkImage
                        ? ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: booksListData!.imagePath,
                              width: 40, // 🔧 縮小一半
                              height: 40, // 🔧 縮小一半
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 40, // 🔧 縮小一半
                                height: 40, // 🔧 縮小一半
                                decoration: BoxDecoration(
                                  color: AppTheme.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.menu_book,
                                  color: AppTheme.white,
                                  size: 20, // 🔧 圖示也縮小一半
                                ),
                              ),
                              errorWidget: (context, url, error) => 
                                _buildFallbackImage(),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 50,
                              height: 65,
                              decoration: BoxDecoration(
                                color: AppTheme.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.menu_book,
                                color: AppTheme.white,
                                size: 25,
                              ),
                            ),
                          ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 建立後備圖片（當網路圖片載入失敗時使用）
  Widget _buildFallbackImage() {
    return Image.asset(
      booksListData!.fallbackIcon,
      width: 40, // 🔧 縮小一半
      height: 40, // 🔧 縮小一半
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 40, // 🔧 縮小一半
          height: 40, // 🔧 縮小一半
          decoration: BoxDecoration(
            color: AppTheme.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.menu_book,
            color: AppTheme.white,
            size: 20, // 🔧 圖示也縮小一半
          ),
        );
      },
    );
  }
}