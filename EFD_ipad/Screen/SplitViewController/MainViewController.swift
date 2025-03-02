//
//  MainViewController.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 08/02/2025.
//

import UIKit

class MainViewController: UIViewController, ManageTourCellProtocol {
    @IBOutlet weak var todeayDeliveriesTableView: UITableView!
    @IBOutlet weak var noDeliveriesLabel: UILabel!
    
    let packageService = PackageService.getInstance()
    
    var tours : [AllToursDTO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noDeliveriesLabel.isHidden = true
        self.todeayDeliveriesTableView.delegate = self
        self.todeayDeliveriesTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadTodaystours()
    }
    
    func getDateFromString(dateString: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate]
        return dateFormatter.date(from: dateString)
    }
    
    func loadTodaystours() {
        packageService.getAllTours() { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tours):
                    var todaysTour : [AllToursDTO] = []
                    for tour in tours {
                        if self.getDateFromString(dateString: tour.deliveryDate!) == Date() {
                            todaysTour.append(tour)
                        }
                    }
                    if todaysTour.isEmpty {
                        self.noDeliveriesLabel.isHidden = false
                        self.todeayDeliveriesTableView.isHidden = true
                    }
                    self.tours = todaysTour
                case .failure(let error):
                    let alertController = UIAlertController(title: "Erreur", message: error.localizedDescription, preferredStyle: .alert)
                    let retryAction = UIAlertAction(title: "Ressayer", style: .default) { (_) in
                        self.loadTodaystours()
                    }
                    let cancelAction = UIAlertAction(title: "Annuler", style: .cancel)
                    alertController.addAction(cancelAction)
                    alertController.addAction(retryAction)
                    self.present(alertController, animated: true)
                }
            }
        }
    }

    func didDeleteTour(_ tourId: Int) {
        var tours = self.tours
        if let index = tours.firstIndex(where: { $0.tourId == tourId }) {
            tours.remove(at: index)
            self.tours = tours
        }
    }
}

extension MainViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension MainViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tours.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TourTableViewCell", for: indexPath) as! ManageTourTableViewCell
        cell.redraw(tour: self.tours[indexPath.row])
        cell.delegate = self
        return cell
    }
}
