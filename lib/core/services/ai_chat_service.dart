// services/ai_chat_service.dart

import 'dart:math';
import '../models/chat_message.dart';

/// AI聊天服務
/// 
/// 提供智慧對話、情感分析、書籍推薦等功能
/// 目前使用模擬回應，實際應用時需要整合真實的AI API
class AIChatService {
  /// 隨機數生成器
  final Random _random = Random();
  
  /// 對話歷史分析
  final List<String> _conversationHistory = [];

  /// 取得AI聊天回應
  /// 
  /// [userMessage] 使用者輸入的訊息
  /// [messageHistory] 對話歷史記錄
  Future<AIResponse> getChatResponse(
    String userMessage,
    List<ChatMessage> messageHistory,
  ) async {
    // 模擬網路延遲
    await Future.delayed(Duration(milliseconds: 800 + _random.nextInt(1200)));
    
    // 添加到對話歷史
    _conversationHistory.add(userMessage);
    
    // 分析使用者情感
    final emotionalTone = _analyzeEmotion(userMessage);
    
    // 檢測訊息類型和生成回應
    if (_isBookRelated(userMessage)) {
      return _generateBookResponse(userMessage, emotionalTone);
    } else if (_isEmotionalSupport(userMessage)) {
      return _generateEmotionalResponse(userMessage, emotionalTone);
    } else if (_isReadingAdvice(userMessage)) {
      return _generateAdviceResponse(userMessage, emotionalTone);
    } else {
      return _generateGeneralResponse(userMessage, emotionalTone);
    }
  }

  /// 分析使用者情感語調
  EmotionalTone _analyzeEmotion(String message) {
    final lowerMessage = message.toLowerCase();
    
    // 正面情感關鍵字
    final positiveKeywords = ['開心', '高興', '喜歡', '很棒', '不錯', '好的', '謝謝', '感謝'];
    // 負面情感關鍵字  
    final negativeKeywords = ['難過', '沮喪', '困難', '不行', '不好', '糟糕', '討厭', '煩'];
    // 興奮關鍵字
    final excitedKeywords = ['太棒了', '超級', '非常', '真的嗎', '哇', '驚喜'];
    // 困惑關鍵字
    final confusedKeywords = ['不懂', '不知道', '迷茫', '困惑', '怎麼辦', '為什麼'];
    // 疲憊關鍵字
    final tiredKeywords = ['累', '疲憊', '厭倦', '無聊', '沒動力'];
    // 好奇關鍵字
    final curiousKeywords = ['想知道', '好奇', '如何', '什麼是', '告訴我'];

    if (excitedKeywords.any((keyword) => lowerMessage.contains(keyword))) {
      return EmotionalTone.excited;
    } else if (confusedKeywords.any((keyword) => lowerMessage.contains(keyword))) {
      return EmotionalTone.confused;
    } else if (tiredKeywords.any((keyword) => lowerMessage.contains(keyword))) {
      return EmotionalTone.tired;
    } else if (curiousKeywords.any((keyword) => lowerMessage.contains(keyword))) {
      return EmotionalTone.curious;
    } else if (positiveKeywords.any((keyword) => lowerMessage.contains(keyword))) {
      return EmotionalTone.positive;
    } else if (negativeKeywords.any((keyword) => lowerMessage.contains(keyword))) {
      return EmotionalTone.negative;
    }
    
    return EmotionalTone.neutral;
  }

  /// 檢測是否與書籍相關
  bool _isBookRelated(String message) {
    final bookKeywords = ['書', '閱讀', '推薦', '作者', '小說', '文學', '書單', '讀完', '讀書'];
    return bookKeywords.any((keyword) => message.contains(keyword));
  }

  /// 檢測是否需要情感支持
  bool _isEmotionalSupport(String message) {
    final emotionalKeywords = ['難過', '沮喪', '壓力', '焦慮', '困難', '挫折', '失落', '迷茫'];
    return emotionalKeywords.any((keyword) => message.contains(keyword));
  }

