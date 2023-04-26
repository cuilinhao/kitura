import Foundation
import HeliumLogger
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let root = ServerViewController()
        let navigation = UINavigationController(rootViewController: root)

        let window = UIWindow()
        window.rootViewController = navigation
        window.makeKeyAndVisible()
        self.window = window

        HeliumLogger.use(.debug)
        return true
    }
}
