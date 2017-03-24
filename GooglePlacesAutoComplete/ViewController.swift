//
//  ViewController.swift
//  GooglePlacesAutoComplete
//
//  Created by Xavier Noel on 24/03/2017.
//  Copyright © 2017 Xavier Noel. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController {
    
    let parisLatitude = 48.862725
    let parisLongitude = 2.287592
    let zoomLevel: Float = 15.0

    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: parisLatitude, longitude: parisLongitude, zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        self.view = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(parisLatitude, parisLongitude)
        marker.title = "Paris"
        marker.snippet = "France"
        marker.map = mapView
        
        
        
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
        
        
        placesClient = GMSPlacesClient()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Private functions
    /*func placeAutocomplete() {
        let visibleRegion = mapView.projection.visibleRegion()
        let bounds = GMSCoordinateBounds(coordinate: visibleRegion.farLeft, coordinate: visibleRegion.nearRight)
        
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        placesClient.autocompleteQuery("Sydney Oper", bounds: bounds, filter: filter, callback: {
            (results, error) -> Void in
            guard error == nil else {
                print("Autocomplete error \(error)")
                return
            }
            if let results = results {
                for result in results {
                    print("Result \(result.attributedFullText) with placeID \(result.placeID)")
                }
            }
        })
    }
     */

}


// Handle the user's selection.
extension ViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        
        let marker = GMSMarker()
        marker.position = place.coordinate
        marker.title = place.name
        marker.map = mapView
        
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude,
                                              longitude: place.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView.animate(to: camera)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
