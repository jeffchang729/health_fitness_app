// widgets/feed/book_post_list_view.dart

import '../../themes/app_theme.dart';
import '../../utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// 書籍貼文列表視圖 - IG 風格的貼文流（使用網路圖片）
class BookPostListView extends StatefulWidget {
  const BookPostListView(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _BookPostListViewState createState() => _BookPostListViewState();
}

class _BookPostListViewState extends State<BookPostListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  
  /// 書籍貼文範例資料 - 使用網路圖片
  List<BookPostData> postsData = [
    BookPostData(
      userName: '愛讀書的小美',
      userAvatar: 'https://i.pravatar.cc/150?img=5',
      bookTitle: '原子習慣',
      bookAuthor: '詹姆斯·克利爾',
      bookCover: 'https://images-na.ssl-images-amazon.com/images/P/0735211299.01.L.jpg',
      readingProgress: 75,
      postContent: '剛讀完第七章，關於習慣堆疊的概念真的很實用！已經開始嘗試把晨間閱讀和喝咖啡結合在一起 ☕📚',
      rating: 4.5,
      likes: 126,
      comments: 23,
      timeAgo: '2小時前',
      gradientColors: ['#FF6B6B', '#FF8E53'],
    ),
    BookPostData(
      userName: '書蟲阿宏',
      userAvatar: 'https://i.pravatar.cc/150?img=3',
      bookTitle: '刻意練習',
      bookAuthor: '安德斯·艾瑞克森',
      bookCover: 'https://images-na.ssl-images-amazon.com/images/P/0547526075.01.L.jpg',
      readingProgress: 100,
      postContent: '終於讀完了！一萬小時法則原來有這麼多誤區，真正的刻意練習比我想像中更有挑戰性 💪',
      rating: 5.0,
      likes: 89,
      comments: 15,
      timeAgo: '4小時前',
      gradientColors: ['#4ECDC4', '#44A08D'],
    ),
    BookPostData(
      userName: '文青小王',
      userAvatar: 'https://i.pravatar.cc/150?img=7',
      bookTitle: '快思慢想',
      bookAuthor: '丹尼爾·康納曼',
      bookCover: 'https://images-na.ssl-images-amazon.com/images/P/0374533555.01.L.jpg',
      readingProgress: 60,
      postContent: '行為經濟學真的太有趣了！我們的大腦原來有這麼多認知偏誤，每一頁都讓我重新思考自己的決策方式 🧠',
      rating: 4.8,
      likes: 156,
      comments: 32,
      timeAgo: '6小時前',
      gradientColors: ['#667eea', '#764ba2'],
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
            child: Column(
              children: postsData.map((postData) {
                int index = postsData.indexOf(postData);
                final Animation<double> animation =
                    Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: animationController!,
                            curve: Interval((1 / postsData.length) * index, 1.0,
                                curve: Curves.fastOutSlowIn)));
                animationController?.forward();

                return BookPostView(
                  postData: postData,
                  animation: animation,
                  animationController: animationController!,
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

/// 單個書籍貼文視圖
class BookPostView extends StatelessWidget {
  const BookPostView(
      {Key? key, this.postData, this.animationController, this.animation})
      : super(key: key);

  final BookPostData? postData;
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
                0.0, 30 * (1.0 - animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: AppTheme.grey.withOpacity(0.2),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 用戶資訊標頭
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // 用戶頭像 - 使用網路圖片
                          ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: postData!.userAvatar,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 40,
                                height: 40,
                                color: AppTheme.grey.withOpacity(0.3),
                                child: Icon(
                                  Icons.person,
                                  color: AppTheme.white,
                                  size: 20,
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 40,
                                height: 40,
                                color: AppTheme.grey.withOpacity(0.3),
                                child: Icon(
                                  Icons.person,
                                  color: AppTheme.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          // 用戶名稱和時間
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  postData!.userName,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                                Text(
                                  postData!.timeAgo,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontSize: 12,
                                    color: AppTheme.grey.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // 更多選項按鈕
                          Icon(
                            Icons.more_horiz,
                            color: AppTheme.grey,
                          ),
                        ],
                      ),
                    ),
                    
                    // 書籍資訊區域
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: postData!.gradientColors.map((color) => HexColor(color)).toList(),
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            // 書籍封面 - 使用網路圖片
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: postData!.bookCover,
                                width: 60,
                                height: 80,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  width: 60,
                                  height: 80,
                                  color: AppTheme.white.withOpacity(0.3),
                                  child: Icon(
                                    Icons.menu_book,
                                    color: AppTheme.white,
                                    size: 30,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  width: 60,
                                  height: 80,
                                  color: AppTheme.white.withOpacity(0.3),
                                  child: Icon(
                                    Icons.menu_book,
                                    color: AppTheme.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            // 書籍資訊
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    postData!.bookTitle,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    postData!.bookAuthor,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontSize: 12,
                                      color: AppTheme.white.withOpacity(0.8),
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  // 閱讀進度條
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '閱讀進度 ${postData!.readingProgress}%',
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontSize: 10,
                                          color: AppTheme.white.withOpacity(0.8),
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
                                          widthFactor: postData!.readingProgress / 100,
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // 貼文內容
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        postData!.postContent,
                        style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontSize: 14,
                          color: AppTheme.darkText,
                          height: 1.4,
                        ),
                      ),
                    ),
                    
                    // 評分和互動按鈕
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          // 評分
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              SizedBox(width: 4),
                              Text(
                                postData!.rating.toString(),
                                style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.darkerText,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          // 互動按鈕
                          _buildInteractionButton(Icons.favorite_outline, postData!.likes.toString()),
                          SizedBox(width: 16),
                          _buildInteractionButton(Icons.comment_outlined, postData!.comments.toString()),
                          SizedBox(width: 16),
                          _buildInteractionButton(Icons.share_outlined, ''),
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

  Widget _buildInteractionButton(IconData icon, String count) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppTheme.grey,
          size: 20,
        ),
        if (count.isNotEmpty) ...[
          SizedBox(width: 4),
          Text(
            count,
            style: TextStyle(
              fontFamily: AppTheme.fontName,
              fontSize: 12,
              color: AppTheme.grey,
            ),
          ),
        ],
      ],
    );
  }
}

/// 書籍貼文資料模型
class BookPostData {
  final String userName;
  final String userAvatar;    // 網路圖片URL
  final String bookTitle;
  final String bookAuthor;
  final String bookCover;     // 網路圖片URL
  final int readingProgress;
  final String postContent;
  final double rating;
  final int likes;
  final int comments;
  final String timeAgo;
  final List<String> gradientColors;

  BookPostData({
    required this.userName,
    required this.userAvatar,
    required this.bookTitle,
    required this.bookAuthor,
    required this.bookCover,
    required this.readingProgress,
    required this.postContent,
    required this.rating,
    required this.likes,
    required this.comments,
    required this.timeAgo,
    required this.gradientColors,
  });
}