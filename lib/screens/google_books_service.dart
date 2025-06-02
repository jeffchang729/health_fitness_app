// services/google_books_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

/// Google Books API 服務類別
/// 提供書籍搜尋、詳細資訊查詢等功能
class GoogleBooksService {
  static const String _baseUrl = 'https://www.googleapis.com/books/v1';
  
  /// Google Books API 金鑰（可選，有金鑰可提高請求限制）
  static const String? _apiKey = null; // 如需要可在此添加API金鑰

  /// 搜尋書籍
  /// 
  /// [query] 搜尋關鍵字
  /// [maxResults] 最大結果數量，預設20
  /// [startIndex] 起始索引，用於分頁，預設0
  /// [langRestrict] 語言限制，預設'zh-TW'
  static Future<GoogleBooksResponse> searchBooks({
    required String query,
    int maxResults = 20,
    int startIndex = 0,
    String langRestrict = 'zh-TW',
  }) async {
    try {
      // 建構API URL
      final Map<String, String> queryParams = {
        'q': query,
        'maxResults': maxResults.toString(),
        'startIndex': startIndex.toString(),
        'langRestrict': langRestrict,
        'printType': 'books',
        'orderBy': 'relevance',
      };

      // 如果有API金鑰則加入
      if (_apiKey != null) {
        queryParams['key'] = _apiKey;
      }

      final uri = Uri.parse('$_baseUrl/volumes').replace(
        queryParameters: queryParams,
      );

      print('搜尋書籍API請求: $uri');

      // 發送HTTP請求
      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(const Duration(seconds: 10));

      print('API回應狀態碼: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return GoogleBooksResponse.fromJson(data);
      } else {
        throw Exception('搜尋書籍失敗: HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('搜尋書籍錯誤: $e');
      throw Exception('搜尋書籍時發生錯誤: $e');
    }
  }

  /// 取得書籍詳細資訊
  /// 
  /// [volumeId] Google Books 的書籍ID
  static Future<BookItem> getBookDetails(String volumeId) async {
    try {
      final Map<String, String> queryParams = {};
      
      if (_apiKey != null) {
        queryParams['key'] = _apiKey;
      }

      final uri = Uri.parse('$_baseUrl/volumes/$volumeId').replace(
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return BookItem.fromJson(data);
      } else {
        throw Exception('取得書籍詳細資訊失敗: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('取得書籍詳細資訊時發生錯誤: $e');
    }
  }

  /// 根據分類搜尋書籍
  /// 
  /// [category] 書籍分類（例如：'自我成長', '商業', '心理學'）
  /// [maxResults] 最大結果數量
  static Future<GoogleBooksResponse> searchByCategory({
    required String category,
    int maxResults = 10,
  }) async {
    // 將中文分類轉換為英文搜尋關鍵字
    final Map<String, String> categoryMap = {
      '自我成長': 'self improvement personal development',
      '商業思維': 'business strategy management',
      '心理學': 'psychology mental health',
      '科技趨勢': 'technology innovation future',
      '投資理財': 'investing finance money management',
    };

    final searchQuery = categoryMap[category] ?? category;
    
    return await searchBooks(
      query: searchQuery,
      maxResults: maxResults,
      langRestrict: 'en', // 英文書籍通常有更好的封面圖片
    );
  }

  /// 搜尋熱門書籍
  /// 
  /// [maxResults] 最大結果數量
  static Future<GoogleBooksResponse> getPopularBooks({
    int maxResults = 20,
  }) async {
    // 搜尋一些熱門關鍵字
    const popularQueries = [
      'bestseller fiction',
      'popular non-fiction',
      'business books',
      'self help',
    ];

    try {
      // 隨機選擇一個熱門查詢
      final randomQuery = popularQueries[
        DateTime.now().millisecondsSinceEpoch % popularQueries.length
      ];

      return await searchBooks(
        query: randomQuery,
        maxResults: maxResults,
        langRestrict: 'en',
      );
    } catch (e) {
      throw Exception('取得熱門書籍時發生錯誤: $e');
    }
  }
}

/// Google Books API 回應資料模型
class GoogleBooksResponse {
  final String kind;
  final int totalItems;
  final List<BookItem> items;

  GoogleBooksResponse({
    required this.kind,
    required this.totalItems,
    required this.items,
  });

  factory GoogleBooksResponse.fromJson(Map<String, dynamic> json) {
    return GoogleBooksResponse(
      kind: json['kind'] ?? '',
      totalItems: json['totalItems'] ?? 0,
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => BookItem.fromJson(item))
          .toList() ?? [],
    );
  }

  /// 檢查是否有搜尋結果
  bool get hasResults => items.isNotEmpty;

  /// 取得格式化的結果摘要
  String get resultSummary => '找到 $totalItems 本書籍，顯示前 ${items.length} 本';
}

/// 書籍項目資料模型
class BookItem {
  final String id;
  final String title;
  final List<String> authors;
  final String? description;
  final String? publisher;
  final String? publishedDate;
  final int? pageCount;
  final List<String> categories;
  final double? averageRating;
  final int? ratingsCount;
  final String? language;
  final BookImageLinks? imageLinks;
  final String? previewLink;
  final String? infoLink;

  BookItem({
    required this.id,
    required this.title,
    required this.authors,
    this.description,
    this.publisher,
    this.publishedDate,
    this.pageCount,
    this.categories = const [],
    this.averageRating,
    this.ratingsCount,
    this.language,
    this.imageLinks,
    this.previewLink,
    this.infoLink,
  });

  factory BookItem.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] as Map<String, dynamic>? ?? {};
    
    return BookItem(
      id: json['id'] ?? '',
      title: volumeInfo['title'] ?? '未知書名',
      authors: (volumeInfo['authors'] as List<dynamic>?)
          ?.map((author) => author.toString())
          .toList() ?? ['未知作者'],
      description: volumeInfo['description'],
      publisher: volumeInfo['publisher'],
      publishedDate: volumeInfo['publishedDate'],
      pageCount: volumeInfo['pageCount'],
      categories: (volumeInfo['categories'] as List<dynamic>?)
          ?.map((category) => category.toString())
          .toList() ?? [],
      averageRating: volumeInfo['averageRating']?.toDouble(),
      ratingsCount: volumeInfo['ratingsCount'],
      language: volumeInfo['language'],
      imageLinks: volumeInfo['imageLinks'] != null 
          ? BookImageLinks.fromJson(volumeInfo['imageLinks'])
          : null,
      previewLink: volumeInfo['previewLink'],
      infoLink: volumeInfo['infoLink'],
    );
  }

  /// 取得書籍封面圖片URL（優先使用高解析度）
  String? get coverImageUrl {
    if (imageLinks == null) return null;
    
    // 優先順序：large -> medium -> small -> thumbnail
    return imageLinks!.large ?? 
           imageLinks!.medium ?? 
           imageLinks!.small ?? 
           imageLinks!.thumbnail;
  }

  /// 取得作者字串（多位作者用逗號分隔）
  String get authorsString => authors.join(', ');

  /// 取得分類字串（多個分類用逗號分隔）
  String get categoriesString => categories.join(', ');

  /// 取得簡短描述（限制字數）
  String getShortDescription(int maxLength) {
    if (description == null || description!.isEmpty) {
      return '暫無描述';
    }
    
    if (description!.length <= maxLength) {
      return description!;
    }
    
    return '${description!.substring(0, maxLength)}...';
  }

  /// 檢查是否有封面圖片
  bool get hasCoverImage => coverImageUrl != null && coverImageUrl!.isNotEmpty;

  /// 取得評分星級字串
  String get ratingString {
    if (averageRating == null) return '暫無評分';
    return '${averageRating!.toStringAsFixed(1)} 星';
  }
}

/// 書籍圖片連結資料模型
class BookImageLinks {
  final String? smallThumbnail;
  final String? thumbnail;
  final String? small;
  final String? medium;
  final String? large;
  final String? extraLarge;

  BookImageLinks({
    this.smallThumbnail,
    this.thumbnail,
    this.small,
    this.medium,
    this.large,
    this.extraLarge,
  });

  factory BookImageLinks.fromJson(Map<String, dynamic> json) {
    return BookImageLinks(
      smallThumbnail: json['smallThumbnail'],
      thumbnail: json['thumbnail'],
      small: json['small'],
      medium: json['medium'],
      large: json['large'],
      extraLarge: json['extraLarge'],
    );
  }
}