  /// 檢測是否詢問閱讀建議
  bool _isReadingAdvice(String message) {
    final adviceKeywords = ['怎麼讀', '如何', '方法', '技巧', '建議', '習慣', '計劃'];
    return adviceKeywords.any((keyword) => message.contains(keyword));
  }

  /// 生成書籍相關回應
  AIResponse _generateBookResponse(String userMessage, EmotionalTone tone) {
    final responses = [
      '我很樂意和你聊書！📚 你最近在讀什麼類型的書呢？是想要找新的推薦，還是想分享讀書心得？',
      '讀書是很棒的習慣呢！✨ 不同類型的書能帶給我們不同的視野和思考。你對哪個領域特別感興趣？',
      '哇，又遇到一位愛書人！📖 我可以根據你的喜好推薦一些很棒的書籍。先告訴我你喜歡什麼風格的書？',
    ];

    // 添加書籍推薦
    final recommendations = _generateBookRecommendations();

    return AIResponse(
      content: responses[_random.nextInt(responses.length)],
      type: MessageType.bookRecommendation,
      bookRecommendations: recommendations,
      emotionalTone: tone,
      confidence: 0.85,
    );
  }

  /// 生成情感支持回應
  AIResponse _generateEmotionalResponse(String userMessage, EmotionalTone tone) {
    Map<EmotionalTone, List<String>> responses = {
      EmotionalTone.negative: [
        '聽起來你現在有些困擾 😊 沒關係的，每個人都會有低潮期。要不要嘗試讀一些療癒心靈的書？閱讀能幫助我們找到內心的平靜。',
        '我能感受到你的心情不太好 💙 閱讀有時候能成為很好的陪伴。要不要我推薦一些能帶來正能量的書籍？',
        '遇到困難時，閱讀可以是很好的慰藉 🌟 有些書能幫我們重新找到方向和力量。要聊聊是什麼讓你困擾嗎？',
      ],
      EmotionalTone.confused: [
        '感覺你現在有些迷茫 🤔 這很正常，每個人在成長路上都會有困惑的時候。閱讀能幫助我們釐清思緒，找到答案。',
        '迷茫的時候，書籍往往能給我們指引 💡 要不要試試看一些關於人生思考或自我成長的書？',
        '困惑也是成長的一部分 🌱 有些哲學或心理學的書籍能幫助我們更好地理解自己和世界。要不要聊聊你在困惑什麼？',
      ],
      EmotionalTone.tired: [
        '聽起來你有點累了 😌 閱讀其實也可以是很好的放鬆方式。試試看一些輕鬆有趣的書，或者暫時放下書本，好好休息一下也很重要。',
        '疲憊的時候，不要勉強自己 💙 可以選擇一些輕鬆愉快的讀物，或者聽聽有聲書，讓閱讀成為療癒而不是負擔。',
        '感覺到你的疲憊 🫂 有時候我們需要的不是更多的輸入，而是靜下心來消化。要不要我推薦一些能讓人放鬆的書？',
      ],
    };

    final responseList = responses[tone] ?? responses[EmotionalTone.negative]!;
    return AIResponse(
      content: responseList[_random.nextInt(responseList.length)],
      type: MessageType.emotionalSupport,
      emotionalTone: tone,
      confidence: 0.9,
    );
  }

