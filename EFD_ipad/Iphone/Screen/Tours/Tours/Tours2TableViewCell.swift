

import UIKit

class Tours2TableViewCell: UITableViewCell {
    
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func redraw(filtertour: TourByIDDTO) {
        self.lastNameLabel.text = "\(filtertour.deliveryTourId ?? 0)"
        self.firstNameLabel.text = "\(filtertour.tourId ?? 0 )"
         self.dateLabel.text =  "\(filtertour.Packages ?? 0)"
    }
}
