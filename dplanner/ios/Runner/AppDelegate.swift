import UIKit
import Flutter
import NaverThirdPartyLogin
import KakaoSDKAuth
import KakaoSDKCommon

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }
        
        GeneratedPluginRegistrant.register(with: self)
        
        if let appKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_API_KEY") as? String {
            KakaoSDK.initSDK(appKey: appKey)
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    //네이버 로그인 설정 추가하면서 추가한 override func
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if url.absoluteString.hasPrefix("kakao"){
            super.application(app, open:url, options: options)
            return true
        } else if url.absoluteString.contains("thirdPartyLoginResult") {
            NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
            return true
        } else {
            return true
        }
    }
}
