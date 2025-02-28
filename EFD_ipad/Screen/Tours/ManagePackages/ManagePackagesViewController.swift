 //
//  ManagePackagesViewController.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 08/02/2025.
//

import UIKit

class ManagePackagesViewController: UIViewController, PackageCellProtocol {
    
    @IBOutlet weak var deliveryManPicker: UIButton!
    @IBOutlet weak var deleteTourButton: UIButton!
    @IBOutlet weak var packageTableView: UITableView!
    var tourId: Int = 0
    var deliveryManId: Int = 0
    var packages: [PackageDTO] = [] {
        didSet {
            self.packageTableView.reloadData()
        }
    }
    
    let packageService = PackageService.getInstance()
    let adminService = AdminService.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        packageTableView.register(UINib(nibName: "PackageTableViewCell", bundle: nil), forCellReuseIdentifier: "PackageTableViewCell")
        packageTableView.dataSource = self
        packageTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupdeliveryMansMenu()
        self.loadDeliveryMans()
        packageService.getPackagesByTourId(tourId: self.tourId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let packages):
                    self.packages = packages
                case .failure(let error):
                    print(error)
                    let alert = UIAlertController(title: "Erreur", message: "Erreur lors de la récupération des colis", preferredStyle: .alert)
                    let retryAction = UIAlertAction(title: "Réessayer", style: .destructive) { _ in
                        self.viewWillAppear(false)
                    }
                    let cancelAction = UIAlertAction(title: "Annuler", style: .cancel)
                    alert.addAction(retryAction)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    func setupdeliveryMansMenu() {
        let defaultItem = UIAction(title: "Chargement...", attributes: .disabled, handler: { _ in })
        deliveryManPicker.menu = UIMenu(title: "Sélectionner un livreur", options: .displayInline, children: [defaultItem])
        deliveryManPicker.showsMenuAsPrimaryAction = true
        deliveryManPicker.changesSelectionAsPrimaryAction = true
    }
    
    func loadDeliveryMans() {
        adminService.getDeliveryMans() { result in
            switch result {
            case .success(let deliveryMans):
                DispatchQueue.main.async {
                    self.updateDeliveryManMenu(deliveryMans)
                    
                }
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
    
    func updateDeliveryManMenu(_ deliveryMans: [User]) {
        var menuItems = deliveryMans.map { deliveryMan in
            UIAction(
                title: "\(deliveryMan.name) \(deliveryMan.lastname)",
                state: deliveryMan.id == self.deliveryManId ? .on : .off,
                handler: { _ in
                    self.deliveryManPicker.setTitle("\(deliveryMan.name) \(deliveryMan.lastname)", for: .normal)
                    self.deliveryManId = deliveryMan.id
                    self.updateDeliveryMan()
                }
            )
        }

        if menuItems.isEmpty {
            menuItems.append(UIAction(title: "Aucun livreur disponible", handler: { _ in
                self.deliveryManPicker.setTitle("Aucun livreur", for: .normal)
            }))
        }

        deliveryManPicker.menu = UIMenu(title: "Sélectionner un livreur", options: .displayInline, children: menuItems)

        if let selectedDeliveryMan = deliveryMans.first(where: { $0.id == self.deliveryManId }) {
            self.deliveryManPicker.setTitle("\(selectedDeliveryMan.name) \(selectedDeliveryMan.lastname)", for: .normal)
        }
    }

    
    func didDeletePackage(_ package: PackageDTO) {
        guard let index = packages.firstIndex(where: { $0.packageId == package.packageId }) else {
            return
        }
        
        self.packages.remove(at: index)
    }
    
    func didUpdatePackage(_ package: PackageDTO) {
        guard let index = packages.firstIndex(where: { $0.packageId == package.packageId}) else {
            return
        }
        
        self.packages[index] = package
    }
    
    func updateDeliveryMan() {
        let updateAssignedTo: UpdateAssignedToDTO = .init(tourId: self.tourId, deliveryManId: self.deliveryManId)
        packageService.updateDeliveryManAssigned(updateAssignedToDTO: updateAssignedTo) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    break
                case .failure(let error):
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
                        self.updateDeliveryMan()
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                    alert.addAction(retryAction)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true)
                }
            }
        }
    }
    @IBAction func handleDeletetour(_ sender: Any) {
        self.deleteTour(tourId: self.tourId)
    }
    
    func deleteTour(tourId: Int) {
        packageService.deleteTour(tourId: self.tourId) { result in
            DispatchQueue.main.async {
                switch result{
                case .success:
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
                        self.deleteTour(tourId:self.tourId)
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                    alert.addAction(retryAction)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true)
                }
            }
        }
    }
}

extension ManagePackagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.packages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackageTableViewCell", for: indexPath) as! PackageTableViewCell
        cell.redraw(package: packages[indexPath.row])
        cell.delegate = self
        return cell
    }
    
}

extension ManagePackagesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
