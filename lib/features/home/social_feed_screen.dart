// lib/features/home/social_feed_screen.dart

import 'package:flutter/material.dart';
import '../../core/config/app_theme.dart';

/// IG風格社群動態頁面
class SocialFeedScreen extends StatefulWidget {
  const SocialFeedScreen({Key? key, this.animationController}) : super(key: key);
  final AnimationController? animationController;

  @override
  _SocialFeedScreenState createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends State<SocialFeedScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          controller: scrollController,
          slivers: [
            // Stories 區域 - 固定高度並確保不溢出
            SliverToBoxAdapter(
              child: _buildStoriesSection(),
            ),
            // 動態貼文列表
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildPostCard(bookPosts[index]),
                childCount: bookPosts.length,
              ),
            ),
            // 底部留白，避免被底部導航遮擋
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).padding.bottom + 80,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 建構Stories區域 - 修正高度溢出問題
  Widget _buildStoriesSection() {
    return Container(
      height: 100, // 減少高度避免溢出
      margin: const EdgeInsets.only(bottom: 8), // 添加底部間距
      decoration: const BoxDecoration(
        color: AppTheme.white,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.background,
            width: 1,
          ),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), // 調整內邊距
        itemCount: stories.length,
        itemBuilder: (context, index) {
          return _buildStoryItem(stories[index]);
        },
      ),
    );
  }

  /// 建構單個Story項目 - 優化尺寸
  Widget _buildStoryItem(StoryData story) {
    return Container(
      width: 70, // 固定寬度
      margin: const EdgeInsets.symmetric(horizontal: 6), // 調整間距
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 頭像圓環 - 調整尺寸
          Container(
            width: 56, // 調整大小
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: story.hasNewStory
                  ? const LinearGradient(
                      colors: [
                        Color(0xFFFF6B6B),
                        Color(0xFFFFE66D),
                        Color(0xFF4ECDC4),
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    )
                  : null,
              color: story.hasNewStory ? null : AppTheme.grey.withOpacity(0.3),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2), // 調整內邊距
              child: Container(
                decoration: const BoxDecoration(
                  color: AppTheme.white,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: ClipOval(
                    child: _buildUserAvatar(story.avatarUrl, story.name, 48), // 指定頭像大小
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          // 使用者名稱 - 調整字體和間距
          SizedBox(
            width: 70,
            child: Text(
              story.name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1, // 限制行數
              style: const TextStyle(
                fontSize: 11, // 減小字體
                color: AppTheme.darkerText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 建構使用者頭像（帶有錯誤處理）- 添加尺寸參數
  Widget _buildUserAvatar(String? avatarUrl, String userName, double size) {
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return Image.network(
        avatarUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultAvatar(userName, size);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          
          return Container(
            width: size,
            height: size,
            color: AppTheme.grey.withOpacity(0.1),
            child: Center(
              child: SizedBox(
                width: size * 0.4, // 載入指示器大小相對於頭像大小
                height: size * 0.4,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  color: AppTheme.nearlyDarkBlue,
                ),
              ),
            ),
          );
        },
      );
    } else {
      return _buildDefaultAvatar(userName, size);
    }
  }

  /// 建構預設頭像 - 添加尺寸參數
  Widget _buildDefaultAvatar(String userName, double size) {
    final colors = [
      const Color(0xFF2633C5),
      const Color(0xFF4A90E2),
      const Color(0xFF50C878),
      const Color(0xFFFF9800),
      const Color(0xFFE91E63),
      const Color(0xFF9C27B0),
      const Color(0xFF795548),
    ];
    
    final colorIndex = userName.hashCode % colors.length;
    final backgroundColor = colors[colorIndex.abs()];
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          userName.isNotEmpty ? userName[0].toUpperCase() : '?',
          style: TextStyle(
            color: AppTheme.white,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.4, // 字體大小相對於頭像大小
          ),
        ),
      ),
    );
  }

  /// 建構貼文卡片 - 優化間距
  Widget _buildPostCard(BookPost post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12), // 調整間距
      decoration: const BoxDecoration(
        color: AppTheme.white,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.background,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 貼文頭部
          _buildPostHeader(post),
          // 書籍圖片
          _buildBookImage(post),
          // 互動按鈕
          _buildInteractionButtons(post),
          // 按讚數量
          _buildLikesCount(post),
          // 貼文內容
          _buildPostContent(post),
          // 留言預覽
          _buildCommentsPreview(post),
          // 發布時間
          _buildPostTime(post),
        ],
      ),
    );
  }

  /// 貼文頭部 - 調整頭像大小
  Widget _buildPostHeader(BookPost post) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // 使用者頭像
          ClipOval(
            child: _buildUserAvatar(post.userAvatarUrl, post.userName, 32), // 指定頭像大小
          ),
          const SizedBox(width: 12),
          // 使用者名稱和位置
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppTheme.darkerText,
                  ),
                ),
                if (post.location != null)
                  Text(
                    post.location!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.grey,
                    ),
                  ),
              ],
            ),
          ),
          // 更多選項
          IconButton(
            onPressed: () => _showPostOptions(post),
            icon: const Icon(
              Icons.more_horiz,
              color: AppTheme.darkerText,
            ),
          ),
        ],
      ),
    );
  }

  /// 顯示貼文選項
  void _showPostOptions(BookPost post) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              decoration: BoxDecoration(
                color: AppTheme.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.share, color: AppTheme.nearlyDarkBlue),
              title: const Text('分享貼文'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.bookmark_add, color: AppTheme.nearlyDarkBlue),
              title: const Text('收藏貼文'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.report, color: Colors.red),
              title: const Text('檢舉貼文'),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// 書籍圖片
  Widget _buildBookImage(BookPost post) {
    return Container(
      width: double.infinity,
      height: 280, // 稍微減少高度
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(int.parse('0xFF${post.bookCoverGradientStart.substring(1)}')),
            Color(int.parse('0xFF${post.bookCoverGradientEnd.substring(1)}')),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Container(
          width: 140, // 稍微減少尺寸
          height: 210,
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(4, 8),
                blurRadius: 16,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.menu_book,
                size: 40, // 調整圖示大小
                color: Color(int.parse('0xFF${post.bookCoverGradientEnd.substring(1)}')),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  post.bookTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14, // 調整字體大小
                    color: AppTheme.darkerText,
                  ),
                  maxLines: 2, // 限制行數
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  post.bookAuthor,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11, // 調整字體大小
                    color: AppTheme.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 互動按鈕
  Widget _buildInteractionButtons(BookPost post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                post.isLiked = !post.isLiked;
                if (post.isLiked) {
                  post.likesCount++;
                } else {
                  post.likesCount--;
                }
              });
            },
            icon: Icon(
              post.isLiked ? Icons.favorite : Icons.favorite_border,
              color: post.isLiked ? Colors.red : AppTheme.darkerText,
              size: 28,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.chat_bubble_outline,
              color: AppTheme.darkerText,
              size: 28,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.send_outlined,
              color: AppTheme.darkerText,
              size: 28,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              setState(() {
                post.isSaved = !post.isSaved;
              });
            },
            icon: Icon(
              post.isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: AppTheme.darkerText,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  /// 按讚數量
  Widget _buildLikesCount(BookPost post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        '${post.likesCount} 個讚',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: AppTheme.darkerText,
        ),
      ),
    );
  }

  /// 貼文內容
  Widget _buildPostContent(BookPost post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.darkerText,
          ),
          children: [
            TextSpan(
              text: post.userName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: ' ${post.caption}'),
          ],
        ),
      ),
    );
  }

  /// 留言預覽
  Widget _buildCommentsPreview(BookPost post) {
    if (post.comments.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post.comments.length > 1)
            Text(
              '查看全部 ${post.comments.length} 則留言',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.grey,
              ),
            ),
          ...post.comments.take(2).map((comment) => Padding(
                padding: const EdgeInsets.only(top: 2),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.darkerText,
                    ),
                    children: [
                      TextSpan(
                        text: comment.userName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' ${comment.text}'),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  /// 發布時間
  Widget _buildPostTime(BookPost post) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: Text(
        post.timeAgo,
        style: const TextStyle(
          fontSize: 12,
          color: AppTheme.grey,
        ),
      ),
    );
  }

  /// Stories 資料（使用真實照片網址）
  final List<StoryData> stories = [
    StoryData(
      name: 'Your Story', 
      hasNewStory: false, 
      avatarUrl: null,
    ),
    StoryData(
      name: 'Alice', 
      hasNewStory: true, 
      avatarUrl: 'https://images.unsplash.com/photo-14947901083755-2616b9f04bbc?w=150&h=150&fit=crop&crop=face',
    ),
    StoryData(
      name: 'Bob', 
      hasNewStory: true, 
      avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
    ),
    StoryData(
      name: 'Carol', 
      hasNewStory: false, 
      avatarUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
    ),
    StoryData(
      name: 'David', 
      hasNewStory: true, 
      avatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
    ),
    StoryData(
      name: 'Emma', 
      hasNewStory: false, 
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&h=150&fit=crop&crop=face',
    ),
    StoryData(
      name: 'Frank', 
      hasNewStory: true, 
      avatarUrl: 'https://images.unsplash.com/photo-1463453091185-61582044d556?w=150&h=150&fit=crop&crop=face',
    ),
  ];

  /// 貼文資料（使用真實照片網址）
  final List<BookPost> bookPosts = [
    BookPost(
      userName: 'alice_reads',
      userAvatarUrl: 'https://images.unsplash.com/photo-1494790108755-2616b612b47c?w=150&h=150&fit=crop&crop=face',
      location: '台北市立圖書館',
      bookTitle: '原子習慣',
      bookAuthor: 'James Clear',
      bookCoverGradientStart: '#FA7D82',
      bookCoverGradientEnd: '#FFB295',
      caption: '剛讀完這本改變我生活的書！小小的習慣改變，真的能帶來巨大的影響。推薦給想要改變自己的朋友們 📚✨ #原子習慣 #自我成長',
      likesCount: 24,
      timeAgo: '2小時前',
      comments: [
        Comment(userName: 'bob_books', text: '我也在讀這本！寫得真的很棒'),
        Comment(userName: 'carol_study', text: '謝謝推薦，馬上去買 📖'),
      ],
    ),
    BookPost(
      userName: 'book_lover_david',
      userAvatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
      location: '誠品書店信義店',
      bookTitle: '被討厭的勇氣',
      bookAuthor: '岸見一郎',
      bookCoverGradientStart: '#738AE6',
      bookCoverGradientEnd: '#5C5EDD',
      caption: '阿德勒心理學真的很有啟發性！學會不被他人期待綁架，活出真正的自己。這本書讓我重新思考人際關係 🤔💭 #被討厭的勇氣 #心理學',
      likesCount: 18,
      timeAgo: '5小時前',
      comments: [
        Comment(userName: 'emma', text: '這本我也很喜歡！'),
      ],
    ),
    BookPost(
      userName: 'reading_emma',
      userAvatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&h=150&fit=crop&crop=face',
      bookTitle: '挪威的森林',
      bookAuthor: '村上春樹',
      bookCoverGradientStart: '#FE95B6',
      bookCoverGradientEnd: '#FF5287',
      caption: '村上春樹的文字總是那麼療癒，在城市的喧囂中找到內心的寧靜。每次重讀都有不同的感受 🌲📖 #挪威的森林 #村上春樹',
      likesCount: 32,
      timeAgo: '1天前',
      comments: [
        Comment(userName: 'frank', text: '村上的書總是讓人沉醉'),
        Comment(userName: 'alice_reads', text: '我最愛的作家！'),
        Comment(userName: 'carol_study', text: '文字真的很美 ✨'),
      ],
    ),
  ];
}

/// Stories 資料模型
class StoryData {
  final String name;
  final bool hasNewStory;
  final String? avatarUrl;

  StoryData({
    required this.name,
    required this.hasNewStory,
    this.avatarUrl,
  });
}

/// 貼文資料模型
class BookPost {
  final String userName;
  final String? userAvatarUrl;
  final String? location;
  final String bookTitle;
  final String bookAuthor;
  final String bookCoverGradientStart;
  final String bookCoverGradientEnd;
  final String caption;
  int likesCount;
  final String timeAgo;
  final List<Comment> comments;
  bool isLiked;
  bool isSaved;

  BookPost({
    required this.userName,
    this.userAvatarUrl,
    this.location,
    required this.bookTitle,
    required this.bookAuthor,
    required this.bookCoverGradientStart,
    required this.bookCoverGradientEnd,
    required this.caption,
    required this.likesCount,
    required this.timeAgo,
    required this.comments,
    this.isLiked = false,
    this.isSaved = false,
  });
}

/// 留言資料模型
class Comment {
  final String userName;
  final String text;

  Comment({
    required this.userName,
    required this.text,
  });
}