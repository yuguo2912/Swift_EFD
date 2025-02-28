//
//  PackageTableViewCell.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 25/02/2025.
//

import UIKit


class PackageTableViewCell: UITableViewCell {

    @IBOutlet weak var packageIdLabel: UILabel!
    @IBOutlet weak var deliveryLocationButton: UIButton!
    @IBOutlet weak var deliveryDatePicker: UIDatePicker!
    @IBOutlet weak var StatusButton: UIButton!
    @IBOutlet weak var proofOfDeliveryButton: UIButton!
    @IBOutlet weak var deletePackageButton: UIButton!
    
    let packageService = PackageService.getInstance()
    weak var delegate: PackageCellProtocol?

    var package: PackageDTO?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func redraw(package: PackageDTO) {
        self.packageIdLabel.text = package.packageId?.description
        self.package = package
        setUpCalendar()
        guard let status = package.isDelivered else {
            return
        }
        self.setStatusButton(status: status)
        proofOfDeliveryButton.setTitle("Aucune preuve de livraison", for: .disabled)
        proofOfDeliveryButton.setTitle("Preuve de livraison", for: .normal)
        guard package.deliveryProof != nil else {
            proofOfDeliveryButton.isEnabled = false
            return
        }
    }
    
    func setUpCalendar() {
        print("SETUP CALENDAR")
        self.deliveryDatePicker.datePickerMode = .date
        
        if let deliveryDate = self.package?.deliveryDate, let date = getDateFromString(dateString: deliveryDate) {
            self.deliveryDatePicker.date = date
        }
        
        if let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) {
            deliveryDatePicker.minimumDate = tomorrow
        }
    }

    
    func setStatusButton(status: Bool) {
        if status {
            self.StatusButton.tintColor = .green
            self.StatusButton.setTitle("Livré", for: .normal)
        }else {
            self.StatusButton.tintColor = .gray
            self.StatusButton.setTitle("A Livrer", for: .normal)
        }
    }
    
    func getDateFromString(dateString: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate]
        return dateFormatter.date(from: dateString)
    }
    
    @IBAction func handleDeletePackage(_ sender: Any) {
        
        let alert = UIAlertController(title: "Supprimer le colis", message: "Voulez-vous vraiment supprimer ce colis ?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Supprimer", style: .destructive) { _ in
            self.deletePackage()
        }
        let cancelAction = UIAlertAction(title: "Annuler", style: .cancel)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        self.window?.rootViewController?.present(alert, animated: true)
        
    }
    
    func deletePackage() {
        guard let packageId = self.package?.packageId else {
            return
        }
        packageService.deletePackage(packageId: packageId) { result in
            DispatchQueue.main.async{
                switch result {
                case .success:
                    self.delegate?.didDeletePackage(self.package!)
                case .failure(let error):
                    let alert = UIAlertController(title: "Erreur", message: error.localizedDescription, preferredStyle: .alert)
                    let retryAction = UIAlertAction(title: "Ressayer", style: .default) { _ in
                        self.deletePackage()
                    }
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel)
                    alert.addAction(retryAction)
                    alert.addAction(cancelAction)
                    self.window?.rootViewController?.present(alert, animated: true)
                }
            }
        }
    }
    
    @IBAction func handleDeliveryProof(_ sender: Any) {
    }
    
    @IBAction func handleUpdateStatus(_ sender: Any) {
        let alert = UIAlertController(title: "Statut du colis", message: "Voulez-vous vraiment mettre à jour le statut du colis?", preferredStyle: .alert)
        let deliveredAction = UIAlertAction(title: "Oui", style: .default) { _ in
            self.updateStatus()
        }
        let cancelAction = UIAlertAction(title: "Annuler", style: .cancel)
        alert.addAction(deliveredAction)
        alert.addAction(cancelAction)
    
        self.window?.rootViewController?.present(alert, animated: true)
    }
    
    func updateStatus() {
        guard let packageId = self.package?.packageId else { return }
        guard let status = self.package?.isDelivered else { return }
        
        let newStatus = !status

        let deliveryStatus = UpdateDeliveryStatusDTO(packageId: packageId, status: newStatus)

        packageService.updateDeliveryStatus(deliveryStatus: deliveryStatus) { result in
            DispatchQueue.main.async {
                switch result {
                    case .success:
                        self.package?.isDelivered = newStatus
                        self.setStatusButton(status: newStatus)
                        self.redraw(package: self.package! )
                        print("1")
                    case .failure(let error):
                        let alert = UIAlertController(title: "Erreur", message: error.localizedDescription, preferredStyle: .alert)
                        let retryAction = UIAlertAction(title: "Ressayer", style: .default) { _ in
                            self.updateStatus()
                        }
                        let cancelAction = UIAlertAction(title: "OK", style: .cancel)
                        alert.addAction(retryAction)
                        alert.addAction(cancelAction)
                        self.window?.rootViewController?.present(alert, animated: true)
                }
            }
        }
    }

    @IBAction func handleUpdateDeliveryDate(_ sender: Any) {
        let formatter = ISO8601DateFormatter()
        let deliveryDate = formatter.string(from: self.deliveryDatePicker.date)
        self.updateDeliveryDate(deliveryDate: deliveryDate)
    }
    
    func updateDeliveryDate(deliveryDate: String) {
        
        self.package?.deliveryDate = deliveryDate
        let packageToUpdate = self.package
        
        packageService.editPackage(package: packageToUpdate!) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let package):
                    self.package = package
                    self.delegate?.didUpdatePackage(package)
                    print("success")
                case .failure(let error):
                    let alert = UIAlertController(title: "Erreur", message: error.localizedDescription, preferredStyle: .alert)
                    let retryAction = UIAlertAction(title: "Ressayer", style: .default) { _ in
                        self.updateDeliveryDate(deliveryDate: deliveryDate)
                    }
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel)
                    alert.addAction(retryAction)
                    alert.addAction(cancelAction)
                    self.window?.rootViewController?.present(alert, animated: true)
                }
            }
        }
        
        
    }
    
    @IBAction func handleUpdateDeliveryLocation(_ sender: Any) {
        let editDeliveryLocationVC = EditPackageViewController()
        editDeliveryLocationVC.package = self.package!
        self.parentViewController?.navigationController?.pushViewController(editDeliveryLocationVC, animated: true)
    }
}

