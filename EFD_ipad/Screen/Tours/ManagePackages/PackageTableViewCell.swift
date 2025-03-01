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

    var package: PackageDTO = PackageDTO() {
        didSet {
            self.setUpCalendar()
        }
    }
    
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
        self.deliveryDatePicker.datePickerMode = .date
        
        guard let isDelivered = self.package.isDelivered else {
            return
        }
        
        guard let deliveryDateStr = self.package.deliveryDate,
              let deliveryDate = getDateFromString(dateString: deliveryDateStr) else {
            return
        }
        
        let today = Calendar.current.startOfDay(for: Date())

        self.deliveryDatePicker.date = deliveryDate

        if isDelivered {
            self.deliveryDatePicker.backgroundColor = .green
            self.deliveryDatePicker.isEnabled = false
        } else {
            self.deliveryDatePicker.isEnabled = true
            if deliveryDate < today {
                self.deliveryDatePicker.backgroundColor = .red
            } else {
                self.deliveryDatePicker.backgroundColor = .clear
            }
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
        guard let packageId = self.package.packageId else {
            return
        }
        packageService.deletePackage(packageId: packageId) { result in
            DispatchQueue.main.async{
                switch result {
                case .success:
                    self.delegate?.didDeletePackage(self.package)
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
    
    @IBAction func handleDeliveryProof(_ sender: UIButton) {
        self.displayDeliveryProof(sender)
    }
    
    func displayDeliveryProof(_ sender: UIView) {
        guard let deliveryProof = self.package.deliveryProof else { return }
        print(deliveryProof)
        packageService.getDeliveryProof(deliveryProofPath: deliveryProof) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.showDeliveryProof(data, sender)
                case .failure:
                    self.showGetDeliveryProofError(sender)
                }
            }
        }
        
    }
    
    func showDeliveryProof(_ data: Data, _ sender: UIView) {
        guard let image = UIImage(data: data) else { return }
        
        let popoverVC = UIViewController()
        popoverVC.modalPresentationStyle = .popover
        popoverVC.preferredContentSize = CGSize(width: 500, height: 500) //

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 10, width: 480, height: 480)
        popoverVC.view.addSubview(imageView)

        if let popoverController = popoverVC.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
            popoverController.permittedArrowDirections = .any
        }

        self.parentViewController?.present(popoverVC, animated: true)
    }

    
    func showGetDeliveryProofError(_ sender: UIView) {
        let alert = UIAlertController(title: "Erreur", message: "Impossible de charger l'image", preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Réessayer", style: .default) { _ in
            self.displayDeliveryProof(sender)
        }
        let cancelAction = UIAlertAction(title: "Annuler", style: .cancel)
        alert.addAction(retryAction)
        alert.addAction(cancelAction)
        self.window?.rootViewController?.present(alert, animated: true)
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
        guard let packageId = self.package.packageId else { return }
        guard let status = self.package.isDelivered else { return }
        
        let newStatus = !status

        let deliveryStatus = UpdateDeliveryStatusDTO(packageId: packageId, status: newStatus)

        packageService.updateDeliveryStatus(deliveryStatus: deliveryStatus) { result in
            DispatchQueue.main.async {
                switch result {
                    case .success:
                        self.package.isDelivered = newStatus
                        self.setStatusButton(status: newStatus)
                        self.redraw(package: self.package)
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
        if self.deliveryDatePicker.date < Date() {
            self.delegate?.errorOnDeliveryDate()
            return
        }

        let formatter = ISO8601DateFormatter()
        let deliveryDate = formatter.string(from: self.deliveryDatePicker.date)
        self.updateDeliveryDate(deliveryDate: deliveryDate)
    }
    
    func updateDeliveryDate(deliveryDate: String) {
        
        self.package.deliveryDate = deliveryDate
        let packageToUpdate = self.package
        
        packageService.editPackage(package: packageToUpdate) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let package):
                    self.package = package
                    self.delegate?.didUpdatePackage(package)
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
        editDeliveryLocationVC.package = self.package
        self.parentViewController?.navigationController?.pushViewController(editDeliveryLocationVC, animated: true)
    }
}

