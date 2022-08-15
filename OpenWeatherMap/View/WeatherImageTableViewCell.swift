//
//  WeatherImageTableViewCell.swift
//  OpenWeatherMap
//
//  Created by Doy Kim on 2022/08/16.
//

import UIKit

class WeatherImageTableViewCell: UITableViewCell {
    static let identifier = "WeatherImageTableViewCell"
    @IBOutlet weak var weatherImageView: imageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
    }

    func imageConfigure(image: String) {
        weatherImageView.baseView.layer.cornerRadius = 8
        weatherImageView.contentImageView.layer.cornerRadius = 8
        weatherImageView.isHidden = false
        
        let imageURL = URL(string: ENDPOINT.OPEN_WEATHER_ICON + image + "@2x.png")
        weatherImageView.contentImageView.kf.setImage(with: imageURL)
        
    }
    
}
