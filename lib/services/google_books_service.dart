// lib/services/google_books_service.dart - 型別安全修正版

import 'dart:convert';
import 'package:http/http.dart' as http;

/// Google Books API 服務類別
class GoogleBooksService {
  /// Google Books API 基礎網址
  static const String _baseUrl = 'https://www.googleapis.com/books/v1/volumes';

  /// 搜尋書籍
  /// [query] 搜尋關鍵字
  /// [maxResults] 最大結果數量 (預設 20)
  /// [startIndex] 起始索引 (預設 0，用於分頁)
  static Future<List<BookModel>> searchBooks({
    required String query,
    int maxResults = 20,
    int startIndex = 0,
  }) async {
    try {
      // 建構查詢網址（不需要 API Key）
      final String url = '$_baseUrl?q=${Uri.encodeComponent(query)}'
          '&maxResults=$maxResults'
          '&startIndex=$startIndex';

      // 發送 HTTP 請求
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // 解析 JSON 回應
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> items = data['items'] ?? [];

        // 轉換為 BookModel 列表
        return items.map((item) => BookModel.fromJson(item)).toList();
      } else {
        throw Exception('搜尋失敗: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('網路錯誤: $e');
    }
  }

  /// 根據志向類別搜尋相關書籍
  /// [aspiration] 志向類別 (例如：「成功的企業家」)
  static Future<List<BookModel>> searchByAspiration(String aspiration) async {
    // 將志向轉換為更好的搜尋關鍵字
    String searchQuery = _convertAspirationToSearchQuery(aspiration);
    
    return await searchBooks(
      query: searchQuery,
      maxResults: 10,
    );
  }

  /// 將志向轉換為搜尋關鍵字
  static String _convertAspirationToSearchQuery(String aspiration) {
    final Map<String, String> aspirationKeywords = {
      '成功的企業家': 'entrepreneurship business success startup',
      '投資達人': 'investment finance wealth building',
      '有影響力的人': 'leadership influence communication',
      '優秀的領導者': 'leadership management team building',
      '創意工作者': 'creativity innovation design thinking',
      '心理健康的人': 'mental health psychology wellness',
      '終身學習者': 'learning education self development',
      '有智慧的人': 'wisdom philosophy personal growth',
    };

    return aspirationKeywords[aspiration] ?? aspiration;
  }

  /// 獲取書籍詳細資訊
  /// [volumeId] Google Books 書籍 ID
  static Future<BookModel> getBookDetails(String volumeId) async {
    try {
      final String url = '$_baseUrl/$volumeId';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return BookModel.fromJson(data);
      } else {
        throw Exception('取得書籍詳情失敗: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('網路錯誤: $e');
    }
  }
}

/// 書籍資料模型 (配合現有專案的 BookSearchResult)
class BookModel {
  final String id;
  final String title;
  final List<String> authors;
  final String description;  // 改為非 null，提供預設值
  final String? thumbnail;
  final String? publishedDate;
  final String? publisher;
  final int? pageCount;
  final double? averageRating;
  final int? ratingsCount;
  final List<String> categories;
  final String? language;
  final String? previewLink;
  final String? infoLink;

  BookModel({
    required this.id,
    required this.title,
    required this.authors,
    String? description,  // 接收可為 null 的參數
    this.thumbnail,
    this.publishedDate,
    this.publisher,
    this.pageCount,
    this.averageRating,
    this.ratingsCount,
    this.categories = const [],
    this.language,
    this.previewLink,
    this.infoLink,
  }) : description = description ?? '暫無描述';  // 提供預設值

  /// 從 Google Books API JSON 建立 BookModel
  factory BookModel.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    final imageLinks = volumeInfo['imageLinks'] ?? {};
    
    // 獲取書籍封面 URL，優先使用較高解析度的版本
    String? thumbnailUrl;
    if (imageLinks['large'] != null) {
      thumbnailUrl = imageLinks['large'];
    } else if (imageLinks['medium'] != null) {
      thumbnailUrl = imageLinks['medium'];
    } else if (imageLinks['thumbnail'] != null) {
      thumbnailUrl = imageLinks['thumbnail'];
    } else if (imageLinks['smallThumbnail'] != null) {
      thumbnailUrl = imageLinks['smallThumbnail'];
    }
    
    // 確保使用 HTTPS
    if (thumbnailUrl != null) {
      thumbnailUrl = thumbnailUrl.replaceFirst('http://', 'https://');
      // 提升圖片品質參數
      if (thumbnailUrl.contains('books.google.com')) {
        thumbnailUrl = thumbnailUrl.replaceAll('&zoom=1', '&zoom=3');
        if (!thumbnailUrl.contains('zoom=')) {
          thumbnailUrl += '&zoom=3';
        }
      }
    }
    
    // 清理描述中的 HTML 標籤
    String? rawDescription = volumeInfo['description'];
    String cleanDescription = '暫無描述';
    
    if (rawDescription != null && rawDescription.isNotEmpty) {
      cleanDescription = rawDescription
          .replaceAll(RegExp(r'<[^>]*>'), '')
          .replaceAll(RegExp(r'\s+'), ' ')
          .replaceAll('&nbsp;', ' ')
          .replaceAll('&amp;', '&')
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>')
          .replaceAll('&quot;', '"')
          .trim();
      
      if (cleanDescription.isEmpty) {
        cleanDescription = '暫無描述';
      }
    }
    
    return BookModel(
      id: json['id'] ?? '',
      title: volumeInfo['title'] ?? '未知標題',
      authors: List<String>.from(volumeInfo['authors'] ?? ['未知作者']),
      description: cleanDescription,
      thumbnail: thumbnailUrl, // 使用處理過的封面 URL
      publishedDate: volumeInfo['publishedDate'],
      publisher: volumeInfo['publisher'],
      pageCount: volumeInfo['pageCount'],
      averageRating: volumeInfo['averageRating']?.toDouble(),
      ratingsCount: volumeInfo['ratingsCount'],
      categories: List<String>.from(volumeInfo['categories'] ?? []),
      language: volumeInfo['language'],
      previewLink: volumeInfo['previewLink'],
      infoLink: volumeInfo['infoLink'],
    );
  }

  /// 轉換為 BookSearchResult (配合現有專案)
  BookSearchResult toBookSearchResult() {
    return BookSearchResult(
      id: id,
      title: title,
      authors: authors,
      description: description,
      thumbnail: thumbnail,
      publishedDate: publishedDate,
      publisher: publisher,
      pageCount: pageCount,
      averageRating: averageRating,
      ratingsCount: ratingsCount,
      categories: categories,
      language: language,
      previewLink: previewLink,
      infoLink: infoLink,
    );
  }

  /// 轉換為 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'authors': authors,
      'description': description,
      'thumbnail': thumbnail,
      'publishedDate': publishedDate,
      'publisher': publisher,
      'pageCount': pageCount,
      'averageRating': averageRating,
      'ratingsCount': ratingsCount,
      'categories': categories,
      'language': language,
      'previewLink': previewLink,
      'infoLink': infoLink,
    };
  }

  /// 取得格式化的作者字串
  String get authorsString {
    if (authors.isEmpty) return '未知作者';
    return authors.join(', ');
  }

  /// 取得安全的縮圖網址 (HTTPS)
  String? get safeThumbnail {
    if (thumbnail == null) return null;
    return thumbnail!.replaceFirst('http://', 'https://');
  }
}

