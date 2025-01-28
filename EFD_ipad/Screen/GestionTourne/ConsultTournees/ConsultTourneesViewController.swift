//
//  ConsultTourneesViewController.swift
//  EFD_ipad
//
//  Created by Hugo Arnaudeau on 24/12/2024.
//

import UIKit

class ConsultTourneesViewController: UIViewController {
    
    @IBOutlet weak var tourneetable: UITableView!
    
    var tournees: [Tournees] = [] // Stockage des tournées
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tourneetable.register(UINib(nibName: "ConsultTourneesTableViewCell", bundle: nil), forCellReuseIdentifier: "consult")
        self.tourneetable.delegate = self
        self.tourneetable.dataSource = self
        
        // Charger les tournées depuis le Mock
        MockConnexionService.getInstance().getAllTournees { [weak self] data in
            guard let self = self else { return }
            self.tournees = data
            self.tourneetable.reloadData() // Recharger les données dans la table
        }
        
        // Observer les nouvelles tournées ajoutées
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewTourneeNotification(_:)), name: .newTourneeAdded, object: nil)
    }
    
    @objc func handleNewTourneeNotification(_ notification: Notification) {
        if let newTournee = notification.object as? Tournees {
            // Ajouter la nouvelle tournée à la liste et recharger la table
            self.tournees.append(newTournee)
            self.tourneetable.reloadData()
        }
    }
    
    deinit {
        // Nettoyer les observateurs
        NotificationCenter.default.removeObserver(self, name: .newTourneeAdded, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tourneetable.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension ConsultTourneesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tournees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "consult", for: indexPath) as! ConsultTourneesTableViewCell
        
        let tournee = tournees[indexPath.row]
        cell.redrawtournee(tournee: tournee, isEditable: false)
        
        cell.onToggleDelivered = {[weak self] in guard let self = self else {return}
            self.tournees[indexPath.row].isDelivered.toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
            
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ConsultTourneesViewController: UITableViewDelegate {
    
    // Gérer la sélection d'une cellule
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = ConsultTourneeDetailViewController()
        detail.tournee = self.tournees[indexPath.row]
        
        // Configurez la closure pour supprimer une tournée
        detail.onTourneeDate = { [weak self] deletedTournee in
            guard let self = self else { return }
            
            // Supprimer la tournée de la liste principale
            self.tournees.removeAll { $0 === deletedTournee }
            
            // Recharger la table pour refléter les changements
            self.tourneetable.reloadData()
        }
        
        // Pousser la vue dans le NavigationController
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
