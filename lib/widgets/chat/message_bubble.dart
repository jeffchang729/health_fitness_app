// widgets/chat/message_bubble.dart

import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';
import '../../models/chat_message.dart';
import '../../utils/hex_color.dart';

/// 聊天訊息氣泡組件
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    required this.message,
    this.showAvatar = true,
  }) : super(key: key);

  final ChatMessage message;
  final bool showAvatar;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 8,
        bottom: showAvatar ? 16 : 4,
        left: message.isFromUser ? 48 : 0,
        right: message.isFromUser ? 0 : 48,
      ),
      child: Row(
        mainAxisAlignment: message.isFromUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // AI頭像（左側）
          if (!message.isFromUser && showAvatar) _buildAvatar(),
          
          // 訊息內容
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Column(
                crossAxisAlignment: message.isFromUser 
                    ? CrossAxisAlignment.end 
                    : CrossAxisAlignment.start,
                children: [
                  // 主要訊息氣泡
                  _buildMessageBubble(context),
                  
                  // 書籍推薦卡片
                  if (message.bookRecommendations != null && 
                      message.bookRecommendations!.isNotEmpty)
                    _buildBookRecommendations(context),
                  
                  // 時間戳記
                  if (showAvatar) _buildTimestamp(),
                ],
              ),
            ),
          ),
          
          // 使用者頭像（右側）
          if (message.isFromUser && showAvatar) _buildUserAvatar(),
        ],
      ),
    );
  }

  /// 建構AI頭像
  Widget _buildAvatar() {
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.only(right: 8, bottom: 20),
      decoration: BoxDecoration(
        color: AppTheme.nearlyDarkBlue.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.smart_toy,
        color: AppTheme.nearlyDarkBlue,
        size: 18,
      ),
    );
  }

  /// 建構使用者頭像
  Widget _buildUserAvatar() {
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.only(left: 8, bottom: 20),
      decoration: const BoxDecoration(
        color: AppTheme.nearlyDarkBlue,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person,
        color: AppTheme.white,
        size: 18,
      ),
    );
  }

  /// 建構訊息氣泡
  Widget _buildMessageBubble(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: message.isFromUser 
            ? AppTheme.nearlyDarkBlue 
            : AppTheme.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(message.isFromUser ? 20 : 4),
          bottomRight: Radius.circular(message.isFromUser ? 4 : 20),
        ),
        border: message.isFromUser 
            ? null 
            : Border.all(color: AppTheme.background, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppTheme.grey.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 訊息類型標籤（AI訊息）
          if (!message.isFromUser && message.messageType != MessageType.text)
            _buildMessageTypeLabel(),
          
          // 訊息內容
          Text(
            message.content,
            style: TextStyle(
              fontSize: 16,
              color: message.isFromUser 
                  ? AppTheme.white 
                  : AppTheme.darkerText,
              height: 1.4,
            ),
          ),
          
          // 情感語調指示器（AI訊息）
          if (!message.isFromUser && message.emotionalTone != null)
            _buildEmotionalIndicator(),
        ],
      ),
    );
  }

  /// 建構訊息類型標籤
  Widget _buildMessageTypeLabel() {
    String label;
    Color color;
    IconData icon;

    switch (message.messageType) {
      case MessageType.welcome:
        label = '歡迎';
        color = HexColor('#4CAF50');
        icon = Icons.waving_hand;
        break;
      case MessageType.bookRecommendation:
        label = '書籍推薦';
        color = HexColor('#FF9800');
        icon = Icons.menu_book;
        break;
      case MessageType.emotionalSupport:
        label = '情感支持';
        color = HexColor('#E91E63');
        icon = Icons.favorite;
        break;
      case MessageType.readingAnalysis:
        label = '閱讀分析';
        color = HexColor('#9C27B0');
        icon = Icons.analytics;
        break;
      case MessageType.personalAdvice:
        label = '個人建議';
        color = HexColor('#2196F3');
        icon = Icons.lightbulb;
        break;
      default:
        return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// 建構情感語調指示器
  Widget _buildEmotionalIndicator() {
    if (message.emotionalTone == null) return const SizedBox();

    String emoji;
    String label;

    switch (message.emotionalTone!) {
      case EmotionalTone.positive:
        emoji = '😊';
        label = '正面';
        break;
      case EmotionalTone.negative:
        emoji = '😔';
        label = '需要支持';
        break;
      case EmotionalTone.excited:
        emoji = '🎉';
        label = '興奮';
        break;
      case EmotionalTone.confused:
        emoji = '🤔';
        label = '困惑';
        break;
      case EmotionalTone.tired:
        emoji = '😴';
        label = '疲憊';
        break;
      case EmotionalTone.curious:
        emoji = '🧐';
        label = '好奇';
        break;
      default:
        return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(width: 4),
          Text(
            '檢測到：$label',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.grey.withOpacity(0.8),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  /// 建構書籍推薦卡片
  Widget _buildBookRecommendations(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: message.bookRecommendations!.map((book) => 
          _buildBookCard(context, book)
        ).toList(),
      ),
    );
  }

  /// 建構單個書籍卡片
  Widget _buildBookCard(BuildContext context, BookRecommendation book) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.nearlyDarkBlue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 書名和作者
          Row(
            children: [
              const Icon(
                Icons.menu_book,
                color: AppTheme.nearlyDarkBlue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkerText,
                      ),
                    ),
                    Text(
                      book.author,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.grey.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // 描述
          Text(
            book.description,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.darkText,
              height: 1.3,
            ),
          ),
          
          // 評分和分類
          if (book.rating != null || book.category != null)
            Container(
              margin: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  if (book.rating != null) ...[
                    Icon(
                      Icons.star,
                      color: HexColor('#FF9800'),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      book.rating!.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.grey.withOpacity(0.8),
                      ),
                    ),
                  ],
                  if (book.rating != null && book.category != null)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.grey.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                  if (book.category != null)
                    Text(
                      book.category!,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.grey.withOpacity(0.8),
                      ),
                    ),
                ],
              ),
            ),
          
          // 推薦理由
          if (book.reason != null)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.nearlyDarkBlue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.recommend,
                    color: AppTheme.nearlyDarkBlue,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      book.reason!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.nearlyDarkBlue,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// 建構時間戳記
  Widget _buildTimestamp() {
    return Container(
      margin: EdgeInsets.only(
        top: 4,
        left: message.isFromUser ? 0 : 40,
        right: message.isFromUser ? 40 : 0,
      ),
      child: Text(
        message.formattedTime,
        style: TextStyle(
          fontSize: 12,
          color: AppTheme.grey.withOpacity(0.6),
        ),
        textAlign: message.isFromUser ? TextAlign.end : TextAlign.start,
      ),
    );
  }
}