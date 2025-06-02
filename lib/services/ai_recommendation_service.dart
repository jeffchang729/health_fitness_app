// services/ai_recommendation_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'google_books_service.dart';

/// AI 推薦服務
/// 結合 Google Books API 和 AI 模型提供智慧書籍推薦
class AIRecommendationService {
  /// 志向分類清單
  static List<AspirationCategory> getAspirationCategories() {
    return [
      AspirationCategory(
        id: 'self_growth',
        title: '自我成長',
        subtitle: '成為更好的自己',
        description: '透過持續學習和自我反思，提升個人能力和品格',
        colors: ['#FA7D82', '#FFB295'],
        icon: 'trending_up',
        keywords: ['自我成長', '個人發展', '習慣養成', '目標設定', '時間管理'],
        englishKeywords: ['self improvement', 'personal development', 'habits', 'goal setting', 'time management'],
      ),
      AspirationCategory(
        id: 'leadership',
        title: '領導能力',
        subtitle: '成為優秀領導者',
        description: '學習如何激勵團隊、做出明智決策並建立有效的領導風格',
        colors: ['#738AE6', '#5C5EDD'],
        icon: 'groups',
        keywords: ['領導力', '管理', '團隊合作', '決策', '激勵'],
        englishKeywords: ['leadership', 'management', 'team building', 'decision making', 'motivation'],
      ),
      AspirationCategory(
        id: 'creativity',
        title: '創意思考',
        subtitle: '激發無限創意',
        description: '培養創新思維，學會從不同角度思考問題並找到創意解決方案',
        colors: ['#FE95B6', '#FF5287'],
        icon: 'lightbulb',
        keywords: ['創意', '創新', '設計思維', '問題解決', '想像力'],
        englishKeywords: ['creativity', 'innovation', 'design thinking', 'problem solving', 'imagination'],
      ),
      AspirationCategory(
        id: 'efficiency',
        title: '效率提升',
        subtitle: '提高工作效率',
        description: '掌握高效工作方法，優化流程，達到更好的工作生活平衡',
        colors: ['#6F72CA', '#1E1466'],
        icon: 'speed',
        keywords: ['效率', '生產力', '工作方法', '專注力', '流程優化'],
        englishKeywords: ['efficiency', 'productivity', 'work methods', 'focus', 'process optimization'],
      ),
      AspirationCategory(
        id: 'communication',
        title: '溝通技巧',
        subtitle: '改善人際關係',
        description: '學習有效溝通技巧，建立良好人際關係，提升社交能力',
        colors: ['#FF9A9E', '#FECFEF'],
        icon: 'forum',
        keywords: ['溝通', '人際關係', '社交', '表達', '傾聽'],
        englishKeywords: ['communication', 'interpersonal skills', 'social skills', 'expression', 'listening'],
      ),
    ];
  }

  /// 根據查詢獲取 AI 推薦
  static Future<List<BookItem>> getRecommendationsByQuery(String query) async {
    try {
      // 分析查詢意圖
      final intent = _analyzeIntent(query);
      
      // 生成搜尋關鍵字
      final searchKeywords = _generateSearchKeywords(query, intent);
      
      // 從 Google Books API 獲取書籍
      final books = <BookItem>[];
      
      for (final keyword in searchKeywords) {
        try {
          final response = await GoogleBooksService.searchBooks(
            query: keyword,
            maxResults: 10,
            langRestrict: 'en', // 英文書籍通常有更好的封面和資訊
          );
          books.addAll(response.items);
        } catch (e) {
          print('搜尋關鍵字 "$keyword" 失敗: $e');
        }
      }
      
      // 去重並評分排序
      final uniqueBooks = _removeDuplicates(books);
      final scoredBooks = _scoreBooks(uniqueBooks, query, intent);
      
      // 返回前 20 本評分最高的書籍
      scoredBooks.sort((a, b) => b.aiScore.compareTo(a.aiScore));
      return scoredBooks.take(20).toList();
      
    } catch (e) {
      throw Exception('AI 推薦失敗: $e');
    }
  }

