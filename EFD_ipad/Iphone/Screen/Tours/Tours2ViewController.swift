//
//  Tours2ViewController.swift
//  EFD_ipad
//
//  Created by Hugo Arnaudeau on 12/02/2025.
//

import UIKit

class Tours2ViewController: UIViewController {
    
    @IBOutlet weak var listeTableView: UITableView!
    
    let packageService: PackageService = PackageService.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listeTableView.register(UINib(nibName: "Tours2TableViewCell", bundle: nil), forCellReuseIdentifier: "Tours2TableViewCell")
        self.listeTableView.delegate = self
        self.listeTableView.dataSource = self
        print("filtertours contient: \(filtertours?.count ?? 0) éléments")
        
        
        
        // Do any additional setup after loading the view.
    }
    var filtertours: [AllToursDTO]? {
        didSet {
            self.listeTableView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        packageService.getAllTours { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tours):
                    self.filtertours = tours
                    print(tours)
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
    
    
    @IBAction func goToMap(_ sender: Any) {
        let visual = VisualViewController()
        self.navigationController?.pushViewController(visual, animated: true)
    }
    
    @IBAction func goToPicture(_ sender: Any) {
        let picture = PicutreViewController()
        self.navigationController?.pushViewController(picture, animated: true)
    }
    
    
}
extension Tours2ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension Tours2ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filtertours?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tours2TableViewCell", for: indexPath) as! Tours2TableViewCell
        cell.redraw(filtertour: self.filtertours![indexPath.row])
        return cell
    }
}
