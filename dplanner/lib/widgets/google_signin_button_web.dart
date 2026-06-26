import 'package:flutter/widgets.dart';
import 'package:google_sign_in_web/web_only.dart' as web;

/// 웹용: GIS(Google Identity Services) 렌더링 버튼.
/// 클릭 시 GoogleSignIn().onCurrentUserChanged 로 로그인 계정이 전달된다.
Widget googleSignInButton() => web.renderButton(
      configuration: web.GSIButtonConfiguration(minimumWidth: 320),
    );
