// lib/features/ai_companion/widgets/chat_view.dart
import '../../../core/config/app_theme.dart';
import 'package:flutter/material.dart';

/// AI 聊天視圖 - 智慧陪伴聊天介面
class ChatView extends StatefulWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const ChatView({Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  /// 聊天訊息範例資料
  List<ChatMessage> messages = [
    ChatMessage(
      content: '嗨！我是你的 AI 讀書夥伴，今天想聊聊什麼呢？📚',
      isFromAI: true,
      timestamp: DateTime.now().subtract(Duration(minutes: 30)),
    ),
    ChatMessage(
      content: '我在讀《原子習慣》，但總是很難堅持新習慣',
      isFromAI: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 25)),
    ),
    ChatMessage(
      content: '這是很常見的困擾！根據書中的理論，關鍵是要讓新習慣變得「顯而易見、有吸引力、簡單易行、令人滿足」。你想從哪個小習慣開始嘗試呢？',
      isFromAI: true,
      timestamp: DateTime.now().subtract(Duration(minutes: 24)),
    ),
    ChatMessage(
      content: '我想養成每天閱讀的習慣',
      isFromAI: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 20)),
    ),
    ChatMessage(
      content: '太棒了！建議你可以嘗試「習慣堆疊」：把閱讀和你已經養成的習慣結合，比如「每天喝咖啡後，我就閱讀 10 分鐘」。這樣成功率會更高！ ☕📖',
      isFromAI: true,
      timestamp: DateTime.now().subtract(Duration(minutes: 19)),
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                height: 400,
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
                  children: [
                    // 聊天標題區域
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.nearlyDarkBlue.withOpacity(0.1),
                            AppTheme.nearlyBlue.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(68.0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.nearlyDarkBlue,
                                  AppTheme.nearlyBlue,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.psychology,
                              color: AppTheme.white,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AI 讀書夥伴',
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                                Text(
                                  '線上中 • 隨時為你解答',
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontSize: 12,
                                    color: AppTheme.lightText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // 聊天訊息區域
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(16),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return _buildMessageBubble(messages[index]);
                        },
                      ),
                    ),
                    
                    // 輸入區域
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.background,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppTheme.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: AppTheme.grey.withOpacity(0.1),
                                      offset: Offset(0, 1),
                                      blurRadius: 3.0),
                                ],
                              ),
                              child: TextField(
                                controller: _messageController,
                                decoration: InputDecoration(
                                  hintText: '分享你的讀書心得或問題...',
                                  hintStyle: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontSize: 14,
                                    color: AppTheme.grey.withOpacity(0.6),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                ),
                                maxLines: null,
                                onSubmitted: (value) {
                                  _sendMessage(value);
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.nearlyDarkBlue,
                                  AppTheme.nearlyBlue,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: AppTheme.nearlyDarkBlue.withOpacity(0.4),
                                    offset: Offset(2.0, 4.0),
                                    blurRadius: 8.0),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(24),
                                onTap: () {
                                  if (_messageController.text.trim().isNotEmpty) {
                                    _sendMessage(_messageController.text);
                                  }
                                },
                                child: Icon(
                                  Icons.send,
                                  color: AppTheme.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
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

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isFromAI 
            ? MainAxisAlignment.start 
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.isFromAI) ...[
            // AI 頭像
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.nearlyDarkBlue,
                    AppTheme.nearlyBlue,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.psychology,
                color: AppTheme.white,
                size: 16,
              ),
            ),
            SizedBox(width: 8),
          ],
          
          // 訊息氣泡
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isFromAI 
                    ? AppTheme.background 
                    : AppTheme.nearlyDarkBlue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: message.isFromAI 
                      ? Radius.circular(4) 
                      : Radius.circular(16),
                  bottomRight: message.isFromAI 
                      ? Radius.circular(16) 
                      : Radius.circular(4),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: AppTheme.grey.withOpacity(0.1),
                      offset: Offset(0, 1),
                      blurRadius: 3.0),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      fontFamily: AppTheme.fontName,
                      fontSize: 14,
                      color: message.isFromAI 
                          ? AppTheme.darkerText 
                          : AppTheme.white,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      fontFamily: AppTheme.fontName,
                      fontSize: 10,
                      color: message.isFromAI 
                          ? AppTheme.grey.withOpacity(0.6)
                          : AppTheme.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          if (!message.isFromAI) ...[
            SizedBox(width: 8),
            // 用戶頭像
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.person,
                color: AppTheme.white,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _sendMessage(String content) {
    if (content.trim().isEmpty) return;

    setState(() {
      messages.add(ChatMessage(
        content: content,
        isFromAI: false,
        timestamp: DateTime.now(),
      ));
    });

    _messageController.clear();
    
    // 滾動到底部
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    // 模擬 AI 回覆
    Future.delayed(Duration(seconds: 2), () {
      _simulateAIResponse(content);
    });
  }

  void _simulateAIResponse(String userMessage) {
    String aiResponse = _generateAIResponse(userMessage);
    
    setState(() {
      messages.add(ChatMessage(
        content: aiResponse,
        isFromAI: true,
        timestamp: DateTime.now(),
      ));
    });

    // 滾動到底部
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  String _generateAIResponse(String userMessage) {
    // 簡單的 AI 回應模擬
    List<String> responses = [
      '很有趣的想法！你可以進一步思考這個概念如何應用在日常生活中。',
      '這確實是個值得深入探討的話題。根據相關理論...',
      '我理解你的想法。建議你可以從這個角度來思考：',
      '很棒的分享！這讓我想到書中提到的一個重要觀點...',
      '這是個很好的問題！讓我們一起來分析一下。',
    ];
    
    return responses[DateTime.now().millisecond % responses.length];
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return '剛剛';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分鐘前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小時前';
    } else {
      return '${dateTime.month}/${dateTime.day}';
    }
  }
}

/// 聊天訊息資料模型
class ChatMessage {
  final String content;
  final bool isFromAI;
  final DateTime timestamp;

  ChatMessage({
    required this.content,
    required this.isFromAI,
    required this.timestamp,
  });
}