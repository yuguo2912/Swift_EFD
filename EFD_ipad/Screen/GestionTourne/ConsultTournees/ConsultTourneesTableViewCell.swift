//
//  ConsultTourneesTableViewCell.swift
//  EFD_ipad
//
//  Created by Hugo Arnaudeau on 24/12/2024.
//

import UIKit

class ConsultTourneesTableViewCell: UITableViewCell {
    @IBOutlet weak var nbColisLabel: UILabel!
    @IBOutlet weak var dateSpecLabel: UILabel!
    @IBOutlet weak var deliveredswitch: UISwitch!
    
    var onToggleDelivered: (()->Void)?
    
    @IBAction func deliveredSwitchToggle(_ sender: UISwitch) {
        onToggleDelivered?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func redrawtournee(tournee: Tournees, isEditable: Bool) {
        self.nbColisLabel.text = "\(tournee.nbColis)"
        self.dateSpecLabel.text = "\(tournee.dateSpec)"
        self.deliveredswitch.isOn = tournee.isDelivered
        self.deliveredswitch.isEnabled = isEditable
    }
    
}
