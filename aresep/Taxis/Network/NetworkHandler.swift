//
//  NetworkHandler.swift
//  GMaps
//
//  Created by Novacomp on 1/30/18.
//  Copyright © 2018 Novacomp. All rights reserved.
//

import UIKit
//import Foundation
import Alamofire
import CoreLocation

class NetworkHandler: NSObject {
    
    //static let url = "http://novabnk.crnova.com/ARESEP.ServicioWebApi" // Local
    //static let url = "http://dev.aresep.go.cr/WWW/ws.transporte" // ARESEP Dev
    static let url = "https://apps.aresep.go.cr/ws.transporte" // ARESEP Produccion
    
    
    typealias JSONStandard = Dictionary<String, Any>
    
    class func getFareData( completed: @escaping (_ data:JSONStandard )-> ()) {
        
        let urlString = "\(url)/Tarifa/ObtenerTarifas"
        
        Alamofire.request(urlString).responseJSON(completionHandler: {
            response in
            let result = response.result
            
            if let dict = result.value as? JSONStandard {
                
                print("This is my result: \(dict)");
                completed(dict)
            }
            else {
                connectionErrorAlert()
            }
            
        })
    }
    
    class func getRatingCategories( completed: @escaping (_ data:JSONStandard )-> ()) {
        
        let urlString = "\(url)/General/ObtenerCaracteristicaCalidad"
        
        Alamofire.request(urlString).responseJSON(completionHandler: {
            response in
            let result = response.result
            
            if let dict = result.value as? JSONStandard {
                
                completed(dict)
            }
            else {
                connectionErrorAlert()
            }
            
        })
    }
    
    
    class func getVehiculos( completed: @escaping (_ data:JSONStandard )-> ()) {
        
        let urlString = "\(url)/TipoVehiculo/Obtener"
        
        Alamofire.request(urlString).responseJSON(completionHandler: {
            response in
            let result = response.result
            
            if let dict = result.value as? JSONStandard {
                print("This is my result: \(dict)")
                
                completed(dict)
            }
            else {
                connectionErrorAlert()
            }
            
        })
    }
    
    class func registerUser(name:String, id:String, email:String, completed: @escaping (_ data:JSONStandard )-> ()) {
        
        // params
        //{ "Id": "00-0000-0000", "N": "Nombre Usuario", "E": "correo@correo.com" }
        
        let urlString = "\(url)/Registro/RegistrarUsuario"
        
        let params: [String: String] = [
            "Id" : id,
            "N" : name,
            "E" : email,
        ]
        
        Alamofire.request(urlString, method: .put, parameters: params, encoding: JSONEncoding.default, headers: [:]).responseJSON(completionHandler: {
            response in
            let result = response.result
            
            if let dict = result.value as? JSONStandard {
                print("This is my result: \(dict)")
                
                completed(dict)
            }
            else {
                connectionErrorAlert()
            }
            
        })
        
    }
    
    class func getGeneralInfo( completed: @escaping (_ data:JSONStandard )-> ()) {
        
        let urlString = "\(url)/General/ObtenerInfoGeneral"
        
        Alamofire.request(urlString).responseJSON(completionHandler: {
            response in
            let result = response.result
            
            if let dict = result.value as? JSONStandard {
                print("This is my result: \(dict)")
                
                completed(dict)
            }
            else {
                connectionErrorAlert()
            }
            
        })
    }
    
    class func getTaxiInfo(taxi:String, completed: @escaping (_ data:JSONStandard )-> ()) {
        
        //params
        //Se ingresa el texto en el body entre comillas. Ejemplo "TJS001".
        
        let urlString = "\(url)/Taxi/ObtenerInfo"
        
        Alamofire.request(urlString, method: .put, parameters: [:], encoding: "\"\(taxi)\"", headers:  [:]).responseJSON(completionHandler: {
            response in
            let result = response.result
            
            if let dict = result.value as? JSONStandard {
                print("This is my result: \(dict)")
                
                completed(dict)
            }
            else {
                connectionErrorAlert()
            }
        })
        
    }
    
    
    class func addTrip(tripData:Rules, ratingData:[NSManagedObject], taxiFare:String, tripID: Int, completed: @escaping (_ data:JSONStandard )-> ()) {
        
        // params
        var calificaciones = [JSONStandard]()
        
        for rating in ratingData {
        
            let calificacion: JSONStandard = [
                "IdC" : rating.value(forKeyPath: "id") as! Int,
                "C" : rating.value(forKeyPath: "value") as! Int,
                ]
            calificaciones.append(calificacion)
        }
        
        
        
        var detalles = [JSONStandard]()
        
        var uInicio = ""
        var uFin = ""
        
