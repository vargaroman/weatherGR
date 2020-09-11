//
//  TodayWeatherTableViewCell.swift
//  weatherGR
//
//  Created by Roman Varga on 11/09/2020.
//  Copyright © 2020 Roman Varga. All rights reserved.
//

import UIKit

protocol GetLocationProtocolDelegate {
    func getMyLocation()
}

class TodayWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    var getLocationDelegate: GetLocationProtocolDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func currentLocationAction(_ sender: Any) {
        getLocationDelegate?.getMyLocation()
    }
    
}
