import UIKit

protocol BlankViewControllerDelegate: AnyObject {
    func didSelectAction(_ action: BlankViewController.Action)
}

class BlankViewController: UIViewController {
    // Enum pour les actions à gérer
    enum Action {
        case goToSuivi
        case goToConsultLivreur
        case createLivreur
        case goToConsultTournees
        case createTournees
    }

    // Un container pour la navigation
    private var embeddedNavigationController: UINavigationController! // Renommé pour éviter le conflit

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // Créer un UINavigationController
        let rootViewController = UIViewController()
        rootViewController.view.backgroundColor = .white // Placeholder
        embeddedNavigationController = UINavigationController(rootViewController: rootViewController)

        // Ajouter le UINavigationController comme enfant
        addChild(embeddedNavigationController)
        view.addSubview(embeddedNavigationController.view)
        embeddedNavigationController.view.frame = view.bounds
        embeddedNavigationController.didMove(toParent: self)
    }

    // Gérer les actions pour naviguer vers les vues
    func handleAction(_ action: Action) {
        switch action {
        case .goToSuivi:
            let suiviVC = SuiviViewController()
            embeddedNavigationController.pushViewController(suiviVC, animated: true)
        case .goToConsultLivreur:
            let consultVC = ConsultViewController()
            embeddedNavigationController.pushViewController(consultVC, animated: true)
        case .createLivreur:
            let livreurVC = LivreursViewController()
            embeddedNavigationController.pushViewController(livreurVC, animated: true)
        case .goToConsultTournees:
            let consultTourneeVC = ConsultTourneesViewController()
            embeddedNavigationController.pushViewController(consultTourneeVC, animated: true)
        case .createTournees:
            let tourneeVC = Tournee2ViewController()
            embeddedNavigationController.pushViewController(tourneeVC, animated: true)
        }
    }
}
