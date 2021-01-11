//
//  LocationMapViewController.swift
//  MyPhotography
//
//  Created by Tahmina Khanam on 2/11/19.
//  Copyright © 2019 Tahmina Khanam. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

class LocationMapViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 2000
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Location Map"
        
        let viewModel = LocationListViewModel(repository: LocationRepository())
        
        let locationDetails = viewModel.items
            .asDriver(onErrorRecover: { [weak self] error -> Driver<[LocationDetail]> in
                self?.show(error)
                return .empty()
            })
        
        locationDetails
        .drive( onNext: { details in
            self.mapView.removeAnnotations(self.mapView.annotations)
            details.forEach { [unowned self] locationDetail in
                
                let annotion = LocationAnnotaion(locationDetail: locationDetail)
                self.mapView.addAnnotation(annotion)
            }
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            
        })
        .disposed(by: disposeBag)
        
        //add gesture
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action:#selector(handleLongPress(gestureReconizer:)))
        mapView.addGestureRecognizer(gestureRecognizer)
        
        checkLocationAuthorizationStatus()
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
      mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
            //When lognpress is start or running
        }
        else {
            
            let location = gestureReconizer.location(in: mapView)
            let coordinate = mapView.convert(location,toCoordinateFrom: mapView)

            //show action
            let lat = String(format: "%.5f", coordinate.latitude)
            let lng = String(format: "%.5f", coordinate.longitude)
            let alert = UIAlertController(title: "Lat: \(lat), lng: \(lng)",
                                          message: "Do you want add a new location?",
                                          preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [unowned self]_ in
                let location = Location(name: "",
                                        latitude: coordinate.latitude,
                                        longitude: coordinate.longitude,
                                        isRemote: false)
                self.goToDetailPage(for: (location, nil))
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func goToDetailPage(for detail: LocationDetail) {
        guard let vc = LocationDetailViewController.create(locationDetail: detail) else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension LocationMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
          
        guard let annotation = annotation as? LocationAnnotaion else { return nil }
          
        let identifier = "marker"
        var view: MKMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        }
        else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? LocationAnnotaion else { return }
        goToDetailPage(for: annotation.locationDetail)
    }
}

class LocationAnnotaion: NSObject, MKAnnotation {
    let locationDetail: LocationDetail
    let coordinate: CLLocationCoordinate2D

    init(locationDetail: LocationDetail) {
        self.locationDetail = locationDetail
        self.coordinate = locationDetail.0.coordinate
        super.init()
    }
    var title: String? {
        return locationDetail.0.name
    }
    var subtitle: String? {
        return locationDetail.1?.text
    }
}