  /// 生成閱讀建議回應
  AIResponse _generateAdviceResponse(String userMessage, EmotionalTone tone) {
    final responses = [
      '關於閱讀方法，我有幾個建議：\n\n📖 選擇適合的時間和環境\n⏰ 每天固定閱讀15-30分鐘\n📝 做讀書筆記或心得記錄\n🎯 設定小目標，循序漸進\n\n你想要改善哪個方面的閱讀習慣呢？',
      '建立良好的閱讀習慣需要時間：\n\n🌅 選擇一天中精神最好的時段\n📱 閱讀時收起手機，專心投入\n📚 準備一個舒適的閱讀角落\n🔄 從短時間開始，慢慢延長\n\n最重要的是享受閱讀的過程！',
      '每個人的閱讀方式都不同，找到適合自己的很重要：\n\n🎧 有些人適合有聲書\n📖 有些人喜歡實體書\n💡 有些人需要做筆記思考\n⚡ 有些人喜歡快速瀏覽\n\n你比較喜歡哪種閱讀方式？',
    ];

    return AIResponse(
      content: responses[_random.nextInt(responses.length)],
      type: MessageType.personalAdvice,
      emotionalTone: tone,
      confidence: 0.88,
    );
  }

  /// 生成一般回應
  AIResponse _generateGeneralResponse(String userMessage, EmotionalTone tone) {
    Map<EmotionalTone, List<String>> responses = {
      EmotionalTone.positive: [
        '很開心和你聊天！😊 你的積極態度很棒呢！有什麼想聊的嗎？也許我們可以談談你最近的閱讀收穫？',
        '感受到你的好心情！✨ 這樣的正能量很棒！要不要分享一些讓你開心的事情？或者聊聊最近讀的好書？',
        '你的好心情很有感染力！🌟 保持這樣積極的態度，生活一定會更美好。想聊什麼都可以哦！',
      ],
      EmotionalTone.excited: [
        '哇！感受到你的興奮！🎉 是什麼讓你這麼開心呢？如果是因為讀到好書，一定要分享給我！',
        '你的熱情很有感染力耶！⚡ 這種興奮的感覺很棒！是不是發現了什麼有趣的東西？',
        '太棒了！🚀 你的興奮讓我也跟著開心起來！快告訴我發生了什麼好事？',
      ],
      EmotionalTone.curious: [
        '我很喜歡好奇的人！🔍 好奇心是學習和成長的動力。你想了解什麼呢？',
        '好奇心是很珍貴的品質！💡 無論你想知道什麼，我們都可以一起探索和討論。',
        '探索未知的慾望很棒！🌟 告訴我你的疑問，讓我們一起尋找答案吧！',
      ],
      EmotionalTone.neutral: [
        '你好！😊 我是你的AI閱讀夥伴，很高興能和你聊天！有什麼想聊的嗎？',
        '嗨！👋 今天過得怎麼樣？如果你想聊讀書、聊生活，或者只是想隨便聊聊，我都很樂意陪你！',
        '很開心遇見你！✨ 我可以陪你聊閱讀心得、推薦書籍，或者就是單純地聊天。你比較想聊什麼？',
      ],
    };

    final responseList = responses[tone] ?? responses[EmotionalTone.neutral]!;
    return AIResponse(
      content: responseList[_random.nextInt(responseList.length)],
      type: MessageType.text,
      emotionalTone: tone,
      confidence: 0.75,
    );
  }

  /// 生成書籍推薦清單
  List<BookRecommendation> _generateBookRecommendations() {
    final allRecommendations = [
      BookRecommendation(
        title: '原子習慣',
        author: 'James Clear',
        description: '細微改變帶來巨大成就的實證法則',
        rating: 4.8,
        category: '自我成長',
        reason: '幫助建立良好的閱讀習慣',
      ),
      BookRecommendation(
        title: '被討厭的勇氣',
        author: '岸見一郎',
        description: '自我啟發之父阿德勒的教導',
        rating: 4.6,
        category: '心理學',
        reason: '學會不被他人期望綁架，活出真實自我',
      ),
      BookRecommendation(
        title: '挪威的森林',
        author: '村上春樹',
        description: '關於青春、愛情與成長的經典小說',
        rating: 4.7,
        category: '文學小說',
        reason: '療癒心靈的文字，適合需要情感慰藉時閱讀',
      ),
      BookRecommendation(
        title: '人類大歷史',
        author: '哈拉瑞',
        description: '從動物到上帝的人類進化史',
        rating: 4.9,
        category: '歷史科普',
        reason: '開拓視野，重新思考人類文明',
      ),
      BookRecommendation(
        title: '正念的奇蹟',
        author: '一行禪師',
        description: '學習活在當下的禪修指南',
        rating: 4.5,
        category: '心靈成長',
        reason: '幫助減壓，培養內心的平靜',
      ),
    ];

    // 隨機選擇2-3本書推薦
    final shuffled = List<BookRecommendation>.from(allRecommendations)..shuffle(_random);
    return shuffled.take(2 + _random.nextInt(2)).toList();
  }

