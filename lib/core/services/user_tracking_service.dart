// services/user_tracking_service.dart

import '../services/google_books_service.dart';

/// 使用者行為追蹤服務
/// 
/// 負責記錄使用者的搜尋行為、書籍互動、志向設定等資訊
/// 用於個人化推薦和使用統計分析
class UserTrackingService {
  static final UserTrackingService _instance = UserTrackingService._internal();
  
  factory UserTrackingService() {
    return _instance;
  }
  
  UserTrackingService._internal();

  /// 使用者志向記錄
  final List<String> _userGoals = [];
  
  /// 書籍互動記錄
  final List<BookInteraction> _bookInteractions = [];
  
  /// 搜尋歷史記錄
  final List<SearchRecord> _searchHistory = [];

  /// 記錄使用者志向
  /// 
  /// [goal] 使用者設定的志向目標
  void trackUserGoal(String goal) {
    if (!_userGoals.contains(goal)) {
      _userGoals.add(goal);
      print('🎯 使用者志向記錄：$goal');
    }
  }

  /// 記錄書籍互動行為
  /// 
  /// [book] 使用者點擊的書籍資訊
  void trackBookInteraction(BookSearchResult book) {
    final interaction = BookInteraction(
      bookId: book.id,
      title: book.title,
      authors: book.authors,
      timestamp: DateTime.now(),
      interactionType: InteractionType.view,
    );
    
    _bookInteractions.add(interaction);
    print('📚 書籍互動記錄：${book.title}');
  }

  /// 記錄搜尋行為
  /// 
  /// [query] 搜尋關鍵字
  /// [isAIMode] 是否為AI推薦模式
  /// [resultCount] 搜尋結果數量
  void trackSearch(String query, bool isAIMode, int resultCount) {
    final searchRecord = SearchRecord(
      query: query,
      isAIMode: isAIMode,
      resultCount: resultCount,
      timestamp: DateTime.now(),
    );
    
    _searchHistory.add(searchRecord);
    print('🔍 搜尋記錄：$query (${isAIMode ? 'AI模式' : '一般模式'}) - $resultCount 筆結果');
  }

  /// 記錄書籍加入書單
  /// 
  /// [book] 加入書單的書籍
  void trackBookAddToLibrary(BookSearchResult book) {
    final interaction = BookInteraction(
      bookId: book.id,
      title: book.title,
      authors: book.authors,
      timestamp: DateTime.now(),
      interactionType: InteractionType.addToLibrary,
    );
    
    _bookInteractions.add(interaction);
    print('➕ 書籍加入書單：${book.title}');
  }

  /// 記錄書籍分享
  /// 
  /// [book] 分享的書籍
  void trackBookShare(BookSearchResult book) {
    final interaction = BookInteraction(
      bookId: book.id,
      title: book.title,
      authors: book.authors,
      timestamp: DateTime.now(),
      interactionType: InteractionType.share,
    );
    
    _bookInteractions.add(interaction);
    print('📤 書籍分享：${book.title}');
  }

  /// 取得使用者志向清單
  List<String> getUserGoals() {
    return List.from(_userGoals);
  }

  /// 取得書籍互動歷史
  List<BookInteraction> getBookInteractions({int? limit}) {
    final interactions = List<BookInteraction>.from(_bookInteractions);
    interactions.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    if (limit != null && limit > 0) {
      return interactions.take(limit).toList();
    }
    
    return interactions;
  }

  /// 取得搜尋歷史
  List<SearchRecord> getSearchHistory({int? limit}) {
    final history = List<SearchRecord>.from(_searchHistory);
    history.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    if (limit != null && limit > 0) {
      return history.take(limit).toList();
    }
    
    return history;
  }

  /// 取得最常互動的書籍分類
  List<String> getMostInteractedCategories() {
    final categoryCount = <String, int>{};
    
    for (final interaction in _bookInteractions) {
      // 這裡可以根據書籍的分類資訊進行統計
      // 暫時使用作者作為示例
      for (final author in interaction.authors) {
        categoryCount[author] = (categoryCount[author] ?? 0) + 1;
      }
    }
    
    final sortedCategories = categoryCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedCategories.map((e) => e.key).take(5).toList();
  }

  /// 取得使用統計
  UserStats getUserStats() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // 計算今日互動次數
    final todayInteractions = _bookInteractions
        .where((interaction) => 
            interaction.timestamp.isAfter(today))
        .length;
    
    // 計算今日搜尋次數
    final todaySearches = _searchHistory
        .where((search) => 
            search.timestamp.isAfter(today))
        .length;
    
    return UserStats(
      totalInteractions: _bookInteractions.length,
      todayInteractions: todayInteractions,
      totalSearches: _searchHistory.length,
      todaySearches: todaySearches,
      totalGoals: _userGoals.length,
      mostActiveCategory: getMostInteractedCategories().isNotEmpty 
          ? getMostInteractedCategories().first 
          : '無資料',
    );
  }

  /// 清除所有追蹤資料
  void clearAllData() {
    _userGoals.clear();
    _bookInteractions.clear();
    _searchHistory.clear();
    print('🗑️ 已清除所有使用者追蹤資料');
  }
}

/// 書籍互動記錄
class BookInteraction {
  final String bookId;
  final String title;
  final List<String> authors;
  final DateTime timestamp;
  final InteractionType interactionType;

  BookInteraction({
    required this.bookId,
    required this.title,
    required this.authors,
    required this.timestamp,
    required this.interactionType,
  });

  @override
  String toString() {
    return 'BookInteraction(title: $title, type: $interactionType, time: $timestamp)';
  }
}

/// 搜尋記錄
class SearchRecord {
  final String query;
  final bool isAIMode;
  final int resultCount;
  final DateTime timestamp;

  SearchRecord({
    required this.query,
    required this.isAIMode,
    required this.resultCount,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'SearchRecord(query: $query, aiMode: $isAIMode, results: $resultCount, time: $timestamp)';
  }
}

/// 互動類型枚舉
enum InteractionType {
  /// 檢視書籍詳情
  view,
  
  /// 加入個人書單
  addToLibrary,
  
  /// 分享書籍
  share,
  
  /// 評分書籍
  rate,
  
  /// 收藏書籍
  favorite,
}

/// 使用者統計資料
class UserStats {
  final int totalInteractions;
  final int todayInteractions;
  final int totalSearches;
  final int todaySearches;
  final int totalGoals;
  final String mostActiveCategory;

  UserStats({
    required this.totalInteractions,
    required this.todayInteractions,
    required this.totalSearches,
    required this.todaySearches,
    required this.totalGoals,
    required this.mostActiveCategory,
  });

  @override
  String toString() {
    return '''
使用者統計資料：
- 總互動次數：$totalInteractions
- 今日互動次數：$todayInteractions  
- 總搜尋次數：$totalSearches
- 今日搜尋次數：$todaySearches
- 設定志向數量：$totalGoals
- 最活躍分類：$mostActiveCategory
''';
  }
}