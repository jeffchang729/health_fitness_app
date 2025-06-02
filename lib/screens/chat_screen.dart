// screens/chat_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../themes/app_theme.dart';
import '../models/chat_message.dart';
import '../services/ai_chat_service.dart';
import '../widgets/chat/message_bubble.dart';
import '../widgets/chat/typing_indicator.dart';
import '../widgets/chat/chat_input_field.dart';

/// AI聊天互動頁面
/// 
/// 功能包含：
/// - 與AI進行自然對話
/// - 讀書相關討論
/// - 情感支持和閱讀動機
/// - 個人化回應和建議
class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, this.animationController}) : super(key: key);
  final AnimationController? animationController;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  /// 訊息清單
  final List<ChatMessage> _messages = [];
  
  /// 滾動控制器
  final ScrollController _scrollController = ScrollController();
  
  /// 文字輸入控制器
  final TextEditingController _textController = TextEditingController();
  
  /// AI聊天服務
  final AIChatService _aiService = AIChatService();
  
  /// 是否正在輸入
  bool _isTyping = false;
  
  /// 是否正在載入AI回應
  bool _isAITyping = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  /// 初始化聊天
  void _initializeChat() {
    // 添加歡迎訊息
    _addMessage(ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: '哈囉！我是你的AI閱讀夥伴 📚\n\n我可以：\n• 與你聊讀書心得\n• 推薦適合的書籍\n• 提供閱讀動機和支持\n• 陪你探討人生思考\n\n今天想聊什麼呢？',
      isFromUser: false,
      timestamp: DateTime.now(),
      messageType: MessageType.welcome,
    ));
  }

  /// 發送訊息
  void _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    // 添加使用者訊息
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: text,
      isFromUser: true,
      timestamp: DateTime.now(),
    );
    
    _addMessage(userMessage);
    _textController.clear();

    // 顯示AI正在輸入
    setState(() {
      _isAITyping = true;
    });

    try {
      // 獲取AI回應
      final aiResponse = await _aiService.getChatResponse(text, _messages);
      
      // 添加AI回應
      final aiMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: aiResponse.content,
        isFromUser: false,
        timestamp: DateTime.now(),
        messageType: aiResponse.type,
        bookRecommendations: aiResponse.bookRecommendations,
        emotionalTone: aiResponse.emotionalTone,
      );
      
      _addMessage(aiMessage);
    } catch (e) {
      // 錯誤處理
      _addMessage(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: '抱歉，我現在有點忙碌，請稍後再試試看 😅',
        isFromUser: false,
        timestamp: DateTime.now(),
        messageType: MessageType.error,
      ));
    } finally {
      setState(() {
        _isAITyping = false;
      });
    }
  }

  /// 添加訊息到清單
  void _addMessage(ChatMessage message) {
    setState(() {
      _messages.add(message);
    });
    
    // 自動滾動到底部
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// 長按訊息選單
  void _showMessageOptions(ChatMessage message) {
    HapticFeedback.lightImpact();
    
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
            // 拖拉指示器
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              decoration: BoxDecoration(
                color: AppTheme.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // 複製訊息
            ListTile(
              leading: const Icon(Icons.copy, color: AppTheme.nearlyDarkBlue),
              title: const Text('複製訊息'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: message.content));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已複製到剪貼簿')),
                );
              },
            ),
            
            // 收藏訊息（如果是AI回應）
            if (!message.isFromUser)
              ListTile(
                leading: const Icon(Icons.bookmark_add, color: AppTheme.nearlyDarkBlue),
                title: const Text('收藏這則回應'),
                onTap: () {
                  Navigator.pop(context);
                  _saveMessage(message);
                },
              ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// 收藏訊息
  void _saveMessage(ChatMessage message) {
    // TODO: 實作訊息收藏功能
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已收藏這則AI回應')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            // 聊天訊息區域
            Expanded(
              child: _buildMessageList(),
            ),
            
            // AI正在輸入指示器
            if (_isAITyping)
              const TypingIndicator(),
            
            // 輸入區域
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  /// 建構應用列
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppTheme.darkerText),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          // AI頭像
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.nearlyDarkBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy,
              color: AppTheme.nearlyDarkBlue,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          // AI資訊
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI 閱讀夥伴',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkerText,
                  ),
                ),
                Text(
                  '在線上 • 隨時為你服務',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // 更多選項
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: AppTheme.darkerText),
          onSelected: _handleMenuSelection,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'clear',
              child: Row(
                children: [
                  Icon(Icons.clear_all, color: AppTheme.darkerText),
                  SizedBox(width: 12),
                  Text('清除對話'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'export',
              child: Row(
                children: [
                  Icon(Icons.download, color: AppTheme.darkerText),
                  SizedBox(width: 12),
                  Text('匯出對話'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 處理選單選擇
  void _handleMenuSelection(String value) {
    switch (value) {
      case 'clear':
        _showClearDialog();
        break;
      case 'export':
        _exportChat();
        break;
    }
  }

  /// 顯示清除對話確認對話框
  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清除對話'),
        content: const Text('確定要清除所有對話記錄嗎？此操作無法復原。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearChat();
            },
            child: const Text('確定'),
          ),
        ],
      ),
    );
  }

  /// 清除聊天記錄
  void _clearChat() {
    setState(() {
      _messages.clear();
    });
    _initializeChat();
  }

  /// 匯出聊天記錄
  void _exportChat() {
    // TODO: 實作聊天記錄匯出功能
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('匯出功能開發中...')),
    );
  }

  /// 建構訊息列表
  Widget _buildMessageList() {
    if (_messages.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppTheme.nearlyDarkBlue,
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.background,
      ),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];
          return GestureDetector(
            onLongPress: () => _showMessageOptions(message),
            child: MessageBubble(
              message: message,
              showAvatar: _shouldShowAvatar(index),
            ),
          );
        },
      ),
    );
  }

  /// 判斷是否顯示頭像
  bool _shouldShowAvatar(int index) {
    if (index == _messages.length - 1) return true;
    
    final currentMessage = _messages[index];
    final nextMessage = _messages[index + 1];
    
    return currentMessage.isFromUser != nextMessage.isFromUser;
  }

  /// 建構輸入區域
  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.white,
        border: Border(
          top: BorderSide(
            color: AppTheme.background,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: ChatInputField(
          controller: _textController,
          onSend: _sendMessage,
          onTypingChanged: (isTyping) {
            setState(() {
              _isTyping = isTyping;
            });
          },
        ),
      ),
    );
  }
}