//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Zehra Öner on 5.08.2024.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

      @IBOutlet weak var cityLabel: UILabel!
      @IBOutlet weak var temperatureLabel: UILabel!
      @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