  /// 取得個人化每日分析報告
  Future<String> getDailyAnalysisReport(List<ChatMessage> conversations) async {
    // 模擬分析延遲
    await Future.delayed(const Duration(seconds: 2));

    final userMessages = conversations.where((msg) => msg.isFromUser).toList();
    final totalInteractions = conversations.length;
    final averageResponseTime = _calculateAverageResponseTime(conversations);
    final mostDiscussedTopics = _analyzeMostDiscussedTopics(userMessages);
    final emotionalTrend = _analyzeEmotionalTrend(conversations);

    return '''
📊 **每日AI陪伴分析報告**

**📈 互動統計**
• 總對話次數：$totalInteractions 次
• 平均回應時間：${averageResponseTime.toStringAsFixed(1)} 秒
• 活躍時段：${_getActiveTimeSlot(conversations)}

**💭 對話主題分析**
$mostDiscussedTopics

**😊 情緒趨勢**
$emotionalTrend

**📚 閱讀建議**
${_generatePersonalizedAdvice(conversations)}

**🌟 明日目標**
• 嘗試探索新的閱讀類型
• 保持積極的對話互動
• 記錄閱讀心得和感想

---
*此報告基於AI分析生成，持續互動有助提升分析準確度*
''';
  }

  /// 計算平均回應時間
  double _calculateAverageResponseTime(List<ChatMessage> conversations) {
    return 1.2 + _random.nextDouble() * 2.0;
  }

  /// 取得活躍時段
  String _getActiveTimeSlot(List<ChatMessage> conversations) {
    final now = DateTime.now();
    if (now.hour >= 6 && now.hour < 12) {
      return '上午 (06:00-12:00)';
    } else if (now.hour >= 12 && now.hour < 18) {
      return '下午 (12:00-18:00)';
    } else {
      return '晚上 (18:00-06:00)';
    }
  }

  /// 分析最常討論的主題
  String _analyzeMostDiscussedTopics(List<ChatMessage> userMessages) {
    final topics = ['• 閱讀方法與習慣討論', '• 書籍推薦與分享', '• 個人成長話題'];
    return topics.join('\n');
  }

  /// 分析情緒趨勢
  String _analyzeEmotionalTrend(List<ChatMessage> conversations) {
    final emotions = ['積極正面', '好奇探索', '平和穩定'];
    return '整體呈現${emotions[_random.nextInt(emotions.length)]}的趨勢，保持良好的心理狀態 😊';
  }

  /// 生成個人化建議
  String _generatePersonalizedAdvice(List<ChatMessage> conversations) {
    final advice = [
      '根據你的對話模式，建議嘗試更多元的閱讀類型',
      '你展現出很好的學習慾望，可以挑戰一些深度思考的書籍',
      '保持目前的閱讀節奏，適當加入輕鬆讀物調節心情',
    ];
    return advice[_random.nextInt(advice.length)];
  }

  /// 清除對話歷史
  void clearConversationHistory() {
    _conversationHistory.clear();
  }

  /// 取得對話統計
  Map<String, dynamic> getConversationStats() {
    return {
      'totalMessages': _conversationHistory.length,
      'averageLength': _conversationHistory.isEmpty 
          ? 0 
          : _conversationHistory.map((msg) => msg.length).reduce((a, b) => a + b) / _conversationHistory.length,
      'lastInteraction': DateTime.now().toIso8601String(),
    };
  }
}