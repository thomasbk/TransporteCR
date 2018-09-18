//
//  Taxi.swift
//  aresep
//
//  Created by Pro Retina on 5/31/18.
//  Copyright © 2018 . All rights reserved.
//

import UIKit

class Taxi: NSObject {
    
    /*enum TaxiColors {
        case rojo, aeropuerto
    }
    enum TaxiType {
        case sedan, rural, modificado, microbus
    }*/

    var placa: String?
    var compania: String?
    var color: String?
    var tipo: String?
    
    override init() {
        placa = ""
        compania = ""
        color = ""
        tipo = ""
    }
    
    
}
