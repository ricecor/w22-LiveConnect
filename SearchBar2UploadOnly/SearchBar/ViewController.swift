//
//  ViewController.swift
//  SearchBar
//
//  Created by Jhoseph P. Ruiz Fachin on 3/10/22.
//
// Description:
// Uses search bar to search for places in the map.

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var selectedPin: MKPlacemark? = nil
    
    var resultSearchController: UISearchController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        // Set initial location in near Woodland Mall
        let initialLocation = CLLocation(latitude: 42.912836,longitude: -85.584114)
        centerMapOnLocation(location: initialLocation)
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearch") as! LocationSearchViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable as! UISearchResultsUpdating
        
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        //Set up the search bar
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
    }
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }}

//Drop a pin on the map whenever user tabs a search result
protocol HandleMapSearch {
    func dropPinZoomIN(placemark: MKPlacemark)
}

extension ViewController: HandleMapSearch {

    func dropPinZoomIN(placemark: MKPlacemark) {
        //cache the pin
        selectedPin = placemark
        //clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        
//        if let city = placemark.locality,
//           let state = placemark.administrativeArea {
//            annotation.subtitle = "(city) (state)"
//        }
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}
