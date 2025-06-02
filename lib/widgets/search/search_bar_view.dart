// widgets/search/search_bar_view.dart

import '../../themes/app_theme.dart';
import '../../utils/hex_color.dart';
import 'package:flutter/material.dart';

/// 搜尋列視圖 - 支援AI推薦和一般搜尋模式切換
class SearchBarView extends StatefulWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const SearchBarView({Key? key, this.animationController, this.animation})
      : super(key: key);

  @override
  _SearchBarViewState createState() => _SearchBarViewState();
}

class _SearchBarViewState extends State<SearchBarView> {
  bool isAiMode = false; // 是否為AI推薦模式
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
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
                    // 模式切換按鈕
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppTheme.background,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Row(
                                children: [
                                  // 一般搜尋按鈕
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isAiMode = false;
                                        });
                                      },
                                      child: Container(
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: !isAiMode 
                                              ? AppTheme.white 
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(18),
                                          boxShadow: !isAiMode ? <BoxShadow>[
                                            BoxShadow(
                                                color: AppTheme.grey.withOpacity(0.2),
                                                offset: Offset(0, 1),
                                                blurRadius: 3.0),
                                          ] : null,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '一般搜尋',
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontName,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: !isAiMode 
                                                  ? AppTheme.darkerText 
                                                  : AppTheme.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // AI推薦按鈕
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isAiMode = true;
                                        });
                                      },
                                      child: Container(
                                        height: 36,
                                        decoration: BoxDecoration(
                                          gradient: isAiMode ? LinearGradient(
                                            colors: [
                                              AppTheme.nearlyDarkBlue,
                                              HexColor('#6A88E5'),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ) : null,
                                          borderRadius: BorderRadius.circular(18),
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.psychology,
                                                size: 16,
                                                color: isAiMode 
                                                    ? AppTheme.white 
                                                    : AppTheme.grey,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                'AI推薦',
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: isAiMode 
                                                      ? AppTheme.white 
                                                      : AppTheme.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // 搜尋輸入框
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: isAiMode 
                                ? '我想要成為什麼樣的人...' 
                                : '搜尋書名、作者、關鍵字...',
                            hintStyle: TextStyle(
                              fontFamily: AppTheme.fontName,
                              fontSize: 14,
                              color: AppTheme.grey.withOpacity(0.6),
                            ),
                            prefixIcon: Icon(
                              isAiMode ? Icons.psychology : Icons.search,
                              color: AppTheme.grey,
                            ),
                            suffixIcon: searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear, color: AppTheme.grey),
                                    onPressed: () {
                                      setState(() {
                                        searchController.clear();
                                      });
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              _handleSearch(value);
                            }
                          },
                        ),
                      ),
                    ),
                    
                    // 快捷搜尋建議（僅在AI模式下顯示）
                    if (isAiMode && searchController.text.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '熱門志向',
                              style: TextStyle(
                                fontFamily: AppTheme.fontName,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.grey,
                              ),
                            ),
                            SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                '成功企業家',
                                '高效率工作者',
                                '心理學專家',
                                '領導者',
                                '創意思考者',
                              ].map((suggestion) => _buildSuggestionChip(suggestion)).toList(),
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

  Widget _buildSuggestionChip(String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          searchController.text = text;
        });
        _handleSearch(text);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.nearlyDarkBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.nearlyDarkBlue.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: AppTheme.fontName,
            fontSize: 12,
            color: AppTheme.nearlyDarkBlue,
          ),
        ),
      ),
    );
  }

  void _handleSearch(String query) {
    // TODO: 實作搜尋邏輯
    print('搜尋: $query (${isAiMode ? "AI模式" : "一般模式"})');
  }
}