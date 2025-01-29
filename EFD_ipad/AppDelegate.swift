import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AuthenthicatedURLProtocol.tokenProvider = { "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6IkFETUlOIn0.UlETyvcyD3R6CsRqRrrA0GqV68LXYhNxNxPMhWvE3Es" }
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Créer l'écran de connexion
        let homeViewController = HomeViewController(nibName: "HomeViewController", bundle: nil)
        let navigationController = UINavigationController(rootViewController: homeViewController)
        
        // Configurer le callback pour basculer vers l'application principale
        homeViewController.onLoginSuccess = { [weak self] in
            self?.showMainSplitView()
        }
        
        // Afficher l'écran de connexion
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        

        return true
    }

    // Méthode pour afficher le SplitViewController après connexion
    private func showMainSplitView() {
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

        // Basculer vers le SplitViewController
        DispatchQueue.main.async {
            self.window?.rootViewController = splitViewController
        }
    }
}
