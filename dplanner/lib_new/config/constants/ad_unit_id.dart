import 'package:flutter/foundation.dart';

/// adMob ad unit id
/// 개발 환경에서 실제 ad unit id를 사용하면 부정 트래픽으로 간주될 수 있음
const Map<String, String> UNIT_ID = kReleaseMode
    ? {
        'ios': 'ca-app-pub-8322251544420951/4841918397',
        'android': 'ca-app-pub-8322251544420951/8114454153'
      } // 배포용 ad unit id
    : {
        'ios': 'ca-app-pub-3940256099942544/2934735716',
        'android': 'ca-app-pub-3940256099942544/6300978111'
      }; // 테스트용 ad unit id
