//
//  DropShadowView.swift
//  ZenSports
//
//  Created by Andrii on 12/10/19.
//  Copyright © 2019 ZenSports. All rights reserved.
//

import UIKit

class DropShadowView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibInitialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibInitialize()
    }
    
    func xibInitialize(){
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowColor = SHADOW_COLOR?.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.8
    }

}
