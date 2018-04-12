//
//  CustomView.swift
//  UndoRedoDemo
//
//  Created by Ronak Kalavadia on 28/03/18.
//  Copyright © 2018 Ronak Kalavadia. All rights reserved.
//

import UIKit

class CustomView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        let defultColor = UIColor(white: 0.7, alpha: 1)
        self.backgroundColor = defultColor
        layer.borderColor = defultColor.cgColor
        layer.borderWidth = 1.0
    }
    
    
    var cornerRadius: NSNumber{
        set {
            self.layer.cornerRadius = CGFloat(newValue.floatValue)
        }
        get{
            return NSNumber(value: Float(self.layer.cornerRadius))
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
