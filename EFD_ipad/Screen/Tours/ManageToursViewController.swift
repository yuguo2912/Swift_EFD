//
//  ManageToursViewController.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 08/02/2025.
//

import UIKit

class ManageToursViewController: UIViewController {
    
    @IBOutlet weak var createTourButton: UIButton!
    @IBOutlet weak var toursTableView: UITableView!
    
    let packageService: PackageService = PackageService.getInstance()
    
    var tours: [AllToursDTO]? {
        didSet {
            self.toursTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toursTableView.register(UINib(nibName: "ManageTourTableViewCell", bundle: nil), forCellReuseIdentifier: "TourTableViewCell")
        self.toursTableView.delegate = self
        self.toursTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        packageService.getAllTours { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tours):
                    self.tours = tours
                    print(tours)
                    self.toursTableView.reloadData()
                case .failure(let error):
                    let alert = UIAlertController(title: "Erreur", message: error.localizedDescription, preferredStyle: .alert)
                    let retryAction = UIAlertAction(title: "Réessayer", style: .default) { _ in
                        self.viewWillAppear(true)
                    }
                    let cancelAction = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
                    alert.addAction(retryAction)
                    alert.addAction(cancelAction)
                    
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    @IBAction func handleCreateTour(_ sender: Any) {
        let createTourVC = CreateTourViewController()
        self.navigationController?.pushViewController(createTourVC, animated: true)
    }
    
    
}

extension ManageToursViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ManageToursViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tours?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TourTableViewCell", for: indexPath) as! ManageTourTableViewCell
        cell.redraw(tour: self.tours![indexPath.row])
        return cell
    }
}
