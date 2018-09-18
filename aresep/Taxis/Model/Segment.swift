//
//  Segment.swift
//  aresep
//
//  Created by Thomas Baltodano on 4/6/18.
//  Copyright © 2018 SOIN. All rights reserved.
//

import UIKit

class Segment: NSObject {
    var tarifaAplicable: String
    var avgSpeed: Double
    var acumulatedTime: Double
    var time: Double
    var distance: Double
    var acumulatedDistance: Double
    var acumulatedPrice: Double
    var initialLatitude: Double
    var initialLongitude: Double
    var destinationLatitude: Double
    var destinationLongitude: Double
    
    override init() {
        tarifaAplicable = ""
        avgSpeed = 0
        acumulatedTime = 0
        time = 0
        acumulatedDistance = 0
        distance = 0
        acumulatedPrice = 0
        initialLatitude = 0
        initialLongitude = 0
        destinationLatitude = 0
        destinationLongitude = 0
    }

}