        for segment in tripData.currentTrip {
            
            let detalle: JSONStandard = [
                "U" : "\(segment.destinationLatitude),\(segment.destinationLongitude)",   //ubicacion
                "V" : segment.avgSpeed,  //velocidad
                "TmpA" : segment.acumulatedTime.formattedSeconds(format: "HH:mm:ss"),
                "DA" : segment.acumulatedDistance,
                "MA" : segment.acumulatedPrice,
                "TA" : segment.tarifaAplicable,
                "D" : segment.distance,
                "T" : segment.time,
                
            ]
            
            if(uInicio == "") {
                uInicio =  "\(segment.initialLatitude),\(segment.initialLongitude)"
            }
            uFin = "\(segment.destinationLatitude),\(segment.destinationLongitude)"
            
            detalles.append(detalle)
        }
        
        let userID = DBHandler.getUserID()
        
        let time = tripData.traveledTime
        let price = tripData.totalPriceRounded
        let distance = tripData.traveledDistance
        
        let viaje: JSONStandard = [
            "PT" : "iOS", //plataforma
            "IdA" : UUID().uuidString, //identificador
            "IdU" : userID, //id usuario
            "UbI" : uInicio,  //ubicacion inicio
            "UbF" : uFin,  //ubicacion fin
            "Dst" : distance,  // distancia
            "TT" : time.formattedSeconds(format: "HH:mm:ss"),   // tiempo total Formato “HH:MM:SS”
            "ME" : price,   // Monto estimado
            "MT" : taxiFare,   // Monto total
            "FR" : tripData.date.formattedDate(format: "YYYY-MM-dd HH:mm:ss"), // fecha “YYYY-MM-DD HH:MM:SS
            "Dtl" : detalles,  // Detalle
            "Clf" : calificaciones,    // Calificacion
            "P" : tripData.plate,
            "TV" : tripData.taxiClass,
            "BO" : tripData.baseOperation
            ]
        
        //let viajePrevio: JSONStandard = [:]
        
        let params: JSONStandard = [
            "V" : viaje
            //"VC" : viajePrevio
            ]
        
        print(params)
        
        DBHandler.saveTripData(tripData: "\(dictionaryToJson(from: params))", id: tripID)
        
        let urlString = "\(url)/Viaje/InsertarViaje"
        
        Alamofire.request(urlString, method: .put, parameters: params, encoding: JSONEncoding.default, headers: [:]).responseJSON(completionHandler: {
            response in
            let result = response.result
            
            if let dict = result.value as? JSONStandard {
                print("This is my result: \(dict)")
                
                completed(dict)
            }
            else {
                connectionErrorAlert()
            }
            
        })
    }
    
    
    
    
    class func sendSavedTrip(tripData:String, completed: @escaping (_ data:JSONStandard )-> ()) {
        
        // params
        
        print(tripData)
        
        let params = jsonToDictionary(from: tripData) ?? [String : Any]()
        
        print("TEST JSON")
        print(params)
        
        let urlString = "\(url)/Viaje/InsertarViaje"
        
        Alamofire.request(urlString, method: .put, parameters: params, encoding: JSONEncoding.default, headers: [:]).responseJSON(completionHandler: {
            response in
            let result = response.result
            
            if let dict = result.value as? JSONStandard {
                print("This is my result: \(dict)")
                
                completed(dict)
            }
            else {
                connectionErrorAlert()
            }
            
        })
    }
    
