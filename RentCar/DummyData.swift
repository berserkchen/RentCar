//
//  DummyData.swift
//  RentCar
//
//  Created by chaoyang805 on 16/5/24.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import Foundation
import CoreLocation

enum CarType: Int{
    case Hour = 0
    case Daily = 1
    case Long = 2
    case Try = 3
}

//CLLocationCoordinate2D(latitude: 37.337719530000001, longitude: -122.02827141)
//2016-05-26 09:55:57.811 RentCar[1149:45566] CLLocationCoordinate2D(latitude: 37.33771102, longitude: -122.03178914)
//2016-05-26 09:56:29.824 RentCar[1149:45566] CLLocationCoordinate2D(latitude: 37.337610820000002, longitude: -122.03416602)
//2016-05-26 09:56:51.063 RentCar[1149:45566] CLLocationCoordinate2D(latitude: 37.332331410000002, longitude: -122.0312186)
//2016-05-26 09:57:50.066 RentCar[1149:45566] CLLocationCoordinate2D(latitude: 37.33044907, longitude: -122.02969739)
let locations: [[String : Any]] = [
    [
        "car_type" : CarType.Hour,
        "car_name" : "大众",
        "car_image" : "vw",
        "price" : 1000,
        "coordinate" : CLLocationCoordinate2DMake(37.337719530000001, -122.02827141)
    ],
    [
        "car_type" : CarType.Hour,
        "car_name" : "马自达",
        "car_image" : "mazida",
        "price" : 1200,
        "coordinate" : CLLocationCoordinate2DMake(37.33771102, -122.03178914)
    ],
    [
        "car_type" : CarType.Hour,
        "car_name" : "现代",
        "car_image" : "xiandai",
        "price" : 1500,
        "coordinate" : CLLocationCoordinate2DMake(37.337610820000002, -122.03416602)
    ],
    [
        "car_type" : CarType.Hour,
        "car_name" : "丰田",
        "car_image" : "toyota",
        "price" : 800,
        "coordinate" : CLLocationCoordinate2DMake(37.332331410000002, -122.0312186)
    ],
    [
        "car_type" : CarType.Hour,
        "car_name" : "本田",
        "car_image" : "honda",
        "price" : 980,
        "coordinate" : CLLocationCoordinate2DMake(37.33044907, -122.02969739)
    ],
    // ===
    [
        "car_type" : CarType.Daily,
        "car_name" : "玛莎拉蒂",
        "car_image" : "masha",
        "price" : 10000,
        "coordinate" : CLLocationCoordinate2DMake(37.332331410000002, -122.02969739)
    ],
    [
        "car_type" : CarType.Daily,
        "car_name" : "雷克萨斯",
        "car_image" : "lexus",
        "price" : 3200,
        "coordinate" : CLLocationCoordinate2DMake(37.33044907, -122.03416602)
    ],
    [
        "car_type" : CarType.Daily,
        "car_name" : "宝马",
        "car_image" : "bmw",
        "price" : 5000,
        "coordinate" : CLLocationCoordinate2DMake(37.33771102, -122.02969739)
    ],
    [
        "car_type" : CarType.Daily,
        "car_name" : "兰博基尼",
        "car_image" : "lanbo",
        "price" : 12000,
        "coordinate" : CLLocationCoordinate2DMake(37.33771102, -122.0312186)
    ]
]

