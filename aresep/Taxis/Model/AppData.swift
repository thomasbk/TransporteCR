//
//  AppData.swift
//  aresep
//
//  Created by Pro Retina on 6/11/18.
//  Copyright © 2018 SOIN. All rights reserved.
//

import UIKit

class AppData: NSObject {

    var derechosReservados: String? = ""
    var liberacionRespon: String? = ""
    var infoApp: String? = ""
    var showViajeCalculado: Bool = false
    var versionApp: String? = ""
    var lastUpdate: Date = Date()
    
    
    // Can't init is singleton
    override private init() { }
    
    // MARK: Shared Instance
    static let sharedInstance = AppData()
    
    
    func setData (_ json: Dictionary<String, Any>) {
        
        if let lista = json["RO"] as? [Dictionary<String, Any>] {
            for item in lista {
                if(item["K"] as? String == "DerechosReservados") {
                    self.derechosReservados = item["V"] as? String
                }
                else if(item["K"] as? String == "LiberacionRespon") {
                    self.liberacionRespon = item["V"] as? String
                }
                else if(item["K"] as? String == "InfoApp") {
                    self.infoApp = item["V"] as? String
                }
                else if(item["K"] as? String == "VersionApp") {
                    self.versionApp = item["V"] as? String
                }
                else if(item["K"] as? String == "ShowViajeCalculado") {
                    if(item["V"] as! String == "True") {
                        self.showViajeCalculado = true
                    }
                    else {
                        self.showViajeCalculado = false
                    }
                }
                
            }
        }
        
 
    }
    
}
