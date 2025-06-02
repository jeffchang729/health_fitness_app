// models/chat_message.dart

/// 聊天訊息資料模型
class ChatMessage {
  ChatMessage({
    required this.id,
    required this.content,
    required this.isFromUser,
    required this.timestamp,
    this.messageType = MessageType.text,
    this.bookRecommendations,
    this.emotionalTone,
    this.isRead = false,
  });

  /// 訊息唯一識別碼
  final String id;
  
  /// 訊息內容
  final String content;
  
  /// 是否來自使用者
  final bool isFromUser;
  
  /// 時間戳記
  final DateTime timestamp;
  
  /// 訊息類型
  final MessageType messageType;
  
  /// 書籍推薦清單（AI回應時可能包含）
  final List<BookRecommendation>? bookRecommendations;
  
  /// 情感語調（AI分析使用者情緒）
  final EmotionalTone? emotionalTone;
  
  /// 是否已讀
  bool isRead;

  /// 格式化時間顯示
  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return '剛剛';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}分鐘前';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}小時前';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${timestamp.month}/${timestamp.day}';
    }
  }

  /// 複製訊息
  ChatMessage copyWith({
    String? id,
    String? content,
    bool? isFromUser,
    DateTime? timestamp,
    MessageType? messageType,
    List<BookRecommendation>? bookRecommendations,
    EmotionalTone? emotionalTone,
    bool? isRead,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      isFromUser: isFromUser ?? this.isFromUser,
      timestamp: timestamp ?? this.timestamp,
      messageType: messageType ?? this.messageType,
      bookRecommendations: bookRecommendations ?? this.bookRecommendations,
      emotionalTone: emotionalTone ?? this.emotionalTone,
      isRead: isRead ?? this.isRead,
    );
  }

  /// 轉換為JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isFromUser': isFromUser,
      'timestamp': timestamp.toIso8601String(),
      'messageType': messageType.toString(),
      'bookRecommendations': bookRecommendations?.map((rec) => rec.toJson()).toList(),
      'emotionalTone': emotionalTone?.toString(),
      'isRead': isRead,
    };
  }

  /// 從JSON建立物件
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      content: json['content'] as String,
      isFromUser: json['isFromUser'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      messageType: MessageType.values.firstWhere(
        (type) => type.toString() == json['messageType'],
        orElse: () => MessageType.text,
      ),
      bookRecommendations: (json['bookRecommendations'] as List<dynamic>?)
          ?.map((rec) => BookRecommendation.fromJson(rec as Map<String, dynamic>))
          .toList(),
      emotionalTone: json['emotionalTone'] != null
          ? EmotionalTone.values.firstWhere(
              (tone) => tone.toString() == json['emotionalTone'],
              orElse: () => EmotionalTone.neutral,
            )
          : null,
      isRead: json['isRead'] as bool? ?? false,
    );
  }
}

/// 訊息類型枚舉
enum MessageType {
  /// 普通文字訊息
  text,
  
  /// 歡迎訊息
  welcome,
  
  /// 書籍推薦
  bookRecommendation,
  
  /// 情感支持
  emotionalSupport,
  
  /// 閱讀分析
  readingAnalysis,
  
  /// 個人建議
  personalAdvice,
  
  /// 錯誤訊息
  error,
}

/// 書籍推薦資料模型
class BookRecommendation {
  BookRecommendation({
    required this.title,
    required this.author,
    required this.description,
    this.coverUrl,
    this.rating,
    this.category,
    this.reason,
  });

  /// 書名
  final String title;
  
  /// 作者
  final String author;
  
  /// 描述
  final String description;
  
  /// 封面圖片URL
  final String? coverUrl;
  
  /// 評分
  final double? rating;
  
  /// 分類
  final String? category;
  
  /// 推薦理由
  final String? reason;

  /// 轉換為JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'coverUrl': coverUrl,
      'rating': rating,
      'category': category,
      'reason': reason,
    };
  }

  /// 從JSON建立物件
  factory BookRecommendation.fromJson(Map<String, dynamic> json) {
    return BookRecommendation(
      title: json['title'] as String,
      author: json['author'] as String,
      description: json['description'] as String,
      coverUrl: json['coverUrl'] as String?,
      rating: json['rating'] as double?,
      category: json['category'] as String?,
      reason: json['reason'] as String?,
    );
  }
}

/// 情感語調枚舉
enum EmotionalTone {
  /// 正面/開心
  positive,
  
  /// 中性
  neutral,
  
  /// 負面/沮喪
  negative,
  
  /// 興奮/熱情
  excited,
  
  /// 困惑/迷茫
  confused,
  
  /// 疲憊/厭倦
  tired,
  
  /// 好奇/求知
  curious,
}

/// AI回應資料模型
class AIResponse {
  AIResponse({
    required this.content,
    this.type = MessageType.text,
    this.bookRecommendations,
    this.emotionalTone,
    this.confidence,
  });

  /// 回應內容
  final String content;
  
  /// 回應類型
  final MessageType type;
  
  /// 書籍推薦
  final List<BookRecommendation>? bookRecommendations;
  
  /// 檢測到的情感語調
  final EmotionalTone? emotionalTone;
  
  /// AI回應的信心度（0.0-1.0）
  final double? confidence;
}