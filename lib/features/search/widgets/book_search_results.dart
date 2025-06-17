// lib/features/search/widgets/book_search_results.dart
import 'package:flutter/material.dart';
import '../../../core/config/app_theme.dart';
import '../../../core/services/google_books_service.dart';

/// 書籍搜尋結果展示組件
class BookSearchResults extends StatelessWidget {
  const BookSearchResults({
    Key? key,
    required this.results,
    required this.onBookSelected,
  }) : super(key: key);

  final List<BookSearchResult> results;
  final Function(BookSearchResult) onBookSelected;

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 搜尋結果標題
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 8),
          child: Row(
            children: [
              const Text(
                '搜尋結果',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkerText,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.nearlyDarkBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${results.length}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.nearlyDarkBlue,
                  ),
                ),
              ),
            ],
          ),
        ),

        // 搜尋結果列表 - 使用新版卡片
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: results.length,
          itemBuilder: (context, index) {
            return NewBookResultCard(
              book: results[index],
              onTap: () => onBookSelected(results[index]),
            );
          },
        ),
      ],
    );
  }
}

/// 新版書籍搜尋結果卡片組件
class NewBookResultCard extends StatelessWidget {
  const NewBookResultCard({
    Key? key,
    required this.book,
    required this.onTap,
  }) : super(key: key);

  final BookSearchResult book;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppTheme.grey.withOpacity(0.1),
              offset: const Offset(0, 4),
              blurRadius: 20.0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 書籍資訊頭部
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 書籍封面
                  _buildBookCover(),
                  
                  const SizedBox(width: 16),
                  
                  // 書籍基本資訊
                  Expanded(
                    child: _buildBookBasicInfo(),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // 書籍描述
              _buildBookDescription(),
              
              const SizedBox(height: 16),
              
              // 底部標籤和按鈕
              _buildBottomSection(),
            ],
          ),
        ),
      ),
    );
  }

  /// 建構書籍封面
  Widget _buildBookCover() {
    return Container(
      width: 90,
      height: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppTheme.grey.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 12.0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: book.safeThumbnail != null
            ? Image.network(
                book.safeThumbnail!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderCover();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildLoadingCover();
                },
              )
            : _buildPlaceholderCover(),
      ),
    );
  }

  /// 建構預設封面
  Widget _buildPlaceholderCover() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6C7CE7),
            Color(0xFF4A90E2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_stories,
              color: AppTheme.white,
              size: 32,
            ),
            SizedBox(height: 8),
            Text(
              '書籍',
              style: TextStyle(
                color: AppTheme.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 建構載入中封面
  Widget _buildLoadingCover() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: AppTheme.nearlyDarkBlue,
          ),
        ),
      ),
    );
  }

  /// 建構書籍基本資訊
  Widget _buildBookBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 書名
        Text(
          book.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkerText,
            height: 1.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        
        const SizedBox(height: 8),
        
        // 作者
        Text(
          book.authorsText,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6C7CE7),
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        
        const SizedBox(height: 12),
        
        // 評分和出版年份
        Row(
          children: [
            // 評分
            if (book.averageRating != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      size: 14,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      book.ratingText,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.amber[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ],
            
            // 出版年份
            if (book.publishedDate != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF50C878).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  book.publishedDate!.length >= 4 
                      ? book.publishedDate!.substring(0, 4) 
                      : book.publishedDate!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF50C878),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        
        const SizedBox(height: 12),
        
        // 頁數
        if (book.pageCount != null) ...[
          Row(
            children: [
              const Icon(
                Icons.menu_book,
                size: 14,
                color: AppTheme.grey,
              ),
              const SizedBox(width: 4),
              Text(
                book.pageCountText,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  /// 建構書籍描述
  Widget _buildBookDescription() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.background.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        book.shortDescription,
        style: const TextStyle(
          fontSize: 14,
          color: AppTheme.darkText,
          height: 1.5,
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// 建構底部區域
  Widget _buildBottomSection() {
    return Row(
      children: [
        // 分類標籤
        if (book.categories.isNotEmpty) ...[
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: book.categories.take(2).map((category) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.nearlyDarkBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.nearlyDarkBlue.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.nearlyDarkBlue,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
        
        const SizedBox(width: 12),
        
        // 操作按鈕
        _buildActionButtons(),
      ],
    );
  }

  /// 建構操作按鈕
  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 收藏按鈕
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppTheme.nearlyDarkBlue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.bookmark_border,
              size: 18,
              color: AppTheme.nearlyDarkBlue,
            ),
            padding: EdgeInsets.zero,
          ),
        ),
        
        const SizedBox(width: 8),
        
        // 分享按鈕
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppTheme.nearlyDarkBlue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.share_outlined,
              size: 18,
              color: AppTheme.nearlyDarkBlue,
            ),
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}