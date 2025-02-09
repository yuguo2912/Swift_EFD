//
//  ManageDeliveryMansViewController.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 08/02/2025.
//

import UIKit

class ManageDeliveryMansViewController: UIViewController {

    @IBOutlet weak var deliveryManTableView: UITableView!
    
    let adminService = AdminService.getInstance()
    
    var deliveryMans: [User]? {
        didSet {
            self.deliveryManTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.deliveryManTableView.register(UINib(nibName: "ManageDeliveryManTableViewCell", bundle: nil), forCellReuseIdentifier: "DeliveryManCell")
        self.deliveryManTableView.delegate = self
        self.deliveryManTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adminService.getDeliveryMans() {result in
            DispatchQueue.main.async {
                switch result {
                case .success(let deliveryMans):
                    self.deliveryMans = deliveryMans
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
}


extension ManageDeliveryMansViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.deliveryMans?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryManCell", for: indexPath) as! ManageDeliveryManTableViewCell
        cell.redraw(user: self.deliveryMans![indexPath.row])
        return cell
    }
}

extension ManageDeliveryMansViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
