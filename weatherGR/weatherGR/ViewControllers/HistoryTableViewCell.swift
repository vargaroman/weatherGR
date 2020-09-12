//
//  HistoryTableViewCell.swift
//  weatherGR
//
//  Created by Roman Varga on 10/09/2020.
//  Copyright © 2020 Roman Varga. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentForecastImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setForecastImage(image: UIImage) {
        self.currentForecastImageView.image = image
    }

}
