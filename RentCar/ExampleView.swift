//
//  ExampleView.swift
//  RentCar
//
//  Created by chaoyang805 on 16/4/13.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class ExampleView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func layoutSubviews() {
        NSLog("\(self.frame)")
    }

}
