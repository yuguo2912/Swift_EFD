import UIKit

class ConsultViewController: UIViewController {
    
    @IBOutlet weak var profilTableView: UITableView!
    
    
    var livreurs: [Livreur] = [] // Stockage des livreurs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profilTableView.register(UINib(nibName: "ConsultTableViewCell", bundle: nil), forCellReuseIdentifier: "consult")
        self.profilTableView.delegate = self // Ajout du delegate pour gérer les clics
        self.profilTableView.dataSource = self
        
        // Charger les livreurs depuis le Mock
        MockConnexionService.getInstance().getAllLivreur{ [weak self] data in
            guard let self = self else { return }
            self.livreurs = data
            self.profilTableView.reloadData() // Recharger les données dans la table
        }
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewLivreurNotification(_:)), name: .newLivreurAdded, object: nil)
        /*self.livreurs.append(Livreur(nom: "Hugo", prenom: "Arnaudeau", age: 21))
         self.livreurs.append(Livreur(nom: "Matthieu", prenom: "D", age: 47))*/
        
    }
    @objc func handleNewLivreurNotification(_ notification: Notification) {
        if let newLivreur = notification.object as? Livreur {
            // Ajoute le nouveau livreur à la liste et recharge la table
            self.livreurs.append(newLivreur)
            self.profilTableView.reloadData()
        }
    }
    
    deinit {
        // Nettoyer les observateurs
        NotificationCenter.default.removeObserver(self, name: .newLivreurAdded, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //print(self.livreurs[0])
        profilTableView.reloadData()
    }
    
}

// MARK: - UITableViewDataSource
extension ConsultViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return livreurs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "consult", for: indexPath) as! ConsultTableViewCell
        
        let livreur = livreurs[indexPath.row]
        cell.redraw(livreur: livreur)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ConsultViewController: UITableViewDelegate {
    
    // Gérer la sélection d'une cellule
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // let livreur =
        let detail = ConsultDetailViewController()
        detail.livreur = self.livreurs[indexPath.row]
        // Configurez la closure pour supprimer le livreur
        detail.onLivreurDeleted = { [weak self] deletedLivreur in
            guard let self = self else { return }
            
            // Supprimer le livreur de la liste principale
            self.livreurs.removeAll { $0 === deletedLivreur }
            
            // Recharger la table pour refléter les changements
            self.profilTableView.reloadData()
        }
        
        // Pousser la vue dans le NavigationController
        self.navigationController?.pushViewController(detail, animated: true)
        
        
    }
}
