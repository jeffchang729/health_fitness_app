// lib/screens/search_screen.dart

import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import '../services/google_books_service.dart';
import '../widgets/search/book_search_results.dart';

/// 智慧搜尋畫面 - 採用莫蘭迪色系設計
class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key, this.animationController}) : super(key: key);
  
  /// 動畫控制器（可選）
  final AnimationController? animationController;

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with TickerProviderStateMixin {
  /// 動畫控制器
  late AnimationController animationController;
  
  /// 搜尋控制器
  final TextEditingController searchController = TextEditingController();
  
  /// 搜尋狀態
  bool isSearching = false;
  
  /// AI模式開關
  bool isAIMode = true;
  
  /// 搜尋結果
  List<BookSearchResult> searchResults = [];
  
  /// 錯誤訊息
  String? errorMessage;

  /// 志向分類列表
  final List<Map<String, dynamic>> aspirationCategories = [
    {'title': '成功的企業家', 'color': const Color(0xFFD4B895)}, // 莫蘭迪金
    {'title': '投資達人', 'color': const Color(0xFFA8B5A0)}, // 莫蘭迪綠
    {'title': '有影響力的人', 'color': const Color(0xFF9EAEC7)}, // 莫蘭迪藍
    {'title': '優秀的領導者', 'color': const Color(0xFFC5A3A3)}, // 莫蘭迪粉
    {'title': '創意工作者', 'color': const Color(0xFFB8A8C8)}, // 莫蘭迪紫
    {'title': '心理健康的人', 'color': const Color(0xFFA8C5A8)}, // 莫蘭迪淺綠
    {'title': '終身學習者', 'color': const Color(0xFFB5A895)}, // 莫蘭迪棕
    {'title': '有智慧的人', 'color': const Color(0xFF9BB5C7)}, // 莫蘭迪灰藍
  ];

  @override
  void initState() {
    // 使用傳入的動畫控制器或建立新的
    animationController = widget.animationController ?? AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    // 只有當動畫控制器是自己建立的才需要清理
    if (widget.animationController == null) {
      animationController.dispose();
    }
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            // 頂部應用欄
            _buildAppBarUI(),
            
            // 可滾動內容區域
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // 搜尋欄位
                    _buildSearchField(),
                    
                    // AI搜尋內容（膠囊按鈕）
                    if (isAIMode) _buildAISearchContent(),
                    
                    // 一般搜尋提示
                    if (!isAIMode) _buildGeneralSearchContent(),
                    
                    // 搜尋結果區域
                    if (searchResults.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      BookSearchResults(
                        results: searchResults,
                        onBookSelected: _openBookDetails,
                      ),
                    ],
                    
                    // 錯誤訊息顯示
                    if (errorMessage != null) ...[
                      const SizedBox(height: 24),
                      _buildErrorWidget(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 建構頂部應用欄
  Widget _buildAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white.withOpacity(0.9),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32.0),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppTheme.grey.withOpacity(0.4),
            offset: const Offset(1.1, 1.1),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16 - 8.0 * (1.0 - 1.0),
              bottom: 12 - 8.0 * (1.0 - 1.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '智慧搜尋',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontWeight: FontWeight.w700,
                        fontSize: 22 + 6 - 6 * (1.0 - 1.0),
                        letterSpacing: 1.2,
                        color: AppTheme.darkerText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 建構搜尋欄位
  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppTheme.grey.withOpacity(0.2),
              offset: const Offset(1.1, 1.1),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Row(
          children: [
            // 主要搜尋欄位
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: isAIMode 
                      ? '我想要成為什麼樣的人？' 
                      : '關鍵字搜尋',
                  hintStyle: TextStyle(
                    color: AppTheme.grey.withOpacity(0.6),
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    isAIMode ? Icons.psychology : Icons.search,
                    color: AppTheme.grey,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
                onSubmitted: (_) => _performSearch(),
              ),
            ),
            
            // AI按鈕 - 切換AI/一般模式
            GestureDetector(
              onTap: () {
                setState(() {
                  isAIMode = !isAIMode;
                  searchResults.clear();
                  errorMessage = null;
                  searchController.clear();
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isAIMode 
                      ? AppTheme.nearlyDarkBlue 
                      : AppTheme.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: isAIMode 
                          ? AppTheme.white 
                          : AppTheme.grey.withOpacity(0.7),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'AI',
                      style: TextStyle(
                        color: isAIMode 
                            ? AppTheme.white 
                            : AppTheme.grey.withOpacity(0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // 搜尋按鈕
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: isSearching 
                  ? const SizedBox(
                      width: 32,
                      height: 32,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTheme.nearlyDarkBlue,
                        ),
                      ),
                    )
                  : IconButton(
                      onPressed: _performSearch,
                      icon: const Icon(
                        Icons.send,
                        color: AppTheme.nearlyDarkBlue,
                        size: 20,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// 建構AI搜尋內容區域
  Widget _buildAISearchContent() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
      child: Column(
        children: [
          // 志向分類網格
          _buildAspirationGrid(),
        ],
      ),
    );
  }

  /// 建構志向分類網格
  Widget _buildAspirationGrid() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: aspirationCategories.map((category) {
        return _buildAspirationChip(
          category['title'],
          category['color'],
        );
      }).toList(),
    );
  }

  /// 建構志向膠囊按鈕
  Widget _buildAspirationChip(String title, Color color) {
    return GestureDetector(
      onTap: () {
        _searchByAspiration(title);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: color.withOpacity(0.3),
              offset: const Offset(0, 2),
              blurRadius: 8.0,
            ),
          ],
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: AppTheme.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// 建構一般搜尋內容區域
  Widget _buildGeneralSearchContent() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppTheme.grey.withOpacity(0.1),
              offset: const Offset(0, 2),
              blurRadius: 8.0,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Icons.search,
              size: 48,
              color: AppTheme.nearlyDarkBlue.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            const Text(
              '搜尋書籍',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkerText,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '輸入關鍵字搜尋相關書籍和資源',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 建構錯誤顯示組件
  Widget _buildErrorWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 32,
          ),
          const SizedBox(height: 8),
          const Text(
            '搜尋時發生錯誤',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            errorMessage!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.red.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              setState(() {
                errorMessage = null;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('重試'),
          ),
        ],
      ),
    );
  }

  /// 根據志向搜尋書籍
  void _searchByAspiration(String aspiration) async {
    setState(() {
      isSearching = true;
      errorMessage = null;
    });

    try {
      final books = await GoogleBooksService.searchByAspiration(aspiration);
      final bookResults = books.map((book) => book.toBookSearchResult()).toList();
      setState(() {
        isSearching = false;
        searchResults = bookResults;
      });
    } catch (e) {
      setState(() {
        isSearching = false;
        errorMessage = e.toString();
        searchResults = [];
      });
    }
  }

  /// 執行搜尋功能
  void _performSearch() async {
    if (searchController.text.isEmpty) return;
    
    setState(() {
      isSearching = true;
      errorMessage = null;
    });
    
    try {
      final books = await GoogleBooksService.searchBooks(
        query: searchController.text,
        maxResults: 20,
      );
      final bookResults = books.map((book) => book.toBookSearchResult()).toList();
      
      setState(() {
        isSearching = false;
        searchResults = bookResults;
      });
    } catch (e) {
      setState(() {
        isSearching = false;
        errorMessage = e.toString();
        searchResults = [];
      });
    }
  }

  /// 打開書籍詳情
  void _openBookDetails(BookSearchResult book) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
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
            
            // 書籍詳情內容
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 書籍標題
                    Text(
                      book.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkerText,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // 作者
                    Text(
                      book.authorsText,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.grey.withOpacity(0.8),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 書籍描述
                    Text(
                      book.description,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppTheme.darkText,
                        height: 1.5,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // 操作按鈕
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _showAddToLibraryDialog(book);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.nearlyDarkBlue,
                              foregroundColor: AppTheme.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('加入書單'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.nearlyDarkBlue,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('關閉'),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 顯示加入書單對話框
  void _showAddToLibraryDialog(BookSearchResult book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('加入書單'),
        content: Text('已將《${book.title}》加入您的個人書單！'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('確定'),
          ),
        ],
      ),
    );
  }
}