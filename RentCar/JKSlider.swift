//
//  JKSlider.swift
//  RentCar
//
//  Created by chaoyang805 on 16/4/13.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

public class JKSlider: UIView {
    
    public var delegate: JKSliderDelegate?
    
    @IBOutlet weak var slider: UIView!
    private var carButton: UIButton!
    var sliderBar: CALayer!
    var sliderBarHeight: CGFloat {
        return 5
    }
    
    private(set) var currentPosition = 0 {
        didSet {
            delegate?.slider(self, didMoveToPosition: currentPosition)
        }
    }
    
    var dotWidth: CGFloat {
        return 10
    }
    
    var width: CGFloat {
        return self.frame.width
    }
    
    var height: CGFloat {
        return self.frame.height
    }
    
    var dots: [CALayer]
    
    var dotsCount = 4
    
    var stepWidth: CGFloat {
        return slider.frame.width / (CGFloat(dotsCount) - 1)
    }
    override public init(frame: CGRect) {
        dots = []
        super.init(frame: frame)
        initializeView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        dots = []
        super.init(coder: aDecoder)
        initializeView()
    }
    
    private func initializeView() {
        if let view = NSBundle.mainBundle().loadNibNamed("JKSlider", owner: self, options: nil).first {
            self.addSubview(view as! UIView)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        // 设置了约束后，保证能正确获得slider的宽高
        slider.layoutIfNeeded()
        sliderBar = CALayer()
        sliderBar.frame = CGRect(x: dotWidth / 2, y: slider.frame.height / 2 - sliderBarHeight / 2, width: slider.frame.width - dotWidth, height: sliderBarHeight)
        sliderBar.backgroundColor = UIColor.whiteColor().CGColor
        sliderBar.borderColor = UIColor.lightGrayColor().CGColor
        sliderBar.borderWidth = 0.5
        sliderBar.cornerRadius = sliderBarHeight / 2
        slider.layer.addSublayer(sliderBar)
        
        for index in 0..<dotsCount {
            
            let layer = CALayer()
            layer.frame = CGRect(x: 0, y: 0, width: dotWidth, height: dotWidth)
            let originX = sliderBar.frame.origin.x - dotWidth / 2 + CGFloat(index) * sliderBar.frame.width / CGFloat(dotsCount - 1)
            let originY = sliderBar.frame.origin.y + (sliderBarHeight - dotWidth) / 2
            layer.frame.origin = CGPoint(x: originX, y: originY)
            layer.backgroundColor = UIColor.whiteColor().CGColor
            layer.cornerRadius = dotWidth / 2
            layer.borderColor = UIColor.lightGrayColor().CGColor
            layer.borderWidth = 0.5
            dots.append(layer)
            slider.layer.addSublayer(layer)
            
        }
    
        carButton = UIButton(frame: CGRect(x: 0, y: 0, width: slider.frame.height, height: slider.frame.height))
        carButton.center = dots[0].center
        carButton.layer.shadowOffset = CGSizeMake(1, 1)
        carButton.layer.shadowOpacity = 0.3
        carButton.backgroundColor = UIColor.whiteColor()
        carButton.layer.shadowColor = UIColor.blackColor().CGColor
        carButton.layer.cornerRadius = carButton.frame.width / 2
        carButton.setImage(UIImage(named: "ic_slider_car"), forState: .Normal)
        carButton.setImage(UIImage(named: "ic_slider_car_selected"), forState: .Highlighted)
        carButton.addTarget(self, action: #selector(JKSlider.carButtonTouched(_:withEvent:)), forControlEvents: .TouchDragInside)
        carButton.addTarget(self, action: #selector(JKSlider.carButton(_:touchesUpWithEvent:)), forControlEvents: .TouchUpInside)
        slider.addSubview(carButton)
        
    }
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let location = touch.locationInView(slider)
        
        carButton(carButton, moveToPosition: findTouchDotPosition(location))
        
    }
    // MARK: Utilies Methods
    private func findTouchDotPosition(location: CGPoint) -> Int? {
        for (index, dot) in dots.enumerate() {
            if touchedDot(location, dot: dot) {
                return index
            }
        }
        return nil
    }
    
    private func findNearestPosition() -> Int {
        let position = carButton.center.x / stepWidth
        return Int(round(position))
    }
    
    private func carButton(button: UIButton,moveToPosition position: Int?) {
        if var desPosition = position {
            if desPosition < 0 {
                desPosition = 0
            }
            if desPosition >= dotsCount {
                desPosition = dotsCount - 1
            }
            button.center = dots[desPosition].center
            currentPosition = desPosition
        }
    }
    
    private func touchedDot(location: CGPoint, dot: CALayer) -> Bool {
        if location.x >= dot.frame.origin.x && location.x <= dot.frame.origin.x + dot.frame.width &&
        location.y >= dot.frame.origin.y && location.y <= dot.frame.origin.y + dot.frame.height {
            return true
        }
        return false
    }
    // MARK: button actions
    @objc private func carButtonTouched(sender: UIButton,withEvent event: UIEvent) {
        let touch = event.touchesForView(sender)?.first
        sender.frame.origin.x += touch!.locationInView(sender).x - touch!.previousLocationInView(sender).x
    }
    
    @objc private func carButton(button: UIButton,touchesUpWithEvent event: UIEvent) {
        carButton(button, moveToPosition: findNearestPosition())
    }
    
}
// MARK: JKSlider
public protocol JKSliderDelegate {
    func slider(slider: JKSlider, didMoveToPosition position: Int)
}

// MARK: - CALayer extension
extension CALayer {
    
    public var center: CGPoint {
        return CGPoint(x: self.frame.origin.x + self.frame.width / 2, y: self.frame.origin.y + self.frame.height / 2)
    }
}

