//
//  MenuController.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 08/02/2025.
//

import UIKit

class MenuController: UITableViewController {
    let vcList: [UIViewController] = [ProfileViewController(), ManageDeliveryMansViewController(),ManageToursViewController(),MapViewController()]
    let vcNameList: [String] = ["Profile", "Gestion des livreurs", "Gestion des tournées","Suivre un livreur"]
    
    weak var delegate: MenuProtocol?
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? vcList.count : 1  // Section 0 = menu, Section 1 = bouton déconnexion
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = vcNameList[indexPath.row]
        } else {
            cell.textLabel?.text = "Se déconnecter"
            cell.textLabel?.textColor = .red
            cell.textLabel?.textAlignment = .center
        }
        
        return cell
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            delegate?.didTapMenu(index: indexPath.row)
        } else {
            delegate?.didTapLogout() // Appelle la méthode de déconnexion
        }
    }
    
}
