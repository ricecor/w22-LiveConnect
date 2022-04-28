/// Copyright (c) 2022 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
//
//  LocationSearchViewController.swift
//  SearchBar2
//
//  Created by Jhoseph P. Ruiz Fachin on 3/12/22.
//
import UIKit
import MapKit

class LocationSearchViewController: UITableViewController {

   // MKLocalSearchRequest is our location request API
    var  matchingItems: [MKMapItem] = []
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate: HandleMapSearch? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func parseAddress(selectedItem: MKPlacemark) -> String {
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " ": ""
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", ": ""

        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " ": ""
        let addressLine = String(
            format: "%@%@%@%@%@%@%@",
        //Street number
            selectedItem.subThoroughfare ?? "",
        firstSpace,
        //Stree name
            selectedItem.thoroughfare ?? "",
        comma,
        // City
            selectedItem.locality ?? "",
        secondSpace,
        //State
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
}

extension LocationSearchViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        // Set up the API call
        guard let mapView = mapView, let searchBarText = searchController.searchBar.text else {return}
        let request = MKLocalSearch.Request()

        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region

        let search = MKLocalSearch(request: request)

        search.start { (response, error) in
            guard let response = response else {return}

            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}

extension LocationSearchViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
        return cell
    }

    //Go to a place when user clicks in the list
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIN(placemark: selectedItem)
        //print(parseAddress(selectedItem: selectedItem))
        dismiss(animated: true, completion: nil)
    }
}
