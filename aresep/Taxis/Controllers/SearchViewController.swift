//
//  SearchViewController.swift
//  aresep
//
//  Created by Thomas Baltodano on 7/1/18.
//  Copyright © 2018 SOIN. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces


class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    typealias JSONStandard = Dictionary<String, Any>
    
    @IBOutlet weak var tableView: UITableView!
    var results = [GMSAutocompletePrediction]()
    
    weak var delegate:TaxiMapViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData(locations: [GMSAutocompletePrediction]) {
        results = locations
        self.tableView.reloadData()
    }
    
    @IBAction func cancelarAction() {
        self.view.isHidden = true
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! SearchCell
        
        let result = results[indexPath.row]
        
        let name = result.attributedPrimaryText.string
        let address = result.attributedSecondaryText?.string
        
        cell.nameLabel?.text = name
        cell.descriptionLabel?.text = address
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let placeID = results[indexPath.row].placeID!
        let placesClient = GMSPlacesClient()
        
        showProgressIndicator()
        
        placesClient.lookUpPlaceID(placeID, callback: { (place, error) -> Void in
            
            self.hideProgressIndicator()
            
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                print("No place details for \(placeID)")
                return
            }
            
            let myLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            
            
            self.delegate?.setSearchDestination(location: myLocation)
            
        })
        
        
    }
    
    
    //:::: Dismiss Keyboard
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
}

class SearchCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
}
