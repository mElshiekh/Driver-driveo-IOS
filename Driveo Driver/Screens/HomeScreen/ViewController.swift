//
//  ViewController.swift
//  Driveo Driver
//
//  Created by Admin on 6/10/18.
//  Copyright © 2018 Ibtkar. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {

    //@IBOutlet weak var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    
    var marker:GMSMarker!
    
//    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        marker = GMSMarker()
        
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
       locationManager.distanceFilter = 10
        locationManager.allowsBackgroundLocationUpdates = true
//        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
//        placesClient = GMSPlacesClient.shared()
    }
    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.icon = UIImage.init(named: "logofinal.png")
        marker.map = mapView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension ViewController: CLLocationManagerDelegate{
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        currentLocation = location
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        
        marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        var img = UIImage.init(named: "logofinal.png")
        marker.icon = img
        marker.iconView?.frame.size = CGSize(width: 33.0, height: 33.0)
        marker.map = mapView
        
//        if mapView.isHidden {
//            mapView.isHidden = false
//            mapView.camera = camera
//        } else {
//            mapView.animate(to: camera)
//        }
        mapView.animate(to: camera)
        //listLikelyPlaces()
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            
            locationManager.requestAlwaysAuthorization()
            //mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
            locationManager.requestAlwaysAuthorization()
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
            
            
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

