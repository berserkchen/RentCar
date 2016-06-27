//
//  ViewController.swift
//  RentCar
//
//  Created by chaoyang805 on 16/3/31.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class MapViewController: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate, UIAlertViewDelegate, JKSliderDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var myLocationBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var zoomButton: JKMapZoomControl!
    @IBOutlet weak var slider: JKSlider!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var locationConstraint: NSLayoutConstraint!
    
    
    // MARK: fields
    var infoViewShowing: Bool = false
    var touchedAnnotation = false
    var shouldHideCarInfoView: Bool {
        return !touchedAnnotation
    }
    var carInfoYConstraint: NSLayoutConstraint!
    
    var locationManager: CLLocationManager?
    var currentCoordinate: CLLocationCoordinate2D!
    
    lazy var carInfoView: CarInfoView = {
        let width = self.view.frame.width - 16
        let height: CGFloat = 100
        let _carInfoView = CarInfoView(frame: CGRect())
        _carInfoView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(_carInfoView)
        
        let centerConstraint = NSLayoutConstraint(item: _carInfoView, attribute: .CenterX, relatedBy: .Equal, toItem: _carInfoView.superview, attribute: .CenterX, multiplier: 1.0, constant: 0)
        self.carInfoYConstraint = NSLayoutConstraint(item: _carInfoView, attribute: .Top, relatedBy: .Equal, toItem: _carInfoView.superview, attribute: .Bottom, multiplier: 1.0, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: _carInfoView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: width)
        let heightConstraint = NSLayoutConstraint(item: _carInfoView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: height)
        
        self.view.addConstraints([centerConstraint, self.carInfoYConstraint])
        _carInfoView.addConstraints([widthConstraint,heightConstraint])
        
        self.view.layoutIfNeeded()
        return _carInfoView
    }()
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLocationManager()
        
    }
    
    // MARK: MapView
    private func setupView() {
        zoomButton.addZoomUpSelector(#selector(MapViewController.zoomUp), zoomInSelector: #selector(MapViewController.zoomIn), forTarget: self)
        
        myLocationBtn.backgroundColor = UIColor(red: 254 / 255, green: 254 / 255, blue: 254 / 255, alpha: 1)
        myLocationBtn.layer.cornerRadius = 3
        myLocationBtn.layer.shadowColor = UIColor.grayColor().CGColor
        myLocationBtn.layer.shadowOffset = CGSizeMake(1, 2)
        myLocationBtn.layer.shadowOpacity = 1.0
        myLocationBtn.addTarget(self, action: #selector(MapViewController.moveToMyLocation), forControlEvents: .TouchUpInside)
        
        if let _ = mapView {
            let region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.337719530000001, -122.02827141), MKCoordinateSpanMake(0.03, 0.03))
            mapView.setRegion(region, animated: true)
            mapView.showsScale = true
            mapView.userTrackingMode = .FollowWithHeading
            mapView.delegate = self
        }
        
        slider.delegate = self
        updateCarsInfoWithPosition(slider.currentPosition)
    }
    
    private func updateCarsInfoWithPosition(position: Int) {
        if position < 0 || position > 3 {
            return
        }
        mapView.removeAnnotations(mapView.annotations)
        let cars = getCarsInfoByPostion(position);
        for carDict in cars {
            addAnnotationWithCarInfo(carDict)
        }
    }
    
    private func addAnnotationWithCarInfo(info: [String : Any]) {
        
        let annotation = CarAnnotation()
        guard let coordiante = info["coordinate"] as? CLLocationCoordinate2D,
        carName = info["car_name"] as? String, carPrice = info["price"] as? Int, carImage = info["car_image"] as? String else { return }
        let carInfo = CarInfo(carName: carName, carImage: carImage, carPrice: carPrice)
        annotation.coordinate = coordiante
        annotation.carInfo = carInfo
        mapView.addAnnotation(annotation)
    }
    
    private func getCarsInfoByPostion(position: Int) -> [[String : Any]]{
        return locations.filter({ (item: [String : Any]) -> Bool in
            return (item["car_type"] as! CarType).rawValue == position
        })
    }
    
    // MARK: MKMapViewDelegate
    let Identifier = "pinAnnotation"
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(Identifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Identifier)
        } else {
            annotationView?.annotation = annotation
        }
