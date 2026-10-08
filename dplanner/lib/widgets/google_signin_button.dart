import 'package:flutter/widgets.dart';

import 'google_signin_button_stub.dart'
    if (dart.library.html) 'google_signin_button_web.dart' as impl;

/// 웹 전용 구글 로그인(GIS) 버튼.
///
/// 웹에서는 `GoogleSignIn().signIn()`이 deprecated/미지원이라,
/// google_sign_in_web이 제공하는 renderButton(구글이 렌더링하는 버튼)을 사용한다.
/// 모바일에서는 사용하지 않으며 stub이 빈 위젯을 반환한다.
Widget googleSignInButton() => impl.googleSignInButton();
