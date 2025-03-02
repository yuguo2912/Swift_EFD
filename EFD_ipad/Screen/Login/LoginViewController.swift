//
//  LoginViewController.swift
//  EFD_ipad
//
//  Created by Gil Rodrigues on 05/02/2025.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var connectionButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    let authService = AuthService.getInstance()
    let userService = UserService.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
        passwordTextField.isSecureTextEntry = true
    }
    
    @IBAction func handleLogin(_ sender: Any) {
        if mailTextField.text == "" && passwordTextField.text == "" {
            errorLabel.text = "Champs vides"
            errorLabel.isHidden = false
        }
        
        let logins : LoginDTO = LoginDTO(mail: mailTextField.text!, password: passwordTextField.text!)
        
        authService.login(loginDto: logins) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    TokenManager.getInstance().saveToken(token)
                    
                    if TokenManager.getInstance().getTokenClaims()?.role == Role.ADMIN.rawValue {
                        UserDefaults.standard.set(TokenManager.getInstance().getToken(), forKey: "token")
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        (UIApplication.shared.delegate as? AppDelegate)?.showMainScreen(window: (UIApplication.shared.delegate as! AppDelegate).window!)
                    }else {
                        self.errorLabel.text = "Vous n'êtes pas autorisé à accéder à cette application"
                        self.errorLabel.isHidden = false
                        TokenManager.getInstance().deleteToken()
                    }
                    
                case .failure(let error):
                    print("Erreur de connexion : \(error.localizedDescription)")
                    self.errorLabel.text = error.localizedDescription
                    self.errorLabel.isHidden = false
                }
            }
        }
    }
    

}
