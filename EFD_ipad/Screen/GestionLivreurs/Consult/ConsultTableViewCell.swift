//
//  ConsultTableViewCell.swift
//  EFD_ipad
//
//  Created by Hugo Arnaudeau on 24/12/2024.
//
import UIKit

class ConsultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nomLabel: UILabel!
    @IBOutlet weak var prenomLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    //var onEditButtonTapped: (() -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func redraw(livreur: Livreur) {
        self.nomLabel.text = livreur.nom
        self.prenomLabel.text = livreur.prenom
        self.ageLabel.text = "\(livreur.age)"
    }
    
    //@IBAction func editButtonTapped(_ sender: Any) {
      //  onEditButtonTapped?()
    //}
    
}
