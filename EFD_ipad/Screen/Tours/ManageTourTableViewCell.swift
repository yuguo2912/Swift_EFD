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
        
        
    }
    
}
