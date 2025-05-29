/// 飲食資料模型
/// 
/// 用於表示一餐的完整資訊，包含：
/// - 圖片路徑和顯示名稱
/// - 漸層顏色配置
/// - 食物清單和卡路里計算
class MealsListData {
  MealsListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.startColor = '',
    this.endColor = '',
    this.meals,
    this.kacl = 0,
  });

  /// 餐點圖片檔案路徑
  String imagePath;
  
  /// 餐點顯示名稱（早餐、午餐、晚餐等）
  String titleTxt;
  
  /// 漸層開始顏色（十六進位格式）
  String startColor;
  
  /// 漸層結束顏色（十六進位格式）
  String endColor;
  
  /// 食物項目清單
  List<String>? meals;
  
  /// 卡路里數值
  int kacl;

  /// 預設餐點資料清單
  /// 
  /// 包含四種餐點類型的預設配置：
  /// - 早餐：麵包、花生醬、蘋果 (525大卡)
  /// - 午餐：鮭魚、綜合蔬菜、酪梨 (602大卡)
  /// - 點心：建議攝取800大卡
  /// - 晚餐：建議攝取703大卡
  static List<MealsListData> tabIconsList = <MealsListData>[
    // 早餐配置
    MealsListData(
      imagePath: 'assets/fitness_app/breakfast.png',
      titleTxt: 'Breakfast',
      kacl: 525,
      meals: <String>['Bread,', 'Peanut butter,', 'Apple'],
      startColor: '#FA7D82',
      endColor: '#FFB295',
    ),
    
    // 午餐配置
    MealsListData(
      imagePath: 'assets/fitness_app/lunch.png',
      titleTxt: 'Lunch',
      kacl: 602,
      meals: <String>['Salmon,', 'Mixed veggies,', 'Avocado'],
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    ),
    
    // 點心配置
    MealsListData(
      imagePath: 'assets/fitness_app/snack.png',
      titleTxt: 'Snack',
      kacl: 0, // 0 表示顯示建議攝取量而非實際數值
      meals: <String>['Recommend:', '800 kcal'],
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
    
    // 晚餐配置
    MealsListData(
      imagePath: 'assets/fitness_app/dinner.png',
      titleTxt: 'Dinner',
      kacl: 0, // 0 表示顯示建議攝取量而非實際數值
      meals: <String>['Recommend:', '703 kcal'],
      startColor: '#6F72CA',
      endColor: '#1E1466',
    ),
  ];

  /// 取得特定餐點類型的資料
  static MealsListData? getMealByType(String mealType) {
    try {
      return tabIconsList.firstWhere(
        (meal) => meal.titleTxt.toLowerCase() == mealType.toLowerCase(),
      );
    } catch (e) {
      return null; // 找不到對應的餐點類型
    }
  }

  /// 計算總卡路里（僅計算有實際數值的餐點）
  static int getTotalCalories() {
    return tabIconsList
        .where((meal) => meal.kacl > 0)
        .fold(0, (total, meal) => total + meal.kacl);
  }

  /// 檢查是否為建議餐點（顯示建議攝取量而非實際攝取）
  bool get isRecommendation => kacl == 0;

  /// 取得格式化的食物清單字串
  String get formattedMeals => meals?.join('\n') ?? '';

  /// 複製並修改餐點資料
  MealsListData copyWith({
    String? imagePath,
    String? titleTxt,
    String? startColor,
    String? endColor,
    List<String>? meals,
    int? kacl,
  }) {
    return MealsListData(
      imagePath: imagePath ?? this.imagePath,
      titleTxt: titleTxt ?? this.titleTxt,
      startColor: startColor ?? this.startColor,
      endColor: endColor ?? this.endColor,
      meals: meals ?? this.meals,
      kacl: kacl ?? this.kacl,
    );
  }
}