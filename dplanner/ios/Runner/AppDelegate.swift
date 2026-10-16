import UIKit
import Flutter
import NidThirdPartyLogin

// iOS 27 + Xcode 27 SDK 부터 UIScene 생명주기를 안 쓰면 실행 직후 종료된다 (Info.plist UIApplicationSceneManifest)
// https://flutter.dev/to/uiscene-migration
@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
    // Flutter는 scene delegate를 약한 참조로만 들고 있어 여기서 붙잡아 둔다
    private let naverLoginURLHandler = NaverLoginURLHandler()

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
        GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
        engineBridge.pluginRegistry.registrar(forPlugin: "NaverLoginURLHandler")?
            .addSceneDelegate(naverLoginURLHandler)
    }
}

// Scene 방식에서는 AppDelegate의 application(_:open:options:)가 호출되지 않아 URL을 Scene 이벤트로 받는다.
// 카카오 플러그인은 Flutter가 application(_:open:) 으로 대신 넘겨주지만, 네이버(flutter_naver_login 2.1.x)는
// 플러그인이 URL을 받지 않아 여기서 직접 넘긴다. 네이버 URL이 아니면 false → 다른 플러그인(카카오)이 처리.
class NaverLoginURLHandler: NSObject, FlutterSceneLifeCycleDelegate {
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) -> Bool {
        var handled = false
        for context in URLContexts where NidOAuth.shared.handleURL(context.url) {
            handled = true
        }
        return handled
    }
}
