//
//  ViewController.swift
//  003MyLocation
//
//  Created by 沈翔 on 2019/11/25.
//  Copyright © 2019 沈翔. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
    }

    @IBAction func handleBtnTapped(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}

extension ViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        
        CLGeocoder().reverseGeocodeLocation(locations.first!) { (placemark, error) in
            guard error == nil else {
                return
            }
            let pm = placemark!.first
            
            let alertController = UIAlertController(title: "您的位置", message: "\(pm!.country!) \(pm!.locality!) \(pm!.name!)", preferredStyle: .alert)
            
            let comfirm = UIAlertAction(title: "显示位置", style: .default) { (_) in
                
                let lat = locations[0].coordinate.latitude
                let lon = locations[0].coordinate.longitude
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                self.mapView.setRegion(MKCoordinateRegion(center:
                    coordinate, span: span), animated: true)
                
                let circle = MKCircle(center: coordinate, radius: 100)
                self.mapView.addOverlay(circle)
                
                self.dismiss(animated: true, completion: nil)
            }
            
            alertController.addAction(comfirm)
            
            self.present(alertController, animated: true, completion: nil)
        }
    
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKCircleRenderer(overlay: overlay)
        renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
        renderer.strokeColor = UIColor.black
        renderer.lineWidth = 2
        return renderer
    }
}
