//
//  CarAnnotationView.swift
//  RentCar
//
//  Created by chaoyang805 on 16/5/26.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import MapKit
import UIKit

class CarAnnotation: MKPointAnnotation {

    var carInfo: CarInfo! {
        didSet {
            if let _ = carInfo {
                self.title = carInfo.carName
                self.subtitle = "\(carInfo.carPrice)"
            }
        }
    }

}
