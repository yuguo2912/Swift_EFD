//
//  Home2ViewController.swift
//  EFD_ipad
//
//  Created by Hugo Arnaudeau on 12/02/2025.
//

import UIKit

class Home2ViewController: UIViewController {
    
    //  LoginViewController.swift
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var connectionButton: UIButton!
    //@IBOutlet weak var errorLabel: UILabel!
    
    let authService = AuthService.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //errorLabel.isHidden = true
        passwordTextField.isSecureTextEntry = true
    }
    
    @IBAction func handleLogin(_ sender: Any) {
        guard let email = mailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print("❌ Champs vides")
            return
        }
        
        
        let loginDTO = LoginDTO(mail: email, password: password)
        
        authService.login(loginDto: loginDTO) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let token):
                DispatchQueue.main.async {
                    TokenManager.getInstance().saveToken(token)
                    UserDefaults.standard.set(token, forKey: "token")
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    
                    // 🔹 Récupération et stockage de l'ID utilisateur
                    if let userId = TokenManager.getInstance().getTokenClaims()?.id {
                        UserDefaults.standard.set(userId, forKey: "id")
                        Context.shared.userId = userId
                        print("✅ Utilisateur connecté avec ID : \(userId)")
                    } else {
                        print("❌ Impossible de récupérer l'ID depuis le token")
                    }
                    
                    (UIApplication.shared.delegate as? AppDelegate)?.showMainScreen(window: (UIApplication.shared.delegate as! AppDelegate).window!)
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    print("❌ Erreur de connexion :", error.localizedDescription)
                }
            }
        }
    }
}