  /// 根據志向分類獲取推薦
  static Future<List<BookItem>> getRecommendationsByCategory(AspirationCategory category) async {
    try {
      final books = <BookItem>[];
      
      // 使用英文關鍵字搜尋
      for (final keyword in category.englishKeywords) {
        try {
          final response = await GoogleBooksService.searchBooks(
            query: keyword,
            maxResults: 8,
            langRestrict: 'en',
          );
          books.addAll(response.items);
        } catch (e) {
          print('搜尋分類 "${category.title}" 關鍵字 "$keyword" 失敗: $e');
        }
      }
      
      // 去重並評分排序
      final uniqueBooks = _removeDuplicates(books);
      final scoredBooks = _scoreBooksForCategory(uniqueBooks, category);
      
      // 返回前 15 本評分最高的書籍
      scoredBooks.sort((a, b) => b.aiScore.compareTo(a.aiScore));
      return scoredBooks.take(15).toList();
      
    } catch (e) {
      throw Exception('分類推薦失敗: $e');
    }
  }

  /// 分析使用者意圖
  static Map<String, dynamic> _analyzeIntent(String query) {
    final lowerQuery = query.toLowerCase();
    
    // 檢測意圖類型
    String intentType = 'general';
    double confidence = 0.5;
    
    if (lowerQuery.contains('領導') || lowerQuery.contains('管理') || lowerQuery.contains('boss')) {
      intentType = 'leadership';
      confidence = 0.8;
    } else if (lowerQuery.contains('自我') || lowerQuery.contains('成長') || lowerQuery.contains('提升')) {
      intentType = 'self_growth';
      confidence = 0.8;
    } else if (lowerQuery.contains('創意') || lowerQuery.contains('創新') || lowerQuery.contains('設計')) {
      intentType = 'creativity';
      confidence = 0.8;
    } else if (lowerQuery.contains('效率') || lowerQuery.contains('生產力') || lowerQuery.contains('時間')) {
      intentType = 'efficiency';
      confidence = 0.8;
    } else if (lowerQuery.contains('溝通') || lowerQuery.contains('人際') || lowerQuery.contains('社交')) {
      intentType = 'communication';
      confidence = 0.8;
    }
    
    return {
      'type': intentType,
      'confidence': confidence,
      'keywords': _extractKeywords(query),
    };
  }

  /// 提取關鍵字
  static List<String> _extractKeywords(String query) {
    // 簡單的關鍵字提取（實際應用中可以使用更複雜的 NLP 技術）
    final keywords = <String>[];
    
    // 常見的目標關鍵字對應
    final keywordMap = {
      '領導': ['leadership', 'management', 'executive'],
      '管理': ['management', 'leadership', 'business'],
      '自我成長': ['self improvement', 'personal development', 'growth'],
      '提升': ['improvement', 'enhancement', 'development'],
      '創意': ['creativity', 'innovation', 'creative thinking'],
      '創新': ['innovation', 'creativity', 'breakthrough'],
      '效率': ['efficiency', 'productivity', 'time management'],
      '生產力': ['productivity', 'efficiency', 'performance'],
      '溝通': ['communication', 'interpersonal', 'social skills'],
      '人際': ['interpersonal', 'social', 'relationships'],
    };
    
    for (final entry in keywordMap.entries) {
      if (query.contains(entry.key)) {
        keywords.addAll(entry.value);
      }
    }
    
    // 如果沒有匹配到特定關鍵字，使用通用關鍵字
    if (keywords.isEmpty) {
      keywords.addAll(['self help', 'personal development', 'business', 'psychology']);
    }
    
    return keywords;
  }

