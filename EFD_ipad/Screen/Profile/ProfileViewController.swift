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
    
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var mailTF: UITextField!
    @IBOutlet var newPasswordTF: UIView!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    @IBOutlet weak var rolePicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }


}
