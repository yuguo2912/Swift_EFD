//
//  Tours2ViewController.swift
//  EFD_ipad
//
//  Created by Hugo Arnaudeau on 12/02/2025.
//

import UIKit

class Tours2ViewController: UIViewController {
    
    @IBOutlet weak var listeTableView: UITableView!
    
    let tourservice = TourService.getInstance()
        var userID: Int?  // 🔹 Récupération dynamique de l'ID utilisateur
    //let currentUserId = TokenManager.getInstance().getTokenClaims()?.id

        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.listeTableView.register(UINib(nibName: "Tours2TableViewCell", bundle: nil), forCellReuseIdentifier: "Tours2TableViewCell")
            self.listeTableView.delegate = self
            self.listeTableView.dataSource = self
            
            // 🔹 Récupération de l'ID utilisateur depuis le token
            self.userID = TokenManager.getInstance().getTokenClaims()?.id

            if let userID = self.userID {
                fetchTours(for: userID)
            } else {
                print("❌ Impossible de récupérer l'ID utilisateur depuis le token")
            }
        }

        var filtertours: [TourByIDDTO]? {
            didSet {
                self.listeTableView.reloadData()
            }
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            if let userID = self.userID {
                fetchTours(for: userID)
            }
        }

        func fetchTours(for userId: Int) {
            tourservice.getToursForCurrentUser()//currentUserId!
            { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let tours):
                        self.filtertours = tours
                        print("✅ Tours récupérés :", tours)
                    case .failure(let error):
                        print("❌ Erreur lors de la récupération des tours :", error.localizedDescription)
                        self.showErrorAlert(message: error.localizedDescription)
                    }
                }
            }
        }

        func showErrorAlert(message: String) {
            let alert = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
            let retryAction = UIAlertAction(title: "Réessayer", style: .default) { _ in
                if let userID = self.userID {
                    self.fetchTours(for: userID)
                }
            }
            let cancelAction = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
            alert.addAction(retryAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true)
        }
    }

    // MARK: - UITableViewDelegate
    extension Tours2ViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 50
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let map = VisualViewController()
            self.navigationController?.pushViewController(map, animated: true)
        }
    }

    // MARK: - UITableViewDataSource
    extension Tours2ViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.filtertours?.count ?? 0
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Tours2TableViewCell", for: indexPath) as! Tours2TableViewCell
            if let tour = self.filtertours?[indexPath.row] {
                cell.redraw(filtertour: tour)
                Context.shared.tourId = tour.tourId
            }
            return cell
        }
    }
