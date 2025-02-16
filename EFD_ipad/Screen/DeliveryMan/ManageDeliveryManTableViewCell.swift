//
//  ManageDeliveryManTableViewCell.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 08/02/2025.
//

import UIKit

class ManageDeliveryManTableViewCell: UITableViewCell {

    @IBOutlet weak var userProfileBT: UIButton!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var firstnameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    
    var user: User?
    
    var onProfileButtonTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    func redraw(user: User) {
        self.firstnameLabel.text = user.name
        self.lastnameLabel.text = user.lastname
        self.mailLabel.text = user.email
        self.user = user
    }
    @IBAction func handleCheckoutDeliveryManProfile(_ sender: Any) {
        onProfileButtonTapped?()
    }
}
