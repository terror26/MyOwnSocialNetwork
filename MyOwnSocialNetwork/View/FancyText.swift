//
//  FancyText.swift
//  MyOwnSocialNetwork
//
//  Created by Kanishk Verma on 04/12/17.
//  Copyright © 2017 Kanishk Verma. All rights reserved.
//

import UIKit

class FancyText: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderColor = UIColor(red: CGFloat(Shadow_Color), green: CGFloat(Shadow_Color), blue: CGFloat(Shadow_Color), alpha: 0.6).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 5.0
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
}
