import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UINavigationController(rootViewController: Tours2ViewController())
        window.makeKeyAndVisible()
        self.window = window
        
        
        return true
    }
    
    
    
    
    
    
    /*var window: UIWindow?

    let splitViewController = UISplitViewController(style: .doubleColumn)
    
    let vcList: [UIViewController] = [ProfileViewController(), ManageDeliveryMansViewController(),ManageToursViewController(),MapViewController()]
    let vcNameList: [String] = ["Profile", "Gestion des livreurs", "Gestion des tournées","Suivre un livreur"]
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        if isLoggedIn() {
            showMainScreen(window: window)
        }else {
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
        window.rootViewController = UINavigationController(rootViewController: LoginViewController())
    }
    
    func showMainScreen(window: UIWindow) {
        
        let menuController = MenuController(style: .plain)
        menuController.title = "Menu"
        menuController.delegate = self
        let mainVC = MainViewController()
        mainVC.title = "Acceuil"
        splitViewController.viewControllers = [
            UINavigationController(rootViewController: menuController),
            UINavigationController(rootViewController: mainVC)
            ]
        
        window.rootViewController = splitViewController
    }
    
}

extension AppDelegate: MenuProtocol {
    func didTapMenu(index: Int) {
        (splitViewController.viewControllers.last as? UINavigationController)?.popToRootViewController(animated: false)
        let vc = vcList[index]
        vc.title = vcNameList[index]
        (splitViewController.viewControllers.last as? UINavigationController)?.pushViewController(vc, animated: false)
    }
    
    func didTapLogout() {
        TokenManager.getInstance().deleteToken()
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        (splitViewController.viewControllers.last as? UINavigationController)?.popToRootViewController(animated: false)
        (UIApplication.shared.delegate as? AppDelegate)?.showLoginScreen(window: (UIApplication.shared.delegate as! AppDelegate).window!)
    }*/
}
