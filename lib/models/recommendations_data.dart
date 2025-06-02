// models/recommendations_data.dart

/// 推薦內容資料模型
/// 
/// 通用的推薦項目資料結構，可適用於各種應用
class RecommendationsData {
  RecommendationsData({
    this.imagePath = '',
    this.titleTxt = '',
    this.startColor = '',
    this.endColor = '',
    this.items,
    this.rating = 0.0,
    this.status = '',
  });

  /// 項目圖片檔案路徑
  String imagePath;
  
  /// 項目標題或分類名稱
  String titleTxt;
  
  /// 漸層開始顏色（十六進位格式）
  String startColor;
  
  /// 漸層結束顏色（十六進位格式）
  String endColor;
  
  /// 項目詳情清單
  List<String>? items;
  
  /// 評分（0.0-5.0星評）
  double rating;
  
  /// 狀態標記（已完成、進行中、待開始等）
  String status;

  /// 預設推薦內容資料清單
  static List<RecommendationsData> recommendationsList = <RecommendationsData>[
    // 分類一：自我成長
    RecommendationsData(
      imagePath: 'assets/fitness_app/breakfast.png',
      titleTxt: '自我成長',
      rating: 4.8,
      items: <String>['原子習慣', '刻意練習', '心流'],
      startColor: '#FA7D82',
      endColor: '#FFB295',
      status: '進行中',
    ),
    
    // 分類二：商業理財
    RecommendationsData(
      imagePath: 'assets/fitness_app/lunch.png',
      titleTxt: '商業理財',
      rating: 4.6,
      items: <String>['富爸爸窮爸爸', '投資最重要的事', '華爾街狼人'],
      startColor: '#738AE6',
      endColor: '#5C5EDD',
      status: '已完成',
    ),
    
    // 分類三：文學小說
    RecommendationsData(
      imagePath: 'assets/fitness_app/snack.png',
      titleTxt: '文學小說',
      rating: 4.9,
      items: <String>['推薦:', '挪威的森林', '百年孤寂'],
      startColor: '#FE95B6',
      endColor: '#FF5287',
      status: '想讀',
    ),
    
    // 分類四：科技趨勢
    RecommendationsData(
      imagePath: 'assets/fitness_app/dinner.png',
      titleTxt: '科技趨勢',
      rating: 4.7,
      items: <String>['推薦:', 'AI時代來臨', '元宇宙指南'],
      startColor: '#6F72CA',
      endColor: '#1E1466',
      status: '想讀',
    ),
  ];

  /// 取得特定分類的推薦資料
  static RecommendationsData? getRecommendationByCategory(String category) {
    try {
      return recommendationsList.firstWhere(
        (recommendation) => recommendation.titleTxt.toLowerCase() == category.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// 計算總平均評分
  static double getAverageRating() {
    if (recommendationsList.isEmpty) return 0.0;
    
    double totalRating = recommendationsList
        .fold(0.0, (total, recommendation) => total + recommendation.rating);
    return totalRating / recommendationsList.length;
  }

  /// 取得指定狀態的項目數量
  static int getItemCountByStatus(String status) {
    return recommendationsList
        .where((recommendation) => recommendation.status == status)
        .length;
  }

  /// 檢查是否為推薦項目
  bool get isRecommendation => items?.first.contains('推薦:') ?? false;

  /// 取得格式化的項目清單字串
  String get formattedItems => items?.join('\n') ?? '';

  /// 取得星級顯示字串
  String get starDisplay => '★' * rating.round() + '☆' * (5 - rating.round());

  /// 取得狀態對應的顏色
  String get statusColor {
    switch (status) {
      case '已完成':
        return '#4CAF50'; // 綠色
      case '進行中':
        return '#FF9800'; // 橙色
      case '想讀':
        return '#2196F3'; // 藍色
      default:
        return '#9E9E9E'; // 灰色
    }
  }

  /// 複製並修改推薦資料
  RecommendationsData copyWith({
    String? imagePath,
    String? titleTxt,
    String? startColor,
    String? endColor,
    List<String>? items,
    double? rating,
    String? status,
  }) {
    return RecommendationsData(
      imagePath: imagePath ?? this.imagePath,
      titleTxt: titleTxt ?? this.titleTxt,
      startColor: startColor ?? this.startColor,
      endColor: endColor ?? this.endColor,
      items: items ?? this.items,
      rating: rating ?? this.rating,
      status: status ?? this.status,
    );
  }

  /// 更新狀態
  void updateStatus(String newStatus) {
    status = newStatus;
  }

  /// 更新評分
  void updateRating(double newRating) {
    if (newRating >= 0.0 && newRating <= 5.0) {
      rating = newRating;
    }
  }
}