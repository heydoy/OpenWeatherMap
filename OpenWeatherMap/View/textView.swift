//
//  textView.swift
//  OpenWeatherMap
//
//  Created by Doy Kim on 2022/08/15.
//

import UIKit

class textView: UIView {

    @IBOutlet weak var contentLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        let view = UINib(nibName: "textView", bundle: nil).instantiate(withOwner: self).first as! UIView
        
        
        view.frame = bounds
        view.backgroundColor = .clear
        
        self.addSubview(view)
    }


}
