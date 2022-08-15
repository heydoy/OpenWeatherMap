//
//  WeatherTableViewCell.swift
//  OpenWeatherMap
//
//  Created by Doy Kim on 2022/08/15.
//

import UIKit
import Kingfisher

class WeatherTableViewCell: UITableViewCell {
    static let identifier = "WeatherTableViewCell"
    @IBOutlet weak var weatherTextView: textView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        weatherTextView.contentLabel.clipsToBounds = true
        weatherTextView.contentLabel.layer.cornerRadius = 8
        weatherTextView.isHidden = true

        self.backgroundColor = .clear
        
    }
    
    func textConfigure(text: String) {

        weatherTextView.isHidden = false
        weatherTextView.contentLabel.text = "    \(text)    "
    }
    
    
    

    
}