/// BookSearchResult 類別 (配合現有專案結構) - 型別安全版
class BookSearchResult {
  final String id;
  final String title;
  final List<String> authors;
  final String description;  // 改為非 null，確保型別安全
  final String? thumbnail;
  final String? publishedDate;
  final String? publisher;
  final int? pageCount;
  final double? averageRating;
  final int? ratingsCount;
  final List<String> categories;
  final String? language;
  final String? previewLink;
  final String? infoLink;

  BookSearchResult({
    required this.id,
    required this.title,
    required this.authors,
    String? description,  // 接收可為 null 的參數
    this.thumbnail,
    this.publishedDate,
    this.publisher,
    this.pageCount,
    this.averageRating,
    this.ratingsCount,
    this.categories = const [],
    this.language,
    this.previewLink,
    this.infoLink,
  }) : description = description ?? '暫無描述';  // 提供預設值確保非 null

  /// 取得格式化的作者字串
  String get authorsString {
    if (authors.isEmpty) return '未知作者';
    return authors.join(', ');
  }

  /// 取得作者文字 (別名，為了保持一致性)
  String get authorsText => authorsString;

  /// 取得安全的縮圖網址 (HTTPS)
  String? get safeThumbnail {
    if (thumbnail == null) return null;
    return thumbnail!.replaceFirst('http://', 'https://');
  }

  /// 取得評分文字
  String get ratingText {
    if (averageRating == null) return '無評分';
    return averageRating!.toStringAsFixed(1);
  }

  /// 取得頁數文字
  String get pageCountText {
    if (pageCount == null) return '未知頁數';
    return '$pageCount 頁';
  }

  /// 取得分類文字
  String get categoriesText {
    if (categories.isEmpty) return '未分類';
    return categories.join(', ');
  }

  /// 取得簡短描述 (限制字數) - 現在 description 永遠不會為 null
  String get shortDescription {
    if (description.isEmpty) {
      return '暫無描述';
    }
    
    if (description.length > 150) {
      return '${description.substring(0, 150)}...';
    }
    
    return description;
  }

  /// 從 JSON 建立物件
  factory BookSearchResult.fromJson(Map<String, dynamic> json) {
    return BookSearchResult(
      id: json['id'] ?? '',
      title: json['title'] ?? '未知標題',
      authors: List<String>.from(json['authors'] ?? ['未知作者']),
      description: json['description'], // 可能為 null，建構函式會處理
      thumbnail: json['thumbnail'],
      publishedDate: json['publishedDate'],
      publisher: json['publisher'],
      pageCount: json['pageCount'],
      averageRating: json['averageRating']?.toDouble(),
      ratingsCount: json['ratingsCount'],
      categories: List<String>.from(json['categories'] ?? []),
      language: json['language'],
      previewLink: json['previewLink'],
      infoLink: json['infoLink'],
    );
  }

  /// 轉換為 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'authors': authors,
      'description': description,
      'thumbnail': thumbnail,
      'publishedDate': publishedDate,
      'publisher': publisher,
      'pageCount': pageCount,
      'averageRating': averageRating,
      'ratingsCount': ratingsCount,
      'categories': categories,
      'language': language,
      'previewLink': previewLink,
      'infoLink': infoLink,
    };
  }
}