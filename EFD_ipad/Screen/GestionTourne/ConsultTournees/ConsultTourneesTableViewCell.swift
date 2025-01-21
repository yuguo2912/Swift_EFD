//
//  ConsultTourneesTableViewCell.swift
//  EFD_ipad
//
//  Created by Hugo Arnaudeau on 24/12/2024.
//

import UIKit

class ConsultTourneesTableViewCell: UITableViewCell {
    @IBOutlet weak var nbColisLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var dateSpecLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func redrawtournee(tournee: Tournees) {
        self.nbColisLabel.text = "\(tournee.nbColis)"
        self.destinationLabel.text = "\(tournee.destination)"
        self.dateSpecLabel.text = "\(tournee.dateSpec)"
    }
    
}
