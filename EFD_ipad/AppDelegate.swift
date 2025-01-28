import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        // Créer les contrôleurs
        let mainViewController = MainViewController(nibName: "MainViewController", bundle: nil)
        let blankViewController = BlankViewController(nibName: nil, bundle: nil)

        // Connecter le delegate
        mainViewController.blankViewController = blankViewController

        // Navigation pour le Master et le Detail
        let masterNavigationController = UINavigationController(rootViewController: mainViewController)
        let detailNavigationController = UINavigationController(rootViewController: blankViewController)

        // Configurer le SplitViewController
        let splitViewController = UISplitViewController()
        splitViewController.viewControllers = [masterNavigationController, detailNavigationController]
        splitViewController.preferredDisplayMode = .oneBesideSecondary

        // Assigner au rootViewController
        window?.rootViewController = splitViewController
        window?.makeKeyAndVisible()

        return true
    }
}
