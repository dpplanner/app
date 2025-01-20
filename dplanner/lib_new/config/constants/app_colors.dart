import 'package:flutter/material.dart';

class AppColors extends Color {
  AppColors(super.value);

  static const bgPrimary = Color(0xFFF4F4FA);
  static const bgWhite = Color(0xFFFFFFFF);

  static const textBlack = Color(0xFF000000);
  static const textWhite = Color(0xFFFFFFFF);
  static const textGray = Color(0xFFA1A1A1);

  static const primaryColor = Color(0xFF7646D8);
  static const subColor1 = Color(0xFFA294DB);
  static const subColor2 = Color(0xFFE5DFFB);
  static const subColor3 = Color(0xFF908F9C);
  static const subColor4 = Color(0xFFE3E3F0);
  static const subColor5 = Color(0xFFBABABA);

  static const lockColor = Color(0xFFCDCDCD);
  static const markColor = Color(0xFFFF443D);
  static const hyperLink = Colors.blueAccent;

  static const List<Color> reservationColors = [
    Color(0xFFA294DB),
    Color(0xFFFF443D),
    Color(0xFFFFAE3D),
    Color(0xFF46D878),
    Color(0xFF3DDFFF),
    Color(0xFF3DA2FF),
    Color(0xFF6168AA),
    Color(0xFF80785E),
    Color(0xFFD9458C),
    Color(0xFFD9908D),
    Color(0xFF961E1E),
  ];

  static String getColorHex(Color color) {
    // 색상의 ARGB 값을 16진수 문자열로 변환
    final hexColor = color.value.toRadixString(16).padLeft(8, '0').toUpperCase();

    // '0xFF'를 제외한 6자리 색상 코드만 추출
    return hexColor.substring(2);
  }

  static Color ofHex(String hexCode) {
    // 입력 색상 코드가 6자리인지 확인
    if (hexCode.length != 6) {
      throw ArgumentError('색상 코드는 6자리여야 합니다.');
    }

    // '0xFF'를 붙여서 ARGB 형식으로 변환
    final colorString = 'FF$hexCode';

    // 16진수 문자열을 정수로 변환하고 Color 객체를 생성
    return reservationColors.firstWhere((color) => color == Color(int.parse(colorString, radix: 16)));
  }
}