import UIKit
import Flutter
import NidThirdPartyLogin

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }
        
        GeneratedPluginRegistrant.register(with: self)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
     override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
         if url.absoluteString.hasPrefix("kakao"){
            super.application(app, open:url, options: options)
            return true
         } else if NidOAuth.shared.handleURL(url) == true { // 네이버 앱에서 돌아온 로그인 결과 (flutter_naver_login 2.1.0+)
            return true
         } else {
            return true
         }
     }
}
