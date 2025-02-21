//
//  CreateDeliveryManViewController.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 08/02/2025.
//

import UIKit

class CreateDeliveryManViewController: UIViewController {

    @IBOutlet weak var ceateBT: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var mailTF: UITextField!
    @IBOutlet weak var firstnameTF: UITextField!
    @IBOutlet weak var lastnameTF: UITextField!
    
    let adminService = AdminService.getInstance()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
    }

    
    @IBAction func createDeliveryManBT(_ sender: Any) {
        errorLabel.isHidden = true
        errorLabel.textColor = .red
        let firstname = firstnameTF.text ?? ""
        let lastname = lastnameTF.text ?? ""
        let mail = mailTF.text ?? ""
        
        if(firstname.isEmpty || lastname.isEmpty || mail.isEmpty){
            errorLabel.text = "Les champs ne peuvent pas être vides"
            errorLabel.isHidden = false
            return
        }
        
        if firstname.count < 2 || lastname.count < 2 {
            errorLabel.text = "Le nom et le prénom doivent contenir au moins 2 caractères"
            errorLabel.isHidden = false
            return
        }
        
        if !isValidEmail(mail) {
            errorLabel.text = "L'adresse email est invalide"
            errorLabel.isHidden = false
            return
        }
        
        let deliveryMan = CreateDeliveryManDTO(name: firstname, lastname: lastname, mail: mail)
        
        adminService.createDeliveryMan(deliveryMan: deliveryMan) { result in
            
            DispatchQueue.main.async {
                switch result {
                case .success( _):
                    self.errorLabel.text = "Le livreur a été créé"
                    self.errorLabel.isHidden = false
                    self.errorLabel.textColor = .green
                case .failure(let error):
                    self.errorLabel.text = error.localizedDescription
                    self.errorLabel.isHidden = false
                }
            }
            
        }
        
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

}
