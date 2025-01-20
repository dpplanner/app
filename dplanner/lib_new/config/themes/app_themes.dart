import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData _createTheme({
    required Brightness brightness,
  }) {
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
      primaryIconTheme: IconThemeData(
          color: AppColors.textBlack
      ),
      iconTheme: IconThemeData(
        color: AppColors.textGray
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(),
        displayMedium: TextStyle(),
        displaySmall: TextStyle(),
        headlineLarge: TextStyle(),
        headlineMedium: TextStyle(),
        headlineSmall: TextStyle(),
        titleLarge: TextStyle(),
        titleMedium: TextStyle(),
        titleSmall: TextStyle(),
        bodyLarge: TextStyle(),
        bodyMedium: TextStyle(),
        bodySmall: TextStyle(),
        labelLarge: TextStyle(),
        labelMedium: TextStyle(),
        labelSmall: TextStyle()
      ),

      // COMPONENT THEMES
      // appBarTheme: AppBarTheme(
      //   color: ,
      //   backgroundColor: ,
      //   foregroundColor: ,
      //   elevation: ,
      //   scrolledUnderElevation: ,
      //   shadowColor: ,
      //   surfaceTintColor: ,
      //   shape: ,
      //   iconTheme: ,
      //   actionsIconTheme: ,
      //   centerTitle: ,
      //   titleSpacing: ,
      //   toolbarHeight: ,
      //   toolbarTextStyle: ,
      //   titleTextStyle: ,
      // ),

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