import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
         
        if isLoggedIn() {
            showMainScreen(window: window)
        } else {
            showLoginScreen(window: window)
        }
        
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }

    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    func showLoginScreen(window: UIWindow) {
        let loginVC = HomeViewController()
        let navigationController = UINavigationController(rootViewController: loginVC)
        window.rootViewController = navigationController
    }
    
    func showMainScreen(window: UIWindow) {
        let homeVC = Tours2ViewController()
        let navigationController = UINavigationController(rootViewController: homeVC)
        window.rootViewController = navigationController
    }
    
    func logout() {
        TokenManager.getInstance().deleteToken()
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.set(false, forKey: "isLoggedIn")

        if let window = self.window {
            showLoginScreen(window: window)
        }
    }
}
