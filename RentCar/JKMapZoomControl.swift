//
//  JKMapZoomControl.swift
//  RentCar
//
//  Created by chaoyang805 on 16/3/31.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

public class JKMapZoomControl: UIView {
    
    @IBOutlet private var zoomUpButton: UIButton!
    @IBOutlet private var zoomInButton: UIButton!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeView()
    }
    private func initializeView() {
        if let view = NSBundle.mainBundle().loadNibNamed("JKMapZoomControl", owner: self, options: nil).first {
            view.layer.cornerRadius = 3
            view.layer.shadowColor = UIColor.grayColor().CGColor
            view.layer.shadowOffset = CGSizeMake(1, 2)
            view.layer.shadowOpacity = 1.0
            self.addSubview(view as! UIView)
        }
        
    }
    
    public func addZoomUpSelector(zoomUpSelector: Selector,zoomInSelector: Selector,forTarget target: AnyObject?) {
        zoomUpButton.addTarget(target, action: zoomUpSelector, forControlEvents: .TouchUpInside)
        zoomInButton.addTarget(target, action: zoomInSelector, forControlEvents: .TouchUpInside)
    }
}