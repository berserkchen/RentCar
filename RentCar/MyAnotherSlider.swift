//
//  MyAnotherSlider.swift
//  RentCar
//
//  Created by chaoyang805 on 16/5/19.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class MyAnotherSlider: UIView {
   
    @IBOutlet weak var sliderView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    var dotsLayer: [CALayer] = []
    var sliderDotCount: Int = 4
    var sliderDotWidth: CGFloat = 10
    var sliderDotHeight: CGFloat = 10
    var sliderBarWidth: CGFloat {
        return sliderView.frame.width
    }
    var sliderBarHeight: CGFloat = 5
    var carButton: UIButton!
    func initializeView() {
        guard let view = NSBundle.mainBundle().loadNibNamed("MyAnotherSlider", owner: self, options: nil).first as? UIView  else { return}
        self.addSubview(view)
    }
    
    override func layoutSubviews() {
        // 设置了约束，调用该方法会刷新View的frame到正确的值
        sliderView.layoutIfNeeded()
        
        // 绘制一条线
        let sliderBorderLayer = CALayer()
        
        sliderBorderLayer.frame = CGRect(x: 0, y: 0, width: sliderBarWidth - sliderDotWidth, height: sliderBarHeight)
        sliderBorderLayer.borderColor = UIColor.lightGrayColor().CGColor
        sliderBorderLayer.borderWidth = 1
        sliderBorderLayer.frame.origin = CGPoint(x: sliderDotWidth / 2, y: self.sliderView.frame.height / 2 - sliderBarHeight / 2)
        sliderBorderLayer.backgroundColor = UIColor.whiteColor().CGColor
        
        sliderBorderLayer.cornerRadius = 2.5
        self.sliderView.layer.addSublayer(sliderBorderLayer)
        
        
        // 添加四个圆点
        for i in 0..<sliderDotCount {
            
            let dotLayer = CALayer()
            dotLayer.frame = CGRect(x: 0, y: 0, width: sliderDotWidth, height: sliderDotHeight)
            dotLayer.backgroundColor = UIColor.whiteColor().CGColor
            dotLayer.borderWidth = 1
            dotLayer.borderColor = UIColor.lightGrayColor().CGColor
            dotLayer.cornerRadius = sliderDotWidth / 2
            let originX: CGFloat = sliderBorderLayer.frame.origin.x + CGFloat(i) * sliderBorderLayer.frame.width / CGFloat(sliderDotCount - 1) - sliderDotWidth / 2
            let originY: CGFloat = sliderBorderLayer.frame.origin.y - sliderDotHeight / 4
            dotLayer.frame.origin = CGPoint(x: originX, y: originY)
            self.sliderView.layer.addSublayer(dotLayer)
            self.dotsLayer.append(dotLayer)
        }
        
        carButton = UIButton(type: .System)
        carButton.setImage(UIImage(named: "ic_slider_car"), forState: .Normal)
        carButton.tintColor = UIColor.blackColor()
        carButton.backgroundColor = UIColor.whiteColor()
        carButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        carButton.layer.cornerRadius = 22
        carButton.layer.shadowColor = UIColor.grayColor().CGColor
        carButton.layer.shadowOffset = CGSizeMake(1, 1)
        carButton.layer.shadowOpacity = 0.3
        carButton.center = dotsLayer[0].center
        carButton.addTarget(self, action: #selector(MyAnotherSlider.carButton(_:draggedWithEvent:)), forControlEvents: .TouchDragInside)
        carButton.addTarget(self, action: #selector(MyAnotherSlider.carButton(_:touchesUpWithEvent:)), forControlEvents: .TouchUpInside)
        self.sliderView.addSubview(carButton)
    }
    
    
    func carButton(sender: UIButton, draggedWithEvent event: UIEvent) {
        if sender.center.x < 0 || sender.center.x > sliderView.frame.width {
            return
        }
        guard let touchPoint = event.touchesForView(sender)?.first else { return }
        let offset = touchPoint.locationInView(sender).x - touchPoint.previousLocationInView(sender).x
        sender.frame.origin.x += offset
        
    }
    
    
    
    func carButton(sender: UIButton, touchesUpWithEvent event: UIEvent) {
        carButtonMoveToPosition(findCarButtonNearestPosition())
    }
    
    var carButtonStepWidth: CGFloat {
        return self.sliderView.frame.width / CGFloat(sliderDotCount - 1)
    }
    
    func findCarButtonNearestPosition() -> Int {
        var position = Int(round(carButton.center.x / carButtonStepWidth))
        if position < 0 {
            position = 0
        }
        if position > sliderDotCount - 1 {
            position = sliderDotCount - 1
        }
        return position
    }
    
    func carButtonMoveToPosition(position: Int) {
        delegate?.mySliderDidMoveToPosition(position)
        carButton.center.x = dotsLayer[position].center.x
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.locationInView(sliderView)
        if let position = findTouchedDot(location) {
            carButtonMoveToPosition(position)
        }
    }
    
    func findTouchedDot(location: CGPoint) -> Int? {
        for (index, dot) in dotsLayer.enumerate() {
            
            if dot.containsPoint(dot.convertPoint(location, fromLayer: sliderView.layer)) {
                return index
            }
        }
        return nil
    }
    
    var delegate: MyAnotherSliderDelegate?

}

protocol MyAnotherSliderDelegate {
    func mySliderDidMoveToPosition(position: Int)
}
