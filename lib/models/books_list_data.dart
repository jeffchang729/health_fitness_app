// models/books_list_data.dart

/// 書籍資料模型 - 使用網路圖片
/// 
/// 用於表示推薦書籍的完整資訊，完全對應健身APP的MealsListData結構
/// 包含：
/// - 網路圖片路徑和顯示名稱
/// - 漸層顏色配置
/// - 書籍清單和評分計算
class BooksListData {
  BooksListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.startColor = '',
    this.endColor = '',
    this.books,
    this.rating,
  });

  /// 書籍封面網路圖片URL（如果為空則使用預設圖示）
  String imagePath;
  
  /// 書籍類別或主題名稱
  String titleTxt;
  
  /// 漸層開始顏色（十六進位格式）
  String startColor;
  
  /// 漸層結束顏色（十六進位格式）
  String endColor;
  
  /// 書籍項目清單（作者、類型等）
  List<String>? books;
  
  /// 評分數值（null表示顯示新增按鈕）
  double? rating;

  /// 預設書籍推薦資料清單 - 使用真實網路書籍封面
  /// 
  /// 包含四種書籍類別的預設配置：
  /// - 自我成長：原子習慣系列 (4.8星)
  /// - 商業思維：商業書籍合集 (4.6星)
  /// - 心理學：心理學經典 (建議探索)
  /// - 科技趨勢：未來科技 (建議探索)
  static List<BooksListData> tabIconsList = <BooksListData>[
    // 自我成長類別
    BooksListData(
      imagePath: 'https://images-na.ssl-images-amazon.com/images/P/0735211299.01.L.jpg', // 原子習慣封面
      titleTxt: '自我成長',
      rating: 4.8,
      books: <String>['原子習慣,', '刻意練習,', '心流'],
      startColor: '#FA7D82',
      endColor: '#FFB295',
    ),
    
    // 商業思維類別
    BooksListData(
      imagePath: 'https://images-na.ssl-images-amazon.com/images/P/0804139296.01.L.jpg', // 從0到1封面
      titleTxt: '商業思維',
      rating: 4.6,
      books: <String>['從0到1,', '精實創業,', '創新的兩難'],
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    ),
    
    // 心理學類別
    BooksListData(
      imagePath: 'https://images-na.ssl-images-amazon.com/images/P/0374533555.01.L.jpg', // 快思慢想封面
      titleTxt: '心理學',
      rating: null, // null 表示顯示新增按鈕
      books: <String>['推薦:', '探索心理學經典'],
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
    
    // 科技趨勢類別
    BooksListData(
      imagePath: 'https://images-na.ssl-images-amazon.com/images/P/0143127748.01.L.jpg', // 人類大歷史封面
      titleTxt: '科技趨勢',
      rating: null, // null 表示顯示新增按鈕
      books: <String>['推薦:', '未來科技書單'],
      startColor: '#6F72CA',
      endColor: '#1E1466',
    ),
  ];

  /// 取得特定書籍類別的資料
  static BooksListData? getBooksByType(String bookType) {
    try {
      return tabIconsList.firstWhere(
        (book) => book.titleTxt.toLowerCase() == bookType.toLowerCase(),
      );
    } catch (e) {
      return null; // 找不到對應的書籍類別
    }
  }

  /// 計算平均評分（僅計算有評分的書籍）
  static double getAverageRating() {
    final ratedBooks = tabIconsList.where((book) => book.rating != null).toList();
    if (ratedBooks.isEmpty) return 0.0;
    
    return ratedBooks
        .fold(0.0, (total, book) => total + book.rating!)
        / ratedBooks.length;
  }

  /// 檢查是否為推薦類別（顯示新增按鈕而非評分）
  bool get isRecommendation => rating == null;

  /// 取得格式化的書籍清單字串
  String get formattedBooks => books?.join('\n') ?? '';

  /// 複製並修改書籍資料
  BooksListData copyWith({
    String? imagePath,
    String? titleTxt,
    String? startColor,
    String? endColor,
    List<String>? books,
    double? rating,
  }) {
    return BooksListData(
      imagePath: imagePath ?? this.imagePath,
      titleTxt: titleTxt ?? this.titleTxt,
      startColor: startColor ?? this.startColor,
      endColor: endColor ?? this.endColor,
      books: books ?? this.books,
      rating: rating ?? this.rating,
    );
  }

  /// 轉換為健身APP格式（兼容性方法）
  Map<String, dynamic> toHealthFormat() {
    return {
      'imagePath': imagePath,
      'titleTxt': titleTxt,
      'startColor': startColor,
      'endColor': endColor,
      'items': books,
      'value': rating ?? 0.0,
    };
  }

  /// 從健身APP格式建立（兼容性方法）
  static BooksListData fromHealthFormat(Map<String, dynamic> data) {
    return BooksListData(
      imagePath: data['imagePath'] ?? '',
      titleTxt: data['titleTxt'] ?? '',
      startColor: data['startColor'] ?? '',
      endColor: data['endColor'] ?? '',
      books: List<String>.from(data['items'] ?? []),
      rating: data['value'] > 0 ? data['value'].toDouble() : null,
    );
  }

  /// 檢查是否為網路圖片
  bool get isNetworkImage => imagePath.startsWith('http');

  /// 取得預設圖示（當網路圖片載入失敗時使用）
  String get fallbackIcon {
    switch (titleTxt.toLowerCase()) {
      case '自我成長':
        return 'assets/fitness_app/breakfast.png';
      case '商業思維':
        return 'assets/fitness_app/lunch.png';
      case '心理學':
        return 'assets/fitness_app/snack.png';
      case '科技趨勢':
      case '科技趋勢':
        return 'assets/fitness_app/dinner.png';
      default:
        return 'assets/fitness_app/breakfast.png';
    }
  }
}