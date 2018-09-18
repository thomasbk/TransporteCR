//
//  estimation.swift
//  GMaps
//
//  Created by Novacomp on 1/30/18.
//  Copyright © 2018 Novacomp. All rights reserved.
//

import UIKit

class Estimation: NSObject {
    
    typealias JSONStandard = Dictionary<String, Any>
    
    var time: Double
    var timeString: String?
    var distance: Double
    var distanceString: String?
    
    var segments: [Segment]
    var points: String!
    
    //values to be added when making estimation
    //var initialLocation: String
    //var endLocation: String
    var totalPrice: Int
    var date: Date
    var taxiClass: String
    var baseOperation: String
    
    
    override init() {
        time = 0
        distance = 0
        segments = []
        points = ""
        
        //initialLocation = ""
        //endLocation = ""
        totalPrice = 0
        date = Date()
        taxiClass = ""
        baseOperation = ""
    }
    
    func setEstimation (_ json: Dictionary<String, Any>) {
        
        if let routes = json["routes"] as? [JSONStandard] {
            
            //let json = JSON(data: response.data!)
            //let routess = json["routes"].arrayValue
            //originalSegments = routes
            
            if(routes.count > 0) {
                let legs = routes[0]
                
                if let legs2 = legs["legs"] as? [JSONStandard],
                    let firstLeg = legs2[0] as? JSONStandard,
                    let distance = firstLeg["distance"] as? JSONStandard,
                    let duration = firstLeg["duration"] as? JSONStandard,
                    let steps = firstLeg["steps"] as? [JSONStandard]
                {
                    self.timeString = duration["text"] as? String
                    self.distanceString = distance["text"] as? String
                    self.time = (duration["value"] as! Double) / 3600 // seconds to hours
                    self.distance = (distance["value"] as! Double) / 1000 // m to kms
                    
                    
                    var overview = legs["overview_polyline"] as? JSONStandard
                    self.points = overview!["points"] as! String
                
                    for step in steps {
                    
                        let newSegment = Segment()
                        
                        var locationJson = step["end_location"] as? JSONStandard
                        newSegment.destinationLatitude = (locationJson!["lat"] as? Double)!
                        newSegment.destinationLongitude = (locationJson!["lng"] as? Double)!
                        
                        var initLocationJson = step["start_location"] as? JSONStandard
                        newSegment.initialLatitude = (initLocationJson!["lat"] as? Double)!
                        newSegment.initialLongitude = (initLocationJson!["lng"] as? Double)!
                        
                        var distanceJson = step["distance"] as? JSONStandard
                        newSegment.distance = (distanceJson!["value"] as? Double)! / 1000 // m to kms
                        var timeJson = step["duration"] as? JSONStandard
                        newSegment.time = (timeJson!["value"] as? Double)! / 3600 // seconds to hours
                        newSegment.avgSpeed = newSegment.distance / newSegment.time
                        
                        
                        segments.append(newSegment)
                        
                        print("distance: \(newSegment.distance)")
                        print("time: \(newSegment.time)")
                        print("speed: \(newSegment.avgSpeed)")
                    }
                }
                else {
                    noRouteAlert()
                }
            
            }
            else {
                noRouteAlert()
            }
        }
        else {
            noRouteAlert()
        }
        
    }
    
    func noRouteAlert () {
        let alert = UIAlertController(title: "Alerta", message: "No se encontró ninguna ruta hacia el destino seleccionado.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }}))
        
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if (rootViewController?.presentedViewController != nil) { rootViewController = rootViewController?.presentedViewController; }
        rootViewController?.present(alert, animated: true, completion: nil)
    }

}
