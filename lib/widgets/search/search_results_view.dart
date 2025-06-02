// widgets/search/search_results_view.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../themes/app_theme.dart';
import '../../../services/google_books_service.dart';
import '../../models/book_detail_modal.dart';

/// 搜尋結果展示元件
/// 
/// 功能特色：
/// - 統一的書籍項目展示
/// - AI 推薦標識
/// - 互動式書籍詳情
/// - 優雅的載入動畫
class SearchResultsView extends StatefulWidget {
  final List<BookItem> books;
  final bool isAIMode;
  final String searchQuery;
  final bool isPreview;

  const SearchResultsView({
    Key? key,
    required this.books,
    required this.isAIMode,
    required this.searchQuery,
    this.isPreview = false,
  }) : super(key: key);

  @override
  _SearchResultsViewState createState() => _SearchResultsViewState();
}

class _SearchResultsViewState extends State<SearchResultsView>
    with TickerProviderStateMixin {
  late AnimationController _listAnimationController;
  late List<AnimationController> _itemAnimationControllers;
  late List<Animation<double>> _itemAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _listAnimationController.dispose();
    for (var controller in _itemAnimationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  /// 初始化動畫控制器
  void _initializeAnimations() {
    _listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // 為每個書籍項目建立動畫控制器
    _itemAnimationControllers = List.generate(
      widget.books.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 300 + (index * 50)),
        vsync: this,
      ),
    );

    // 建立交錯動畫
    _itemAnimations = _itemAnimationControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutQuart),
      );
    }).toList();

    // 啟動動畫
    _startAnimations();
  }

  /// 啟動交錯動畫
  void _startAnimations() {
    _listAnimationController.forward();
    
    for (int i = 0; i < _itemAnimationControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 80), () {
        if (mounted) {
          _itemAnimationControllers[i].forward();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.books.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 結果標題
        if (!widget.isPreview) _buildResultsHeader(),
        
        // 書籍列表
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: widget.isPreview ? 0 : 16,
            ),
            itemCount: widget.books.length,
            itemBuilder: (context, index) {
              if (index < _itemAnimations.length) {
                return AnimatedBuilder(
                  animation: _itemAnimations[index],
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 30 * (1 - _itemAnimations[index].value)),
                      child: Opacity(
                        opacity: _itemAnimations[index].value,
                        child: _buildBookItem(widget.books[index], index),
                      ),
                    );
                  },
                );
              }
              return _buildBookItem(widget.books[index], index);
            },
          ),
        ),
      ],
    );
  }

  /// 建立結果標題
  Widget _buildResultsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Icon(
            widget.isAIMode ? Icons.psychology : Icons.search,
            color: widget.isAIMode ? Color(0xFF6F72CA) : Color(0xFF738AE6),
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.isAIMode 
                ? '為您推薦 ${widget.books.length} 本書籍'
                : '找到 ${widget.books.length} 本相關書籍',
              style: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppTheme.darkerText,
              ),
            ),
          ),
          if (widget.isAIMode)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6F72CA), Color(0xFF1E1466)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'AI 推薦',
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 建立書籍項目
  Widget _buildBookItem(BookItem book, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showBookDetails(book),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 書籍封面
                _buildBookCover(book),
                const SizedBox(width: 16),
                
                // 書籍資訊
                Expanded(
                  child: _buildBookInfo(book, index),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 建立書籍封面
  Widget _buildBookCover(BookItem book) {
    return Container(
      width: 80,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 封面圖片
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: book.hasCoverImage
                ? CachedNetworkImage(
                    imageUrl: book.coverImageUrl!,
                    width: 80,
                    height: 120,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => _buildPlaceholderCover(),
                    errorWidget: (context, url, error) => _buildPlaceholderCover(),
                  )
                : _buildPlaceholderCover(),
          ),
          
          // AI 推薦標識
          if (widget.isAIMode)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6F72CA), Color(0xFF1E1466)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF6F72CA).withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.psychology,
                  color: AppTheme.white,
                  size: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 建立預設封面
  Widget _buildPlaceholderCover() {
    return Container(
      width: 80,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.nearlyWhite,
            AppTheme.nearlyWhite.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.menu_book,
        color: AppTheme.grey,
        size: 32,
      ),
    );
  }

  /// 建立書籍資訊
  Widget _buildBookInfo(BookItem book, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 書名
        Text(
          book.title,
          style: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: AppTheme.darkerText,
            height: 1.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        
        const SizedBox(height: 6),
        
        // 作者
        Text(
          book.authorsString,
          style: TextStyle(
            fontFamily: AppTheme.fontName,
            fontSize: 13,
            color: AppTheme.grey,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        
        const SizedBox(height: 8),
        
        // 評分和分類
        Row(
          children: [
            if (book.averageRating != null) ...[
              Icon(Icons.star, size: 16, color: Colors.amber[600]),
              const SizedBox(width: 4),
              Text(
                book.averageRating!.toStringAsFixed(1),
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.amber[700],
                ),
              ),
              const SizedBox(width: 12),
            ],
            if (book.categories.isNotEmpty)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: widget.isAIMode 
                        ? Color(0xFF6F72CA).withOpacity(0.1)
                        : Color(0xFF738AE6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    book.categories.first,
                    style: TextStyle(
                      fontFamily: AppTheme.fontName,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: widget.isAIMode ? Color(0xFF6F72CA) : Color(0xFF738AE6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
          ],
        ),
        
        const SizedBox(height: 10),
        
        // 描述
        if (book.description != null && book.description!.isNotEmpty) ...[
          Text(
            book.getShortDescription(120),
            style: TextStyle(
              fontFamily: AppTheme.fontName,
              fontSize: 12,
              color: AppTheme.grey,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
        ],
        
        // AI 推薦理由（僅在 AI 模式顯示）
        if (widget.isAIMode) _buildAIReason(book),
        
        // 操作按鈕
        _buildActionButtons(book),
      ],
    );
  }

  /// 建立 AI 推薦理由
  Widget _buildAIReason(BookItem book) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF6F72CA).withOpacity(0.1),
            Color(0xFF1E1466).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Color(0xFF6F72CA).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.psychology,
                size: 14,
                color: Color(0xFF6F72CA),
              ),
              const SizedBox(width: 6),
              Text(
                'AI 推薦理由',
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6F72CA),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _getAIRecommendationReason(book),
            style: TextStyle(
              fontFamily: AppTheme.fontName,
              fontSize: 11,
              color: AppTheme.darkerText.withOpacity(0.8),
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// 建立操作按鈕
  Widget _buildActionButtons(BookItem book) {
    return Row(
      children: [
        // 收藏按鈕
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _addToFavorites(book),
            icon: Icon(Icons.favorite_border, size: 16),
            label: Text('收藏'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8),
              side: BorderSide(
                color: widget.isAIMode ? Color(0xFF6F72CA) : Color(0xFF738AE6),
                width: 1,
              ),
              foregroundColor: widget.isAIMode ? Color(0xFF6F72CA) : Color(0xFF738AE6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        
        const SizedBox(width: 8),
        
        // 詳情按鈕
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _showBookDetails(book),
            icon: Icon(Icons.info_outline, size: 16),
            label: Text('詳情'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8),
              backgroundColor: widget.isAIMode ? Color(0xFF6F72CA) : Color(0xFF738AE6),
              foregroundColor: AppTheme.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  /// 顯示書籍詳細資訊
  void _showBookDetails(BookItem book) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BookDetailModal(
        book: book,
        isAIMode: widget.isAIMode,
        searchQuery: widget.searchQuery,
      ),
    );
  }

  /// 新增到收藏
  void _addToFavorites(BookItem book) {
    // TODO: 實作收藏功能
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('《${book.title}》已加入收藏'),
        backgroundColor: widget.isAIMode ? Color(0xFF6F72CA) : Color(0xFF738AE6),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// 取得 AI 推薦理由
  String _getAIRecommendationReason(BookItem book) {
    final query = widget.searchQuery.toLowerCase();
    
    if (query.contains('領導') || query.contains('管理')) {
      return '此書能幫助您建立領導思維，提升團隊管理技能';
    } else if (query.contains('自我') || query.contains('成長')) {
      return '專為個人成長設計，助您建立更好的生活習慣';
    } else if (query.contains('創意') || query.contains('創新')) {
      return '激發創意潛能，培養創新思維和解決問題的能力';
    } else if (query.contains('效率') || query.contains('時間')) {
      return '提供實用的效率技巧，幫助您更好地管理時間';
    } else if (query.contains('溝通') || query.contains('人際')) {
      return '改善溝通技巧，建立更好的人際關係';
    } else {
      return '根據您的需求精心推薦，內容與目標高度匹配';
    }
  }
}