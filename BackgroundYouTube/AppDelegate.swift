import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private lazy var viewController: ViewController = {
        return ViewController()
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = self.viewController
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
    
    private func parse(url: URL) -> URL? {
        
        guard let scheme = url.scheme else { return nil }
        
        let withSchemeRemoved = url.absoluteString.replacingOccurrences(of: scheme, with: "")
        guard let unescaped = withSchemeRemoved.removingPercentEncoding else { return nil }
        
        return URL(string: unescaped)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let parsed = self.parse(url: url) else { return false }
        
        self.viewController.open(url: parsed)
        return true
    }
}

