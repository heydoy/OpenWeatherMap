//
//  imageView.swift
//  OpenWeatherMap
//
//  Created by Doy Kim on 2022/08/15.
//

import UIKit

class imageView: UIView {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var contentImageView: UIImageView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        let view = UINib(nibName: "imageView", bundle: nil).instantiate(withOwner: self).first as! UIView
        
        view.frame = bounds
        view.backgroundColor = .clear
        self.addSubview(view)
    }
    
 
}
