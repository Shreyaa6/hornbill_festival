import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var secureField: UITextField?
  private weak var securedWindow: UIWindow?
  private weak var securedRootLayer: CALayer?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "SecurityService") {
      let channel = FlutterMethodChannel(
        name: "hornbill.festival/security",
        binaryMessenger: registrar.messenger()
      )
      channel.setMethodCallHandler { [weak self] call, result in
        switch call.method {
        case "enableSecure":
          self?.setSecureScreen(enabled: true)
          result(true)
        case "disableSecure":
          self?.setSecureScreen(enabled: false)
          result(true)
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }
  }

  private func activeWindow() -> UIWindow? {
    let windows = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
    return windows.first { $0.isKeyWindow }
      ?? windows.first { $0.rootViewController is FlutterViewController }
      ?? windows.first
  }

  private func setSecureScreen(enabled: Bool) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      if enabled {
        guard self.secureField == nil, let window = self.activeWindow() else { return }
        self.attachSecureOverlay(to: window)
      } else {
        self.detachSecureOverlay()
      }
    }
  }

  private func attachSecureOverlay(to window: UIWindow) {
    guard let rootView = window.rootViewController?.view else {
      NSLog("[SecurityService] ❌ No rootViewController.view")
      return
    }

    let field = UITextField()
    field.isSecureTextEntry = true
    field.isUserInteractionEnabled = false
    field.backgroundColor = .clear
    field.frame = window.bounds
    field.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    // Insert behind rootView inside the same window — rootView.layer is a sibling of field.layer,
    // so reparenting rootView.layer under field's secureLayer never creates a cycle and never
    // moves UIWindowLayer or creates a second UIWindow.
    window.insertSubview(field, at: 0)
    field.layoutIfNeeded()

    guard let secureLayer = findSecureLayer(in: field) else {
      field.removeFromSuperview()
      NSLog("[SecurityService] ❌ No secure layer found")
      return
    }

    secureLayer.addSublayer(rootView.layer)
    self.secureField = field
    self.securedWindow = window
    self.securedRootLayer = rootView.layer
    NSLog("[SecurityService] ✅ Secure overlay ENABLED — secureLayer type: %@",
          String(describing: type(of: secureLayer)))
  }

  private func findSecureLayer(in field: UITextField) -> CALayer? {
    for subview in field.subviews {
      let name = String(describing: type(of: subview))
      if name.contains("Canvas") || name.contains("Layout") || name.contains("Secure") {
        return subview.layer
      }
    }
    return field.layer.sublayers?.first
  }

  private func detachSecureOverlay() {
    if let window = securedWindow, let rootLayer = securedRootLayer {
      window.layer.addSublayer(rootLayer)
      NSLog("[SecurityService] ✅ Secure overlay DISABLED — rootView.layer restored")
    }
    secureField?.removeFromSuperview()
    secureField = nil
    securedWindow = nil
    securedRootLayer = nil
  }
}