  /// 生成搜尋關鍵字
  static List<String> _generateSearchKeywords(String query, Map<String, dynamic> intent) {
    final keywords = <String>[];
    
    // 基於意圖類型生成關鍵字
    switch (intent['type']) {
      case 'leadership':
        keywords.addAll([
          'leadership development',
          'management skills',
          'executive coaching',
          'team leadership',
          'business leadership'
        ]);
        break;
      case 'self_growth':
        keywords.addAll([
          'self improvement',
          'personal development',
          'habits formation',
          'goal achievement',
          'mindset change'
        ]);
        break;
      case 'creativity':
        keywords.addAll([
          'creative thinking',
          'innovation methods',
          'design thinking',
          'brainstorming techniques',
          'creative problem solving'
        ]);
        break;
      case 'efficiency':
        keywords.addAll([
          'productivity methods',
          'time management',
          'work efficiency',
          'performance optimization',
          'focus techniques'
        ]);
        break;
      case 'communication':
        keywords.addAll([
          'communication skills',
          'interpersonal skills',
          'social intelligence',
          'public speaking',
          'relationship building'
        ]);
        break;
      default:
        keywords.addAll([
          'self help',
          'personal development',
          'business success',
          'psychology',
          'motivation'
        ]);
    }
    
    // 加入從查詢中提取的關鍵字
    keywords.addAll(intent['keywords'] as List<String>);
    
    return keywords.take(5).toList(); // 限制關鍵字數量
  }

  /// 移除重複書籍
  static List<BookItem> _removeDuplicates(List<BookItem> books) {
    final seen = <String>{};
    final uniqueBooks = <BookItem>[];
    
    for (final book in books) {
      final key = '${book.title.toLowerCase()}_${book.authors.join(',').toLowerCase()}';
      if (!seen.contains(key)) {
        seen.add(key);
        uniqueBooks.add(book);
      }
    }
    
    return uniqueBooks;
  }

  /// 為書籍評分
  static List<BookItem> _scoreBooks(List<BookItem> books, String query, Map<String, dynamic> intent) {
    final scoredBooks = <BookItem>[];
    
    for (final book in books) {
      double score = 0.0;
      
      // 基礎分數（基於評分和評論數）
      if (book.averageRating != null) {
        score += book.averageRating! * 0.2;
      }
      
      if (book.ratingsCount != null && book.ratingsCount! > 0) {
        score += (book.ratingsCount! / 1000).clamp(0.0, 2.0);
      }
      
      // 標題匹配分數
      final titleScore = _calculateTextMatchScore(book.title.toLowerCase(), query.toLowerCase());
      score += titleScore * 3.0;
      
      // 描述匹配分數
      if (book.description != null) {
        final descScore = _calculateTextMatchScore(book.description!.toLowerCase(), query.toLowerCase());
        score += descScore * 2.0;
      }
      
      // 分類匹配分數
      final categoryScore = _calculateCategoryMatchScore(book.categories, intent['type']);
      score += categoryScore * 1.5;
      
      // 作者知名度分數（簡化實現）
      if (book.authors.any((author) => _isWellKnownAuthor(author))) {
        score += 1.0;
      }
      
      // 出版日期分數（較新的書籍略加分）
      if (book.publishedDate != null) {
        final year = _extractYear(book.publishedDate!);
        if (year != null && year > 2015) {
          score += 0.5;
        }
      }
      
      final scoredBook = BookItem(
        id: book.id,
        title: book.title,
        authors: book.authors,
        description: book.description,
        publisher: book.publisher,
        publishedDate: book.publishedDate,
        pageCount: book.pageCount,
        categories: book.categories,
        averageRating: book.averageRating,
        ratingsCount: book.ratingsCount,
        language: book.language,
        imageLinks: book.imageLinks,
        previewLink: book.previewLink,
        infoLink: book.infoLink,
      );
      
      // 添加 AI 評分
      (scoredBook as dynamic).aiScore = score;
      scoredBooks.add(scoredBook);
    }
    
    return scoredBooks;
  }

