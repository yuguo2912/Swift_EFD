//
//  ManageTourTableViewCell.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 08/02/2025.
//

import UIKit

class Tours2TableViewCell: UITableViewCell {
    
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func redraw(filtertour: AllToursDTO) {
        self.firstNameLabel.text = filtertour.firstName
        self.lastNameLabel.text = filtertour.lastName
        self.dateLabel.text = "\(filtertour.packages ?? 0)"
        if let dateString = filtertour.deliveryDate!.split(separator: "T").first {
            self.dateLabel.text = String(dateString)
        } else {
            self.dateLabel.text = filtertour.deliveryDate
        }
        switch filtertour.status {
            case "Terminer":
                self.backgroundColor = .green
            case "En cours de livraison":
                self.backgroundColor = .yellow
            default:
                self.backgroundColor = .white
        }
        
        
    }
    
}
