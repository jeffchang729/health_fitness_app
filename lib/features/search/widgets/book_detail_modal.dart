// lib/features/search/widgets/book_detail_modal.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/config/app_theme.dart';
import '../../../core/services/google_books_service.dart';

/// 書籍詳細資訊彈窗元件
/// 
/// 功能特色：
/// - 可拖拉的底部彈窗
/// - 完整的書籍資訊展示
/// - AI 推薦理由說明
/// - 互動操作按鈕
class BookDetailModal extends StatefulWidget {
  final BookItem book;
  final bool isAIMode;
  final String searchQuery;

  const BookDetailModal({
    Key? key,
    required this.book,
    required this.isAIMode,
    required this.searchQuery,
  }) : super(key: key);

  @override
  _BookDetailModalState createState() => _BookDetailModalState();
}

class _BookDetailModalState extends State<BookDetailModal>
    with TickerProviderStateMixin {
  late AnimationController _slideAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _slideAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  /// 初始化動畫
  void _initializeAnimations() {
    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    ));

    // 啟動動畫
    _slideAnimationController.forward();
    _fadeAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: DraggableScrollableSheet(
            initialChildSize: 0.75,
            maxChildSize: 0.95,
            minChildSize: 0.4,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildDragHandle(),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: _buildContent(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// 建立拖拉指示器
  Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppTheme.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  /// 建立內容區域
  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 書籍基本資訊
        _buildBookHeader(),
        
        const SizedBox(height: 24),
        
        // AI 推薦理由（僅在 AI 模式顯示）
        if (widget.isAIMode) ...[
          _buildAIRecommendationSection(),
          const SizedBox(height: 24),
        ],
        
        // 書籍詳細資訊
        _buildBookDetails(),
        
        const SizedBox(height: 24),
        
        // 內容簡介
        if (widget.book.description != null && widget.book.description!.isNotEmpty) ...[
          _buildDescriptionSection(),
          const SizedBox(height: 24),
        ],
        
        // 操作按鈕
        _buildActionSection(),
        
        SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
      ],
    );
  }

  /// 建立書籍標題區域
  Widget _buildBookHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 書籍封面
        Container(
          width: 120,
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: widget.book.hasCoverImage
                    ? CachedNetworkImage(
                        imageUrl: widget.book.coverImageUrl!,
                        width: 120,
                        height: 180,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => _buildPlaceholderCover(),
                        errorWidget: (context, url, error) => _buildPlaceholderCover(),
                      )
                    : _buildPlaceholderCover(),
              ),
              
              // AI 推薦標識
              if (widget.isAIMode)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF6F72CA), Color(0xFF1E1466)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF6F72CA).withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.psychology,
                      color: AppTheme.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
        
        const SizedBox(width: 20),
        
        // 書籍資訊
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 書名
              Text(
                widget.book.title,
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.darkerText,
                  height: 1.3,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // 作者
              Text(
                widget.book.authorsString,
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.grey,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // 出版資訊
              if (widget.book.publisher != null) ...[
                _buildInfoRow(Icons.business, widget.book.publisher!),
                const SizedBox(height: 6),
              ],
              
              if (widget.book.publishedDate != null) ...[
                _buildInfoRow(Icons.calendar_today, 
                  '出版日期: ${widget.book.publishedDate}'),
                const SizedBox(height: 6),
              ],
              
              // 評分
              if (widget.book.averageRating != null) ...[
                const SizedBox(height: 8),
                _buildRatingRow(),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// 建立預設封面
  Widget _buildPlaceholderCover() {
    return Container(
      width: 120,
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.nearlyWhite,
            AppTheme.nearlyWhite.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        Icons.menu_book,
        color: AppTheme.grey,
        size: 48,
      ),
    );
  }

  /// 建立資訊行
  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: AppTheme.grey,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: AppTheme.fontName,
              fontSize: 12,
              color: AppTheme.grey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// 建立評分行
  Widget _buildRatingRow() {
    return Row(
      children: [
        ...List.generate(5, (index) {
          return Icon(
            index < widget.book.averageRating!.round()
                ? Icons.star
                : Icons.star_border,
            size: 18,
            color: Colors.amber[600],
          );
        }),
        const SizedBox(width: 8),
        Text(
          '${widget.book.averageRating!.toStringAsFixed(1)} (${widget.book.ratingsCount ?? 0} 評分)',
          style: TextStyle(
            fontFamily: AppTheme.fontName,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.amber[700],
          ),
        ),
      ],
    );
  }

  /// 建立 AI 推薦理由區域
  Widget _buildAIRecommendationSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6F72CA), Color(0xFF1E1466)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6F72CA).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.psychology,
                  color: AppTheme.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'AI 推薦理由',
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: AppTheme.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _getDetailedAIRecommendationReason(),
            style: TextStyle(
              fontFamily: AppTheme.fontName,
              fontSize: 15,
              color: AppTheme.white.withOpacity(0.95),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// 建立書籍詳細資訊
  Widget _buildBookDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '詳細資訊',
          style: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppTheme.darkerText,
          ),
        ),
        const SizedBox(height: 16),
        
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.nearlyWhite,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildDetailRow('頁數', widget.book.pageCount?.toString() ?? '未知'),
              _buildDetailRow('語言', _getLanguageName(widget.book.language ?? '')),
              _buildDetailRow('分類', widget.book.categoriesString.isNotEmpty 
                  ? widget.book.categoriesString : '未分類'),
              if (widget.book.ratingsCount != null)
                _buildDetailRow('評價數量', '${widget.book.ratingsCount} 人評價'),
            ],
          ),
        ),
      ],
    );
  }

  /// 建立詳細資訊行
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: AppTheme.fontName,
                fontSize: 13,
                color: AppTheme.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: AppTheme.fontName,
                fontSize: 13,
                color: AppTheme.darkerText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 建立內容簡介區域
  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '內容簡介',
          style: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppTheme.darkerText,
          ),
        ),
        const SizedBox(height: 16),
        
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.nearlyWhite,
              width: 1,
            ),
          ),
          child: Text(
            widget.book.description!,
            style: TextStyle(
              fontFamily: AppTheme.fontName,
              fontSize: 14,
              color: AppTheme.darkerText,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  /// 建立操作區域
  Widget _buildActionSection() {
    return Column(
      children: [
        // 主要操作按鈕
        Row(
          children: [
            // 收藏按鈕
            Expanded(
              child: Container(
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: _toggleFavorite,
                  icon: Icon(
                    _isFavorited ? Icons.favorite : Icons.favorite_border,
                    size: 20,
                  ),
                  label: Text(_isFavorited ? '已收藏' : '收藏'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: _isFavorited 
                          ? Colors.red.withOpacity(0.5)
                          : (widget.isAIMode ? Color(0xFF6F72CA) : Color(0xFF738AE6)),
                      width: 1.5,
                    ),
                    foregroundColor: _isFavorited 
                        ? Colors.red
                        : (widget.isAIMode ? Color(0xFF6F72CA) : Color(0xFF738AE6)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // 預覽按鈕
            Expanded(
              child: Container(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: widget.book.previewLink != null 
                      ? _openPreview 
                      : null,
                  icon: Icon(Icons.preview, size: 20),
                  label: Text('預覽'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.isAIMode ? Color(0xFF6F72CA) : Color(0xFF738AE6),
                    foregroundColor: AppTheme.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // 次要操作按鈕
        SizedBox(
          width: double.infinity,
          height: 48,
          child: TextButton.icon(
            onPressed: widget.book.infoLink != null 
                ? _openMoreInfo 
                : null,
            icon: Icon(Icons.info_outline, size: 18),
            label: Text('查看更多資訊'),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 切換收藏狀態
  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFavorited 
            ? '《${widget.book.title}》已加入收藏' 
            : '《${widget.book.title}》已移除收藏'),
        backgroundColor: widget.isAIMode ? Color(0xFF6F72CA) : Color(0xFF738AE6),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// 開啟預覽
  void _openPreview() {
    // TODO: 實作預覽功能
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('開啟預覽: ${widget.book.previewLink}'),
        backgroundColor: widget.isAIMode ? Color(0xFF6F72CA) : Color(0xFF738AE6),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// 開啟更多資訊
  void _openMoreInfo() {
    // TODO: 實作更多資訊功能
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('開啟更多資訊: ${widget.book.infoLink}'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// 取得詳細的 AI 推薦理由
  String _getDetailedAIRecommendationReason() {
    final query = widget.searchQuery.toLowerCase();
    
    if (query.contains('領導') || query.contains('管理')) {
      return '這本書深入探討現代領導力的核心要素，從團隊建設到決策制定，提供實用的管理技巧。特別適合想要提升領導能力、建立高效團隊的您。書中的案例分析和實戰策略將幫助您成為更出色的領導者。';
    } else if (query.contains('自我') || query.contains('成長')) {
      return '本書專為個人成長而設計，結合心理學原理和實用方法，幫助您建立正向習慣、提升自我認知。從目標設定到行動執行，提供系統性的成長框架，讓您在人生各個層面都能持續進步。';
    } else if (query.contains('創意') || query.contains('創新')) {
      return '這本書將激發您的創意潛能，介紹多種創新思維技巧和方法。從設計思考到問題解決，幫助您培養創意思維模式，在工作和生活中找到突破性的解決方案。';
    } else if (query.contains('效率') || query.contains('時間')) {
      return '專注於效率提升的實用指南，提供科學化的時間管理方法和工作技巧。幫助您優化工作流程、提高專注力，達到更好的工作生活平衡，讓每一天都更有成效。';
    } else if (query.contains('溝通') || query.contains('人際')) {
      return '深入分析人際溝通的核心技巧，從傾聽技巧到表達方法，幫助您建立更好的人際關係。無論是職場溝通還是生活交流，都能讓您更自信、更有效地與他人互動。';
    } else {
      return '根據您的搜尋需求，AI 分析了這本書的內容和您的目標，發現兩者高度匹配。書中的觀點和方法將為您提供實用的知識和深刻的啟發，幫助您達成個人成長目標。';
    }
  }

  /// 取得語言名稱
  String _getLanguageName(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'en':
        return '英文';
      case 'zh-tw':
      case 'zh':
        return '中文';
      case 'ja':
        return '日文';
      case 'ko':
        return '韓文';
      case 'fr':
        return '法文';
      case 'de':
        return '德文';
      case 'es':
        return '西班牙文';
      default:
        return languageCode.isNotEmpty ? languageCode.toUpperCase() : '未知';
    }
  }
}