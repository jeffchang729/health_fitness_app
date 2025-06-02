// widgets/chat/chat_input_field.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../themes/app_theme.dart';

/// 聊天輸入欄位組件
class ChatInputField extends StatefulWidget {
  const ChatInputField({
    Key? key,
    required this.controller,
    required this.onSend,
    this.onTypingChanged,
  }) : super(key: key);

  final TextEditingController controller;
  final VoidCallback onSend;
  final ValueChanged<bool>? onTypingChanged;

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  /// 焦點節點
  final FocusNode _focusNode = FocusNode();
  
  /// 是否正在輸入
  bool _isTyping = false;
  
  /// 是否可以發送（有文字內容）
  bool _canSend = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    super.dispose();
  }

  /// 文字變更處理
  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    
    if (_canSend != hasText) {
      setState(() {
        _canSend = hasText;
      });
    }

    // 通知輸入狀態變更
    if (!_isTyping && hasText) {
      _isTyping = true;
      widget.onTypingChanged?.call(true);
    } else if (_isTyping && !hasText) {
      _isTyping = false;
      widget.onTypingChanged?.call(false);
    }
  }

  /// 發送訊息
  void _sendMessage() {
    if (_canSend) {
      // 觸覺回饋
      HapticFeedback.lightImpact();
      
      // 呼叫發送回調
      widget.onSend();
      
      // 更新狀態
      setState(() {
        _canSend = false;
        _isTyping = false;
      });
      
      // 通知停止輸入
      widget.onTypingChanged?.call(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 快速回應按鈕
        _buildQuickResponseButton(),
        
        const SizedBox(width: 12),
        
        // 主要輸入區域
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: _focusNode.hasFocus 
                    ? AppTheme.nearlyDarkBlue.withOpacity(0.3)
                    : AppTheme.grey.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // 文字輸入欄位
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    maxLines: 4,
                    minLines: 1,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: const InputDecoration(
                      hintText: '與AI聊聊你的想法...',
                      hintStyle: TextStyle(
                        color: AppTheme.grey,
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.darkerText,
                      height: 1.4,
                    ),
                  ),
                ),
                
                // 附加功能按鈕
                _buildAttachmentButton(),
              ],
            ),
          ),
        ),
        
        const SizedBox(width: 12),
        
        // 發送按鈕
        _buildSendButton(),
      ],
    );
  }

  /// 建構快速回應按鈕
  Widget _buildQuickResponseButton() {
    return GestureDetector(
      onTap: _showQuickResponses,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.nearlyDarkBlue.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.flash_on,
          color: AppTheme.nearlyDarkBlue,
          size: 20,
        ),
      ),
    );
  }

  /// 建構附加功能按鈕
  Widget _buildAttachmentButton() {
    return IconButton(
      onPressed: _showAttachmentOptions,
      icon: Icon(
        Icons.add_circle_outline,
        color: AppTheme.grey.withOpacity(0.7),
        size: 24,
      ),
    );
  }

  /// 建構發送按鈕
  Widget _buildSendButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: GestureDetector(
        onTap: _canSend ? _sendMessage : null,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _canSend 
                ? AppTheme.nearlyDarkBlue 
                : AppTheme.grey.withOpacity(0.3),
            shape: BoxShape.circle,
            boxShadow: _canSend ? [
              BoxShadow(
                color: AppTheme.nearlyDarkBlue.withOpacity(0.3),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ] : null,
          ),
          child: Icon(
            Icons.send,
            color: _canSend ? AppTheme.white : AppTheme.grey,
            size: 20,
          ),
        ),
      ),
    );
  }

  /// 顯示快速回應選項
  void _showQuickResponses() {
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
            
            // 標題
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '快速回應',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkerText,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 快速回應選項
            ...quickResponseOptions.map((option) => ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.nearlyDarkBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  option['icon'] as IconData,
                  color: AppTheme.nearlyDarkBlue,
                  size: 20,
                ),
              ),
              title: Text(
                option['title'] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.darkerText,
                ),
              ),
              subtitle: Text(
                option['text'] as String,
                style: TextStyle(
                  color: AppTheme.grey.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                widget.controller.text = option['text'] as String;
                _sendMessage();
              },
            )),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// 顯示附加功能選項
  void _showAttachmentOptions() {
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
            
            // 功能選項網格
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: attachmentOptions.map((option) => GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    option['onTap']();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: (option['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          option['icon'] as IconData,
                          color: option['color'] as Color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        option['title'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.darkerText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// 快速回應選項
  List<Map<String, dynamic>> get quickResponseOptions => [
    {
      'icon': Icons.thumb_up,
      'title': '肯定回應',
      'text': '好的，謝謝你的建議！',
    },
    {
      'icon': Icons.help_outline,
      'title': '尋求幫助',
      'text': '我需要一些閱讀建議',
    },
    {
      'icon': Icons.menu_book,
      'title': '推薦書籍',
      'text': '可以推薦一些好書給我嗎？',
    },
    {
      'icon': Icons.favorite,
      'title': '分享心情',
      'text': '我想分享一下最近的閱讀心得',
    },
    {
      'icon': Icons.lightbulb,
      'title': '尋求啟發',
      'text': '最近有點迷茫，需要一些人生指引',
    },
  ];

  /// 附加功能選項
  List<Map<String, dynamic>> get attachmentOptions => [
    {
      'icon': Icons.photo_library,
      'title': '讀書照片',
      'color': AppTheme.nearlyBlue,
      'onTap': () => _handlePhotoUpload(),
    },
    {
      'icon': Icons.note_add,
      'title': '讀書筆記',
      'color': AppTheme.nearlyDarkBlue,
      'onTap': () => _handleNoteAdd(),
    },
    {
      'icon': Icons.bookmark,
      'title': '書籍資訊',
      'color': const Color(0xFFFF9800),
      'onTap': () => _handleBookInfo(),
    },
    {
      'icon': Icons.analytics,
      'title': '閱讀分析',
      'color': const Color(0xFF9C27B0),
      'onTap': () => _handleReadingAnalysis(),
    },
    {
      'icon': Icons.mood,
      'title': '心情記錄',
      'color': const Color(0xFFE91E63),
      'onTap': () => _handleMoodRecord(),
    },
    {
      'icon': Icons.schedule,
      'title': '閱讀計劃',
      'color': const Color(0xFF4CAF50),
      'onTap': () => _handleReadingPlan(),
    },
  ];

  /// 處理照片上傳
  void _handlePhotoUpload() {
    widget.controller.text = '我想分享一張讀書照片';
  }

  /// 處理筆記添加
  void _handleNoteAdd() {
    widget.controller.text = '我想記錄一些讀書筆記';
  }

  /// 處理書籍資訊
  void _handleBookInfo() {
    widget.controller.text = '我想詢問某本書的詳細資訊';
  }

  /// 處理閱讀分析
  void _handleReadingAnalysis() {
    widget.controller.text = '請幫我分析一下最近的閱讀狀況';
  }

  /// 處理心情記錄
  void _handleMoodRecord() {
    widget.controller.text = '我想記錄今天的閱讀心情';
  }

  /// 處理閱讀計劃
  void _handleReadingPlan() {
    widget.controller.text = '幫我制定一個閱讀計劃';
  }
}