//        annotationView?.image = UIImage(named: "car.png")
        annotationView?.canShowCallout = false
        return annotationView
    }

    func mapView(mapView: MKMapView, didSelectAnnotationView annotationView: MKAnnotationView) {

        if let carAnnotation = annotationView.annotation as? CarAnnotation {
            carInfoView.carInfo = carAnnotation.carInfo
            touchedAnnotation = true
            showCarInfo()
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        if shouldHideCarInfoView {
            hideCarInfo()
        }
        touchedAnnotation = false
        NSLog("view touches end")
    }
    
    func showCarInfo() {
        if infoViewShowing {
            return
        }
        UIView.animateWithDuration(0.5, animations: { [weak self] in
            
            self!.bottomConstraint.constant = -100
            self!.view.layoutIfNeeded()
            
        }) { (done) in
            UIView.animateWithDuration(0.5, animations: {
                self.carInfoYConstraint.constant = -108
                self.locationConstraint.constant += 108
                self.view.layoutIfNeeded()
                self.infoViewShowing = true
            })
        }
    }
    
    func hideCarInfo() {
        if infoViewShowing {
            
            UIView.animateWithDuration(0.5, animations: {
                self.carInfoYConstraint.constant = 0
                self.locationConstraint.constant = 20
                self.view.layoutIfNeeded()
                }, completion: { (done) in
                    UIView.animateWithDuration(0.5, animations: {
                        self.bottomConstraint.constant = 0
                        self.view.layoutIfNeeded()
                        }, completion: { (done) in
                            self.infoViewShowing = false
                    })
            })
        }
    }

    // MARK: JKSliderDelegate
    func slider(slider: JKSlider, didMoveToPosition position: Int) {
        updateCarsInfoWithPosition(position)
    }
    
    
    // MARK: LocationManager
    private func setupLocationManager() {
        if !CLLocationManager.locationServicesEnabled() {
            showAlert("定位服务已禁用", message: "开启定位服务才能获取您的位置", positiveButton: nil, negativeButton: "好")
            return
        }
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.distanceFilter = 100
            locationManager?.delegate = self
        }
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    private func moveToLocation(coordinate: CLLocationCoordinate2D) {
        mapView.setCenterCoordinate(coordinate, animated: true)
    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            currentCoordinate = locations[0].coordinate
            moveToLocation(currentCoordinate)
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .Denied:
            showAlert("您拒绝了位置服务", message: "开启位置服务才能进行定位", positiveButton: nil, negativeButton: "好")
        case .AuthorizedWhenInUse:
            setupLocationManager()
        default:
            break
        }
    }
    
    // MARK: Button Selectors
    @objc private func zoomUp() {
    
        let rect = mapView.visibleMapRect
        let newOrigin = MKMapPoint(x: rect.origin.x + rect.size.width / 4.0, y: rect.origin.y + rect.size.height / 4.0)
        let newRect = MKMapRect(origin: newOrigin, size: MKMapSize(width: rect.size.width / 2, height: rect.size.height / 2))
        mapView.setVisibleMapRect(newRect, animated: true)
    }
    
    @objc private func zoomIn() {
        let originRect = mapView.visibleMapRect
        let newOrigin = MKMapPoint(x: originRect.origin.x - originRect.size.width / 2.0, y: originRect.origin.y - originRect.size.height / 2.0)
        let newRect = MKMapRect(origin: newOrigin, size: MKMapSize(width: originRect.size.width * 2, height: originRect.size.height * 2))
        mapView.setVisibleMapRect(newRect, animated: true)
    }
    
    func moveToMyLocation() {
        if currentCoordinate != nil {
            moveToLocation(currentCoordinate)
        }
    }
    
    // MARK: Utilities methods
    private func showAlert(title: String,message: String,positiveButton: String?,negativeButton: String?) {
        if let _ = positiveButton {
            let alert = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: negativeButton, otherButtonTitles: positiveButton!)
            alert.show()
        } else {
            let alert = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: negativeButton)
            alert.show()
        }
    }
}
