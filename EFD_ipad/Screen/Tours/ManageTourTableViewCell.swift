//
//  ManageTourTableViewCell.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 08/02/2025.
//

import UIKit

class ManageTourTableViewCell: UITableViewCell {
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var modifyButton: UIButton!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var firstnameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    
    let packageService = PackageService.getInstance()
    
    var tourId: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func redraw(tour: AllToursDTO) {
        self.firstnameLabel.text = tour.firstName
        self.lastnameLabel.text = tour.lastName
        self.numberLabel.text = "\(tour.packages ?? 0)"
        if let dateString = tour.deliveryDate!.split(separator: "T").first {
            self.dateLabel.text = String(dateString)
        } else {
            self.dateLabel.text = tour.deliveryDate
        }
        switch tour.status {
        case "Terminer":
            self.backgroundColor = .green
        case "En cours de livraison":
            self.backgroundColor = .yellow
        default:
            self.backgroundColor = .white
        }
        self.tourId = tour.tourId!
        
    }
    
    @IBAction func handleDelete(_ sender: Any) {
        let alert = UIAlertController(title: "Attention", message: "Voulez-vous vraiment supprimer cette tournée ?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Valider", style: .destructive) { _ in
            
            self.packageService.deleteTour(tourId: self.tourId) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        print("Tour supprimé avec succès")
                        
                        if let parentVC = self.parentViewController as? ManageToursViewController {
                            parentVC.viewWillAppear(true)
                        }
                        
                    case .failure(let error):
                        print("Erreur de suppression :", error.localizedDescription)
                    }
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        if let parentVC = self.parentViewController {
            parentVC.present(alert, animated: true)
        }
    }

}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while let nextResponder = parentResponder?.next {
            parentResponder = nextResponder
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
