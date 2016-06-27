//
//  CarInfoView.swift
//  RentCar
//
//  Created by chaoyang805 on 16/5/26.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//
import UIKit

class CarInfoView: UIView {
    
    @IBOutlet weak var carInfoImageView: UIImageView!
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var carPriceLabel: UILabel!
    
    var carInfo: CarInfo? {
        didSet {
            configureView()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeView()
    }
    
    func initializeView() {
        if let view = NSBundle.mainBundle().loadNibNamed("CarInfoView", owner: self, options: nil).first as? UIView {
            view.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            view.layer.cornerRadius = 3
            view.layer.shadowColor = UIColor.grayColor().CGColor
            view.layer.shadowOffset = CGSize(width: 1, height: 2)
            view.layer.shadowOpacity = 1.0
            self.addSubview(view)
            
        }
    }
    
    func configureView() {
        guard let carInfo = carInfo else { return }
        guard let carNameLabel = carNameLabel, carPriceLabel = carPriceLabel, carInfoImageView = carInfoImageView else {return}
        
        carNameLabel.text = carInfo.carName
        carInfoImageView.image = UIImage(named: carInfo.carImage)
        carPriceLabel.text = "\(carInfo.carPrice)"
    }
    
}
