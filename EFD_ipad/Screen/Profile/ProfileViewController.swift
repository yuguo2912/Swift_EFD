//
//  ProfileViewController.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 08/02/2025.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var changePasswordBT: UIButton!
    @IBOutlet weak var modifyProfileInfoBT: UIButton!
    @IBOutlet weak var deleteAccountBT: UIButton!

    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var mailTF: UITextField!
    
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    @IBOutlet weak var rolePicker: UIPickerView!
    
    let adminService = AdminService.getInstance()
    let userService = UserService.getInstance()
    
    var user: User?
    var userId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rolePicker.delegate = self
        self.rolePicker.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let idToFetch = userId ?? TokenManager.getInstance().getTokenClaims()!.id
            
        userService.getUserById(id: idToFetch) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.user = user
                    self.firstNameTF.text = user.name
                    self.lastNameTF.text = user.lastname
                    self.mailTF.text = user.email
                    if let index = Role.allCases.firstIndex(of: user.role) {
                        self.rolePicker.selectRow(index, inComponent: 0, animated: false)
                    }
                    
                    let isCurrentUserAdmin = (TokenManager.getInstance().getTokenClaims()?.role == Role.ADMIN.rawValue)
                    self.rolePicker.isUserInteractionEnabled = isCurrentUserAdmin
                    
                    
                    let isCurrentUser = (TokenManager.getInstance().getTokenClaims()!.id == user.id) || isCurrentUserAdmin

                    self.firstNameTF.isUserInteractionEnabled = isCurrentUser
                    self.lastNameTF.isUserInteractionEnabled = isCurrentUser
                    self.mailTF.isUserInteractionEnabled = isCurrentUser
                    self.modifyProfileInfoBT.isHidden = !isCurrentUser
                    self.deleteAccountBT.isHidden = !isCurrentUser

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

    @IBAction func handleUpdateUser(_ sender: Any) {
        self.user?.name = firstNameTF.text!
        self.user?.lastname = lastNameTF.text!
        self.user?.email = mailTF.text!
        let selectedRow = rolePicker.selectedRow(inComponent: 0)
        
        if Role.allCases[selectedRow] == Role.USER || Role.allCases[selectedRow] == Role.ADMIN {
                let alert = UIAlertController(title: "Attention", message: "Une fois changé en USER ou en ADMIN, vous ne pourrez plus modifier l'utilisateur. Êtes-vous sûr ?", preferredStyle: .alert)
                
                let validateAction = UIAlertAction(title: "Valider", style: .default) { _ in
                    let selectedRow = self.rolePicker.selectedRow(inComponent: 0)
                    self.user?.role = Role.allCases[selectedRow]
                    self.handleUpdateUserProfile()
                }
                let cancelAction = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
                
                alert.addAction(validateAction)
                alert.addAction(cancelAction)
                
                present(alert, animated: true)
            } else {
                let selectedRow = rolePicker.selectedRow(inComponent: 0)
                user?.role = Role.allCases[selectedRow]
                self.handleUpdateUserProfile()
            }
    }
    
    private func handleUpdateUserProfile() {
        userService.editUserById(id: self.user!.id, user: self.user!) {result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    let alert = UIAlertController(title: "Success", message: "Donnée modifier avec succès", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true)
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
    
    @IBAction func changePassword(_ sender: Any) {
        guard let newPwd = self.newPasswordTF.text else { return }
        guard let confirmPwd = self.confirmPasswordTF.text else { return }
        
        if newPwd.isEmpty || confirmPwd.isEmpty {
            let alert = UIAlertController(title: "Erreur", message: "Le nouveau mot de passe et la confirmation ne peuvent pas être vides", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if newPwd != confirmPwd {
            let alert = UIAlertController(title: "Erreur", message: "Le nouveau mot de passe et la confirmation ne sont pas identiques", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.updatePassword(newPwd)
    }
    
    func updatePassword(_ newPwd: String) {
        let id = self.userId ?? TokenManager.getInstance().getTokenClaims()!.id
        
        let changePassword = ChangePasswordDTO(userId: id, password: newPwd)
        userService.changePassword(changePasswordDTO: changePassword) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    self.newPasswordTF.text = ""
                    self.confirmPasswordTF.text = ""
                    let alertController = UIAlertController(title: "Success", message: "Mot de passe modifié avec succès", preferredStyle: .alert)
                    let actionOk = UIAlertAction(title: "OK", style: .default) { _ in }
                    alertController.addAction(actionOk)
                    self.present(alertController, animated: true)
                case .failure(let error):
                    let alertController = UIAlertController(title: "Erreur", message: error.localizedDescription, preferredStyle: .alert)
                    let actionOk = UIAlertAction(title: "OK", style: .default) { _ in }
                    alertController.addAction(actionOk)
                    self.present(alertController, animated: true)
                }
            }
        }
    }
}


extension ProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Role.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 20
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Role.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedRole = Role.allCases[row]
        self.user?.role = selectedRole
    }
}
