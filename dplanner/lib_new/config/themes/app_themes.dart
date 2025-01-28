import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = _createTheme(brightness: Brightness.light);

  static ThemeData _createTheme({
    required Brightness brightness,
  }) {
    const textTheme = TextTheme(
      // AppBar, 클럽 이름 등 큰 글씨
      displayLarge: TextStyle(fontWeight: FontWeight.w700, fontSize: 32, color: AppColors.textBlack),
      displayMedium: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: AppColors.textBlack),
      displaySmall: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: AppColors.textBlack),

      // 게시글 제목, 메뉴명 등 중간 글씨
      titleLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: AppColors.textBlack),
      titleMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.textBlack),

      // 본문, 인포 등 작은 글씨
      bodyLarge: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: AppColors.textBlack),
      bodyMedium: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: AppColors.textBlack),
      bodySmall: TextStyle(fontWeight: FontWeight.w400, fontSize: 10, color: AppColors.textBlack),

      // 버튼, 라벨 등등
      labelLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.textBlack),
      labelMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textBlack),

      // DO_NOT_USE - 나중에 필요하면 추가합시다
      headlineLarge: TextStyle(fontWeight: null, fontSize: 0),
      headlineMedium: TextStyle(fontWeight: null, fontSize: 0),
      headlineSmall: TextStyle(fontWeight: null, fontSize: 0),
      titleSmall: TextStyle(fontWeight: null, fontSize: 0),
      labelSmall: TextStyle(fontWeight: null, fontSize: 0),
    );

    const primaryIconTheme = IconThemeData(color: AppColors.textBlack, size: 24.0);
    const secondaryIconTheme = IconThemeData(color: AppColors.textGray);

    return ThemeData(
      /// GENERAL
      useMaterial3: true,
      extensions: [

      ],
      inputDecorationTheme: InputDecorationTheme(

      ),
      scrollbarTheme: ScrollbarThemeData(

      ),

      /// COLOR
      brightness: brightness,
      colorSchemeSeed: AppColors.primaryColor,
    //   colorScheme: ColorScheme(
    //     brightness: brightness,
    //     primary: primary,
    //     onPrimary: onPrimary,
    //     secondary: secondary,
    //     onSecondary: onSecondary,
    //     error: error,
    //     onError: onError,
    //     surface: surface,
    //     onSurface: onSurface
    // ),

      // TYPOGRAPHY & ICONOGRAPHY
      fontFamily: "Pretendard",
      primaryIconTheme: primaryIconTheme,
      iconTheme: secondaryIconTheme,
      textTheme: textTheme,

      // COMPONENT THEMES
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bgWhite,
        scrolledUnderElevation: 0,
        iconTheme: primaryIconTheme,
        actionsIconTheme: primaryIconTheme,
        centerTitle: true,
        toolbarHeight: 60,
        titleTextStyle: textTheme.displayMedium,
      ),

      // badgeTheme: BadgeThemeData(
      //   backgroundColor: ,
      //   textColor: ,
      //   smallSize: ,
      //   largeSize: ,
      //   textStyle: ,
      //   padding: ,
      //   alignment: ,
      //   offset: ,
      // ),

      // bottomNavigationBarTheme:BottomNavigationBarThemeData(
      //   backgroundColor: ,
      //   elevation: ,
      //   selectedIconTheme: ,
      //   unselectedIconTheme: ,
      //   selectedItemColor: ,
      //   unselectedItemColor: ,
      //   selectedLabelStyle: ,
      //   unselectedLabelStyle: ,
      //   showSelectedLabels: ,
      //   showUnselectedLabels: ,
      //   type: ,
      //   enableFeedback: ,
      //   landscapeLayout: ,
      //   mouseCursor: ,
      // ),

      // navigationBarTheme: NavigationBarThemeData(
      //   height: ,
      //   backgroundColor: ,
      //   elevation: ,
      //   shadowColor: ,
      //   surfaceTintColor: ,
      //   indicatorColor: ,
      //   indicatorShape: ,
      //   labelTextStyle: ,
      //   iconTheme: ,
      //   labelBehavior: ,
      //   overlayColor: ,
      // ),

      // bottomSheetTheme: BottomSheetThemeData(
      //   backgroundColor: ,
      //   surfaceTintColor: ,
      //   elevation: ,
      //   modalBackgroundColor: ,
      //   modalBarrierColor: ,
      //   shadowColor: ,
      //   modalElevation: ,
      //   shape: ,
      //   showDragHandle: ,
      //   dragHandleColor: ,
      //   dragHandleSize: ,
      //   clipBehavior: ,
      //   constraints:
      // ),

      // snackBarTheme: SnackBarThemeData(
      //     backgroundColor: ,
      //     actionTextColor: ,
      //     disabledActionTextColor: ,
      //     contentTextStyle: ,
      //     elevation: ,
      //     shape: ,
      //     behavior: ,
      //     width: ,
      //     insetPadding: ,
      //     showCloseIcon: ,
      //     closeIconColor: ,
      //     actionOverflowThreshold: ,
      //     actionBackgroundColor: ,
      //     disabledActionBackgroundColor: ,
      //     dismissDirection:
      // ),

      // dialogTheme: DialogTheme(
      //   backgroundColor:,
      //   elevation: ,
      //   shadowColor: ,
      //   surfaceTintColor: ,
      //   shape: ,
      //   alignment: ,
      //   iconColor: ,
      //   titleTextStyle: ,
      //   contentTextStyle: ,
      //   actionsPadding: ,
      //   barrierColor: ,
      //   insetPadding: ,
      //   clipBehavior: ,
      // ),

      // checkboxTheme: CheckboxThemeData(
      //   mouseCursor: ,
      //   fillColor: ,
      //   checkColor:,
      //   overlayColor: ,
      //   splashRadius:,
      //   materialTapTargetSize: ,
      //   visualDensity: ,
      //   shape: ,
      //   side: ,
      // ),

      // radioTheme: RadioThemeData(
      //   mouseCursor: ,
      //   fillColor: ,
      //   overlayColor: ,
      //   splashRadius: ,
      //   materialTapTargetSize: ,
      //   visualDensity:
      // ),

      // switchTheme: SwitchThemeData(
      //   thumbColor: ,
      //   trackColor: ,
      //   trackOutlineColor: ,
      //   trackOutlineWidth: ,
      //   materialTapTargetSize: ,
      //   mouseCursor: ,
      //   overlayColor: ,
      //   splashRadius: ,
      //   thumbIcon:
      // ),

      // dropdownMenuTheme: DropdownMenuThemeData(
      //   textStyle: ,
      //   inputDecorationTheme: ,
      //   menuStyle: ,
      // ),

      popupMenuTheme: PopupMenuThemeData(),

      // tabBarTheme: TabBarTheme(
      //   indicator: ,
      //   indicatorColor: ,
      //   indicatorSize: ,
      //   dividerColor: ,
      //   dividerHeight: ,
      //   labelColor: ,
      //   labelPadding: ,
      //   labelStyle: ,
      //   unselectedLabelColor: ,
      //   unselectedLabelStyle: ,
      //   overlayColor: ,
      //   splashFactory: ,
      //   mouseCursor: ,
      //   tabAlignment: ,
      //   textScaler:
      // ),

      buttonTheme: ButtonThemeData(),
      elevatedButtonTheme: ElevatedButtonThemeData(),
      filledButtonTheme: FilledButtonThemeData(),
      floatingActionButtonTheme: FloatingActionButtonThemeData(),
      iconButtonTheme: IconButtonThemeData(),
      outlinedButtonTheme: OutlinedButtonThemeData(),
      segmentedButtonTheme: SegmentedButtonThemeData(),
      textButtonTheme: TextButtonThemeData(),
      toggleButtonsTheme: ToggleButtonsThemeData(),

      progressIndicatorTheme: ProgressIndicatorThemeData(),
    );
  }
}