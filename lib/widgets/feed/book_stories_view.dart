// widgets/feed/book_stories_view.dart

import '../../themes/app_theme.dart';
import '../../utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// 書籍限時動態視圖
/// 模仿 Instagram Stories 的橫向滑動書籍推薦
/// 顯示真實用戶頭像、書籍封面和半透明裝飾圓形
class BookStoriesView extends StatefulWidget {
  const BookStoriesView(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _BookStoriesViewState createState() => _BookStoriesViewState();
}

class _BookStoriesViewState extends State<BookStoriesView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  
  /// 限時動態資料清單，使用美女頭像和書籍資訊
  List<BookStoryData> storyDataList = <BookStoryData>[
    BookStoryData(
      userName: '愛讀書的小雅',
      userAvatarUrl: 'https://images.unsplash.com/photo-1494790108755-2616b9f04bbc?w=150&h=150&fit=crop&crop=face',
      bookTitle: '原子習慣',
      bookCoverUrl: 'https://images-na.ssl-images-amazon.com/images/P/0735211299.01.L.jpg',
      gradientColors: ['#FA7D82', '#FFB295'],
      storyTime: '2小時前',
    ),
    BookStoryData(
      userName: '商業達人Jane',
      userAvatarUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
      bookTitle: '從0到1',
      bookCoverUrl: 'https://images-na.ssl-images-amazon.com/images/P/0804139296.01.L.jpg',
      gradientColors: ['#738AE6', '#5C5EDD'],
      storyTime: '4小時前',
    ),
    BookStoryData(
      userName: '心理學美女Amy',
      userAvatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&h=150&fit=crop&crop=face',
      bookTitle: '快思慢想',
      bookCoverUrl: 'https://images-na.ssl-images-amazon.com/images/P/0374533555.01.L.jpg',
      gradientColors: ['#FE95B6', '#FF5287'],
      storyTime: '6小時前',
    ),
    BookStoryData(
      userName: '科技趨勢觀察家Sarah',
      userAvatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&h=150&fit=crop&crop=face',
      bookTitle: '人類大歷史',
      bookCoverUrl: 'https://images-na.ssl-images-amazon.com/images/P/0143127748.01.L.jpg',
      gradientColors: ['#6F72CA', '#1E1466'],
      storyTime: '8小時前',
    ),
    BookStoryData(
      userName: '投資理財美女Lisa',
      userAvatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      bookTitle: '富爸爸窮爸爸',
      bookCoverUrl: 'https://images-na.ssl-images-amazon.com/images/P/1612680194.01.L.jpg',
      gradientColors: ['#FF9A9E', '#FECFEF'],
      storyTime: '12小時前',
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
              height: 120, // 限時動態的標準高度
              width: double.infinity,
              child: ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: storyDataList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int count = storyDataList.length > 10 ? 10 : storyDataList.length;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController!,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn)));
                  animationController?.forward();

                  return BookStoryItem(
                    storyData: storyDataList[index],
                    animation: animation,
                    animationController: animationController!,
                    onTap: () {
                      // 點擊限時動態的處理邏輯
                      _openStoryViewer(context, index);
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  /// 開啟限時動態查看器
  void _openStoryViewer(BuildContext context, int startIndex) {
    // TODO: 實作限時動態全螢幕查看器
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('限時動態'),
        content: Text('正在查看 ${storyDataList[startIndex].userName} 的限時動態'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('關閉'),
          ),
        ],
      ),
    );
  }
}

/// 單個限時動態項目
class BookStoryItem extends StatelessWidget {
  const BookStoryItem({
    Key? key,
    required this.storyData,
    required this.animation,
    required this.animationController,
    required this.onTap,
  }) : super(key: key);

  final BookStoryData storyData;
  final Animation<double> animation;
  final AnimationController animationController;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation.value), 0.0, 0.0),
            child: Container(
              width: 90, // 限時動態項目寬度
              margin: const EdgeInsets.only(right: 12),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  children: [
                    // 限時動態圓形頭像區域
                    Container(
                      width: 80,
                      height: 80,
                      child: Stack(
                        children: [
                          // 半透明圓形背景裝飾
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              width: 80, // 調整半透明圓形大小配合60x60頭像
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppTheme.nearlyWhite.withOpacity(0.15), // 調整透明度
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          
                          // 漸層邊框
                          Positioned(
                            top: 2,
                            left: 2,
                            child: Container(
                              width: 76,
                              height: 76,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    HexColor(storyData.gradientColors[0]),
                                    HexColor(storyData.gradientColors[1]),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppTheme.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: ClipOval(
                                      child: _buildUserAvatar(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          // 用戶頭像 60x60，居中對齊
                          Positioned(
                            top: 8,
                            left: 8, // 改回8讓頭像居中
                            child: Container(
                              width: 60,
                              height: 60,
                              child: ClipOval(
                                child: _buildUserAvatar(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // 用戶名稱
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        storyData.userName,
                        style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: AppTheme.darkerText,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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

  /// 建立用戶頭像Widget
  Widget _buildUserAvatar() {
    return CachedNetworkImage(
      imageUrl: storyData.userAvatarUrl,
      width: 60, // 確保網路圖片也是60x60
      height: 60,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: AppTheme.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.person,
          color: AppTheme.grey,
          size: 30, // 圖示大小
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: AppTheme.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.person,
          color: AppTheme.grey,
          size: 30,
        ),
      ),
    );
  }
}

/// 限時動態資料模型
class BookStoryData {
  BookStoryData({
    required this.userName,
    required this.userAvatarUrl,
    required this.bookTitle,
    required this.bookCoverUrl,
    required this.gradientColors,
    required this.storyTime,
  });

  /// 用戶名稱
  final String userName;
  
  /// 用戶頭像網路圖片URL
  final String userAvatarUrl;
  
  /// 書籍標題
  final String bookTitle;
  
  /// 書籍封面網路圖片URL
  final String bookCoverUrl;
  
  /// 漸層顏色陣列（開始色、結束色）
  final List<String> gradientColors;
  
  /// 限時動態發布時間
  final String storyTime;

  /// 檢查用戶頭像是否為網路圖片
  bool get isNetworkAvatar => userAvatarUrl.startsWith('http');

  /// 檢查書籍封面是否為網路圖片
  bool get isNetworkBookCover => bookCoverUrl.startsWith('http');

  /// 取得漸層開始顏色
  String get startColor => gradientColors.isNotEmpty ? gradientColors[0] : '#FA7D82';

  /// 取得漸層結束顏色
  String get endColor => gradientColors.length > 1 ? gradientColors[1] : '#FFB295';
}