  /// 為分類推薦評分
  static List<BookItem> _scoreBooksForCategory(List<BookItem> books, AspirationCategory category) {
    final scoredBooks = <BookItem>[];
    
    for (final book in books) {
      double score = 0.0;
      
      // 基礎分數
      if (book.averageRating != null) {
        score += book.averageRating! * 0.3;
      }
      
      if (book.ratingsCount != null && book.ratingsCount! > 0) {
        score += (book.ratingsCount! / 1000).clamp(0.0, 2.0);
      }
      
      // 關鍵字匹配分數
      for (final keyword in category.englishKeywords) {
        if (book.title.toLowerCase().contains(keyword.toLowerCase())) {
          score += 2.0;
        }
        if (book.description?.toLowerCase().contains(keyword.toLowerCase()) == true) {
          score += 1.0;
        }
      }
      
      // 分類匹配分數
      final categoryScore = _calculateCategoryMatchScore(book.categories, category.id);
      score += categoryScore * 2.0;
      
      final scoredBook = BookItem(
        id: book.id,
        title: book.title,
        authors: book.authors,
        description: book.description,
        publisher: book.publisher,
        publishedDate: book.publishedDate,
        pageCount: book.pageCount,
        categories: book.categories,
        averageRating: book.averageRating,
        ratingsCount: book.ratingsCount,
        language: book.language,
        imageLinks: book.imageLinks,
        previewLink: book.previewLink,
        infoLink: book.infoLink,
      );
      
      (scoredBook as dynamic).aiScore = score;
      scoredBooks.add(scoredBook);
    }
    
    return scoredBooks;
  }

  /// 計算文字匹配分數
  static double _calculateTextMatchScore(String text, String query) {
    final queryWords = query.split(' ');
    int matchCount = 0;
    
    for (final word in queryWords) {
      if (word.length > 2 && text.contains(word)) {
        matchCount++;
      }
    }
    
    return queryWords.isNotEmpty ? matchCount / queryWords.length : 0.0;
  }

  /// 計算分類匹配分數
  static double _calculateCategoryMatchScore(List<String> bookCategories, String intentType) {
    final categoryMap = {
      'leadership': ['business', 'management', 'leadership', 'economics'],
      'self_growth': ['self-help', 'psychology', 'personal development', 'motivation'],
      'creativity': ['art', 'design', 'creativity', 'innovation'],
      'efficiency': ['business', 'productivity', 'time management', 'self-help'],
      'communication': ['psychology', 'communication', 'social', 'relationships'],
    };
    
    final targetCategories = categoryMap[intentType] ?? [];
    double score = 0.0;
    
    for (final bookCategory in bookCategories) {
      for (final targetCategory in targetCategories) {
        if (bookCategory.toLowerCase().contains(targetCategory.toLowerCase())) {
          score += 1.0;
        }
      }
    }
    
    return score;
  }

  /// 檢查是否為知名作者
  static bool _isWellKnownAuthor(String author) {
    final wellKnownAuthors = [
      'Stephen Covey',
      'Dale Carnegie',
      'Tony Robbins',
      'Malcolm Gladwell',
      'Daniel Kahneman',
      'Carol Dweck',
      'Simon Sinek',
      'Brené Brown',
      'James Clear',
      'Cal Newport',
    ];
    
    return wellKnownAuthors.any((knownAuthor) => 
      author.toLowerCase().contains(knownAuthor.toLowerCase()));
  }

  /// 提取年份
  static int? _extractYear(String dateString) {
    final yearRegex = RegExp(r'(\d{4})');
    final match = yearRegex.firstMatch(dateString);
    return match != null ? int.tryParse(match.group(1)!) : null;
  }
}

/// 志向分類資料模型
class AspirationCategory {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final List<String> colors;
  final String icon;
  final List<String> keywords;
  final List<String> englishKeywords;

  AspirationCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.colors,
    required this.icon,
    required this.keywords,
    required this.englishKeywords,
  });
}

/// 擴展 BookItem 以支援 AI 評分
extension BookItemAI on BookItem {
  double get aiScore => (this as dynamic).aiScore ?? 0.0;
}