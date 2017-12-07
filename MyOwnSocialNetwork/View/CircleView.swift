//
//  CircleView.swift
//  MyOwnSocialNetwork
//
//  Created by Kanishk Verma on 07/12/17.
//  Copyright © 2017 Kanishk Verma. All rights reserved.
//

import UIKit

class CircleView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor(red: CGFloat(Shadow_Color), green: CGFloat(Shadow_Color), blue: CGFloat(Shadow_Color), alpha: 0.6).cgColor
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.8

    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = self.frame.width/2

    }
}
