//
//  CustomLabel.swift
//  UndoRedoDemo
//
//  Created by Ronak Kalavadia on 28/03/18.
//  Copyright © 2018 Ronak Kalavadia. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {
    
    var width: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        width = frame.size.width
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        let defultColor = UIColor(white: 1, alpha: 1)
        self.textColor = defultColor
        self.text = "This is logo maker text"
        self.font = UIFont.boldSystemFont(ofSize: 25)
        self.isUserInteractionEnabled = true
        self.textAlignment = .center
        self.numberOfLines = 0
        self.adjustsFontSizeToFitWidth = true
        self.sizeToFit()
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: width, height: self.frame.size.height)
    }
    
    
    var cornerRadius: NSNumber{
        set {self.layer.cornerRadius = CGFloat(newValue.floatValue)}
        get{return NSNumber(value: Float(self.layer.cornerRadius))}
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
