import Flutter
import UIKit
import UserNotifications
import AudioToolbox

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let nativeChannel = FlutterMethodChannel(
      name: "xrp_monitor/native",
      binaryMessenger: controller.binaryMessenger
    )

    nativeChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in

      switch call.method {
      case "showNotification":
        if let args = call.arguments as? [String: Any],
           let title = args["title"] as? String,
           let message = args["message"] as? String,
           let withVibration = args["withVibration"] as? Bool {

          self.showNotification(title: title, message: message)
          if withVibration {
            self.vibrate()
          }
        }
        result(nil)

      case "vibrate":
        self.vibrate()
        result(nil)
        
      case "vibratePattern":
        if let args = call.arguments as? [String: Any],
           let pattern = args["pattern"] as? [Int] {
          self.vibratePattern(pattern: pattern)
        }
        result(nil)

      default:
        result(FlutterMethodNotImplemented)
      }
    })

    // ✅ Delegate 설정 (중복 conform 필요 없음)
    UNUserNotificationCenter.current().delegate = self
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
      if granted {
        print("Notification permission granted")
      } else {
        print("Notification permission denied")
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func showNotification(title: String, message: String) {
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = message
    content.sound = UNNotificationSound.default

    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)

    UNUserNotificationCenter.current().add(request) { (error) in
      if let error = error {
        print("Error showing notification: \(error)")
      }
    }
  }

  private func vibrate() {
    let impactGenerator = UIImpactFeedbackGenerator(style: .heavy)
    impactGenerator.impactOccurred()
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
  }
  
  private func vibratePattern(pattern: [Int]) {
    print("iOS - Vibrating with pattern: \(pattern)")
    
    // iOS에서는 단순하게 각 진동을 개별적으로 실행
    var currentTime: TimeInterval = 0
    
    for (index, duration) in pattern.enumerated() {
      let durationSeconds = TimeInterval(duration) / 1000.0
      
      if index % 2 == 1 {
        // 홀수 인덱스: 진동 실행
        let executeTime = currentTime
        
        DispatchQueue.main.asyncAfter(deadline: .now() + executeTime) {
          print("iOS - Executing vibration at \(executeTime)s for \(duration)ms")
          
          // 강력한 햅틱 피드백
          let impactGenerator = UIImpactFeedbackGenerator(style: .heavy)
          impactGenerator.prepare()
          impactGenerator.impactOccurred()
          
          // 시스템 진동 추가
          AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
          
          // duration에 따라 추가 진동
          let vibrationCount = max(1, duration / 100) // 100ms마다 한 번씩
          for i in 1..<vibrationCount {
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(i) * 0.1) {
              let generator = UIImpactFeedbackGenerator(style: .medium)
              generator.impactOccurred()
            }
          }
        }
      }
      
      currentTime += durationSeconds
    }
    
    print("iOS - Pattern will complete in \(currentTime)s")
  }

  // ✅ 이미 FlutterAppDelegate에 있는 메서드 override
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler([.alert, .sound])
  }
}