    // Convertir String a JSON
    class func jsonToDictionary(from text: String) -> [String: Any]? {
        guard let data = text.data(using: .utf8) else { return nil }
        let anyResult = try? JSONSerialization.jsonObject(with: data, options: [])
        return anyResult as? [String: Any]
    }
    
    
    class func dictionaryToJson(from dictionary: [String: Any]) -> String {
        let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: [])
        let jsonString = String(data: jsonData!,encoding: .ascii)
        return jsonString!
    }
    
    
    class func sendEstimation(tripData:Estimation, completed: @escaping (_ data:JSONStandard )-> ()) {
        
        // params
        
        var detalles = [JSONStandard]()
        
        var uInicio = ""
        var uFin = ""
        
        for segment in tripData.segments {
            
            let detalle: JSONStandard = [
                "U" : "\(segment.destinationLatitude),\(segment.destinationLongitude)",   //ubicacion
                "V" : Int(segment.avgSpeed),  //velocidad
                "TmpA" : (segment.acumulatedTime * 3600).formattedSeconds(format: "HH:mm:ss"),
                "DA" : segment.acumulatedDistance * 1000,
                "MA" : segment.acumulatedPrice,
                "TA" : segment.tarifaAplicable,
                "D" : segment.distance * 1000,
                "T" : segment.time * 3600,
                
                ]
            
            if(uInicio == "") {
                uInicio =  "\(segment.initialLatitude),\(segment.initialLongitude)"
            }
            uFin = "\(segment.destinationLatitude),\(segment.destinationLongitude)"
            
            detalles.append(detalle)
        }
        
        let userID = DBHandler.getUserID()
        
        let time = tripData.time * 3600
        let price = tripData.totalPrice
        let distance = tripData.distance * 1000
        
        let viaje: JSONStandard = [
            "PT" : "iOS", //plataforma
            "IdA" : UUID().uuidString, //identificador
            "IdU" : userID, //id usuario
            "UbI" : uInicio,  //ubicacion inicio
            "UbF" : uFin,  //ubicacion fin
            "Dst" : distance,  // distancia
            "TT" : time.formattedSeconds(format: "HH:mm:ss"),   // tiempo total Formato “HH:MM:SS”
            "ME" : price,   // Monto estimado
            "MT" : 0,   // Monto total
            "FR" : tripData.date.formattedDate(format: "YYYY-MM-dd HH:mm:ss"), // fecha “YYYY-MM-DD HH:MM:SS
            "Dtl" : detalles,  // Detalle
            //"Clf" : calificaciones,    // Calificacion
            //"P" : tripData.plate,
            "TV" : tripData.taxiClass,
            "BO" : tripData.baseOperation
        ]
        
        //let viajePrevio: JSONStandard = [:]
        
        let params: JSONStandard = [
            "VC" : viaje
        ]
        
        print(params)
        
        let urlString = "\(url)/Viaje/InsertarViaje"
        
        Alamofire.request(urlString, method: .put, parameters: params, encoding: JSONEncoding.default, headers: [:]).responseJSON(completionHandler: {
            response in
            let result = response.result
            
            if let dict = result.value as? JSONStandard {
                print("This is my result: \(dict)")
                
                completed(dict)
            }
            else {
                connectionErrorAlert()
            }
            
        })
    }
    
    
    
    
    class func exportTrips(userID:String, completed: @escaping (_ data:JSONStandard )-> ()) {
        
        //params
        //Se ingresa el texto en el body entre comillas. Ejemplo "TJS001".
        
        let urlString = "\(url)/Viaje/ExportarViajes"
        
        Alamofire.request(urlString, method: .put, parameters: [:], encoding: "\"\(userID)\"", headers:  [:]).responseJSON(completionHandler: {
            response in
            let result = response.result
            
            if let dict = result.value as? JSONStandard {
                print("This is my result: \(dict)")
                
                completed(dict)
            }
            else {
                connectionErrorAlert()
            }
        })
        
    }
    
    
    
    
    
    class func getEstimation(originCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D, completed: @escaping (_ data:Estimation )-> ()) {
        
        //let googleKey = "AIzaSyD2wMrqzjIedeCp04qR5JlbYjDPfkjFlxY"
        let googleKey = "AIzaSyDs5lBK6jGTYCE4Od6-AeW7Syp7BqXb3q0"   // ARESEP
        
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(originCoordinate.latitude),\(originCoordinate.longitude)&destination=\(destinationCoordinate.latitude),\(destinationCoordinate.longitude)&mode=driving&key=\(googleKey)"
        
        Alamofire.request(urlString).responseJSON(completionHandler: {
            response in
            let result = response.result
            print("This is my result: \(result.value!)");
            
            let est = Estimation()
            
            if let dict = result.value as? JSONStandard {
                est.setEstimation(dict)
            }
            
            completed(est)
        })
    }

    /*
    class func getPlaces(text: String, completed: @escaping (_ data:[JSONStandard] )-> ()) {
        
        //let googleKey = "AIzaSyD2wMrqzjIedeCp04qR5JlbYjDPfkjFlxY"
        let googleKey = "AIzaSyDs5lBK6jGTYCE4Od6-AeW7Syp7BqXb3q0"   // ARESEP
        
        let urlString = "https://maps.googleapis.com/maps/api/place/queryautocomplete/json?input=\(text)&components=country:cr&key=\(googleKey)"
        
        
        Alamofire.request(urlString).responseJSON(completionHandler: {
            response in
            let result = response.result
            print("This is my result: \(result.value!)");
            
            var placesArray = [JSONStandard]()
            

            
            if let dict = result.value as? JSONStandard {
                placesArray = dict["predictions"] as! [JSONStandard]
            }
            
            completed(placesArray)
        })
    }
    */
    
    
    
    
    
    class func isReachable() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    
    class func connectionErrorAlert () {
        let alert = UIAlertController(title: "Error", message: "No se pudo establecer conexión con el servidor", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                NotificationCenter.default.post(name: Notification.Name("DismissTaxis"), object: nil)
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


extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}


extension Double
{
    public func formattedSeconds(format:String) -> String {
        
        let date = Date(timeIntervalSince1970: self)
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US")
        formatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let dateString = formatter.string(from: date)
        return dateString
    }
}

extension Date
{
    public func formattedDate(format:String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US")
        let dateString = formatter.string(from: self)
        return dateString
    }
}
