//
//  MainViewController.swift
//  EFD_ipad
//
//  Created by Hugo Arnaudeau on 23/12/2024.
//

import UIKit

class MainViewController: UIViewController, BlankViewControllerDelegate {
    
    weak var blankViewController: BlankViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func goToSuivi(_ sender: Any) {
        blankViewController?.handleAction(.goToSuivi)
    }
    
    @IBAction func goToConsultLivreur(_ sender: Any) {
        blankViewController?.handleAction(.goToConsultLivreur)
    }
    @IBAction func createLivreur(_ sender: Any) {
        blankViewController?.handleAction(.createLivreur)
    }
    @IBAction func goToConsultTournees(_ sender: Any) {
        blankViewController?.handleAction(.goToConsultTournees)
    }
    @IBAction func createTournees(_ sender: Any) {
        blankViewController?.handleAction(.createTournees)
    }
    func didSelectAction(_ action: BlankViewController.Action) {
        // Appelle la méthode handleAction du BlankViewController
        blankViewController?.handleAction(action)
    }
}
