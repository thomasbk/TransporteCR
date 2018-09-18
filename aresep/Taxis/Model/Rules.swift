//
//  Rules.swift
//  GMaps
//
//  Created by Novacomp on 2/12/18.
//  Copyright © 2018 Novacomp. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class Rules: NSObject {
    
    var currentTrip = [Segment]()
    
    var date = Date()
    var totalPrice = 0.0
    var totalPriceRounded = 0
    var traveledDistance = 0.0
    var traveledTime = 0.0
    var tiempoEnEspera = 0.0
    var currentState = "Plana"
    var plate = ""
    var taxiClass = ""
    var baseOperation = ""
    var hasUpdated = false
    
    //var currentCumalative: Int?
    enum State {
        case plana, variable, demora, espera
    }
    enum Class {
        case Sedan, Rural, Adaptado, SedanAeropuerto, MicrobusAeropuerto
    }
    
    
    
    var velocidadFrontera: Double // Velocidad a la que cambia de cobrar por distancia o por tiempo
    var tiempoMinimoEspera: Double
    var unidadMinimaDeMonto: Int // factor de redondeo
    var distanciaInicial: Double
    var tiempoFrontera: Double
    
    var tarifaPlana = 0.0
    var tarifaVariable = 0.0
    var tarifaDemora = 0.0
    var tarifaEspera = 0.0
    
    var tarifaPlanaSedan: Double // costo de primer km
    var tarifaPlanaRural: Double
    var tarifaPlanaAdaptado: Double
    var tarifaPlanaSedanAeropuerto: Double
    var tarifaPlanaMicrobusAeropuerto: Double
    
    var tarifaVariableSedan: Double // costo por km? cuando se va por encima de velocidad frontera
    var tarifaVariableRural: Double
    var tarifaVariableAdaptado: Double
    var tarifaVariableSedanAeropuerto: Double
    var tarifaVariableMicrobusAeropuerto: Double
    
    var tarifaPorDemoraSedan: Double // costo por hora? cuando se va por abajo de velocidad frontera
    var tarifaPorDemoraRural: Double
    var tarifaPorDemoraAdaptado: Double
    var tarifaPorDemoraSedanAeropuerto: Double
    var tarifaPorDemoraMicrobusAeropuerto: Double
    
    var tarifaEsperaSedan: Double // costo por hora? que se está esperando al usuario
    var tarifaEsperaRural: Double
    var tarifaEsperaAdaptado: Double
    var tarifaEsperaSedanAeropuerto: Double
    var tarifaEsperaMicrobusAeropuerto: Double
    
    
    override init() {
        
        self.velocidadFrontera = 10
        self.tiempoMinimoEspera = 60
        self.unidadMinimaDeMonto = 5
        self.distanciaInicial = 1000
        
        self.tiempoFrontera = 3.6 / velocidadFrontera * distanciaInicial // km/h / 3.6 = m/s
        self.taxiClass = ""
        self.baseOperation = ""
        
        self.tarifaPlanaSedan = 660
        self.tarifaPlanaRural = 660
        self.tarifaPlanaAdaptado = 660
        self.tarifaPlanaSedanAeropuerto = 980
        self.tarifaPlanaMicrobusAeropuerto = 980
        
        self.tarifaVariableSedan = 620
        self.tarifaVariableRural = 645
        self.tarifaVariableAdaptado = 590
        self.tarifaVariableSedanAeropuerto = 820
        self.tarifaVariableMicrobusAeropuerto = 935
        
        self.tarifaPorDemoraSedan = 6215
        self.tarifaPorDemoraRural = 6500
        self.tarifaPorDemoraAdaptado = 5940
        self.tarifaPorDemoraSedanAeropuerto = 8125
        self.tarifaPorDemoraMicrobusAeropuerto = 9360
        
        self.tarifaEsperaSedan = 3800
        self.tarifaEsperaRural = 3890
        self.tarifaEsperaAdaptado = 3955
        self.tarifaEsperaSedanAeropuerto = 3825
        self.tarifaEsperaMicrobusAeropuerto = 4390
        
        
        self.totalPrice = tarifaPlanaSedan
        
        super.init()
    }
    
    func reset () {
        currentTrip.removeAll()
        
        totalPrice = tarifaPlanaSedan
        
        totalPriceRounded = 0
        traveledDistance = 0.0
        traveledTime = 0.0
        tiempoEnEspera = 0.0
        currentState = "Plana"
        plate = ""
        taxiClass = ""
        baseOperation = ""
    }
    
    func restart () {
        
        currentTrip.removeAll()
        
        totalPrice = tarifaPlana
        
        totalPriceRounded = 0
        traveledDistance = 0.0
        traveledTime = 0.0
        tiempoEnEspera = 0.0
        //currentState = "Plana"
    }
    
    
    func setTaxiClass (taxiClass: Class) {
        
        switch taxiClass {
            case .Sedan:
                tarifaPlana = tarifaPlanaSedan
                tarifaVariable = tarifaVariableSedan
                tarifaDemora = tarifaPorDemoraSedan
                tarifaEspera = tarifaEsperaSedan
                self.taxiClass = "SEDAN"
                self.baseOperation = "REGULAR"
        case .Rural:
            tarifaPlana = tarifaPlanaRural
            tarifaVariable = tarifaVariableRural
            tarifaDemora = tarifaPorDemoraRural
            tarifaEspera = tarifaEsperaRural
            self.taxiClass = "RURAL"
            self.baseOperation = "REGULAR"
            
        case .Adaptado:
            tarifaPlana = tarifaPlanaAdaptado
            tarifaVariable = tarifaVariableAdaptado
            tarifaDemora = tarifaPorDemoraAdaptado
            tarifaEspera = tarifaEsperaAdaptado
            self.taxiClass = "ADPTDO_DISCAPCIDAD"
            self.baseOperation = "REGULAR"
            
        case .SedanAeropuerto:
            tarifaPlana = tarifaPlanaSedanAeropuerto
            tarifaVariable = tarifaVariableSedanAeropuerto
            tarifaDemora = tarifaPorDemoraSedanAeropuerto
            tarifaEspera = tarifaEsperaSedanAeropuerto
            self.taxiClass = "SEDAN"
            self.baseOperation = "AEROPUERTO"
            
        case .MicrobusAeropuerto:
            tarifaPlana = tarifaPlanaMicrobusAeropuerto
            tarifaVariable = tarifaVariableMicrobusAeropuerto
            tarifaDemora = tarifaPorDemoraMicrobusAeropuerto
            tarifaEspera = tarifaEsperaMicrobusAeropuerto
            self.taxiClass = "MICROBUS"
            self.baseOperation = "AEROPUERTO"
        }
        totalPrice = tarifaPlana
    }
    
    
    
    func setRules (_ json: Dictionary<String, Any>) {
        
        self.hasUpdated = true
        
        self.velocidadFrontera = json["VF"] as! Double
        self.tiempoMinimoEspera = json["TE"] as! Double
        self.unidadMinimaDeMonto = json["UM"] as! Int
        self.distanciaInicial = 1000
        self.taxiClass = ""
        self.tiempoFrontera = 3.6 / velocidadFrontera * distanciaInicial
        
        let fareList = json["TF"] as? [Dictionary<String, Any>]
        
        for tarifa in fareList! {
            
            switch tarifa["CT"] as! String {
            case "T_BANDERAZO":
                if(tarifa["BO"] as! String == "REGULAR" && tarifa["CTV"] as! String == "SEDAN") {
                    self.tarifaPlanaSedan = tarifa["M"] as! Double
                }
                else if(tarifa["BO"] as! String == "REGULAR" && tarifa["CTV"] as! String == "ADPTDO_DISCAPCIDAD") {
                    self.tarifaPlanaAdaptado = tarifa["M"] as! Double
                }
                else if(tarifa["BO"] as! String == "REGULAR" && tarifa["CTV"] as! String == "RURAL") {
                    self.tarifaPlanaRural = tarifa["M"] as! Double
                }
                else if(tarifa["BO"] as! String == "AEROPUERTO" && tarifa["CTV"] as! String == "SEDAN") {
                    self.tarifaPlanaSedanAeropuerto = tarifa["M"] as! Double
                }
                else if(tarifa["BO"] as! String == "AEROPUERTO" && tarifa["CTV"] as! String == "MICROBUS") {
                    self.tarifaPlanaMicrobusAeropuerto = tarifa["M"] as! Double
                }
            case "T_VARIABLE":
                if(tarifa["BO"] as! String == "REGULAR" && tarifa["CTV"] as! String == "SEDAN") {
                    self.tarifaVariableSedan = tarifa["M"] as! Double
                }
                else if(tarifa["BO"] as! String == "REGULAR" && tarifa["CTV"] as! String == "ADPTDO_DISCAPCIDAD") {
                    self.tarifaVariableAdaptado = tarifa["M"] as! Double
                }
                else if(tarifa["BO"] as! String == "REGULAR" && tarifa["CTV"] as! String == "RURAL") {
                    self.tarifaVariableRural = tarifa["M"] as! Double
                }
                else if(tarifa["BO"] as! String == "AEROPUERTO" && tarifa["CTV"] as! String == "SEDAN") {
                    self.tarifaVariableSedanAeropuerto = tarifa["M"] as! Double
                }
                else if(tarifa["BO"] as! String == "AEROPUERTO" && tarifa["CTV"] as! String == "MICROBUS") {
                    self.tarifaVariableMicrobusAeropuerto = tarifa["M"] as! Double
                }
                
            case "T_ESPERA":
                if(tarifa["BO"] as! String == "REGULAR" && tarifa["CTV"] as! String == "SEDAN") {
                    self.tarifaEsperaSedan = tarifa["M"] as! Double
                }
                else if(tarifa["BO"] as! String == "REGULAR" && tarifa["CTV"] as! String == "ADPTDO_DISCAPCIDAD") {
                    self.tarifaEsperaAdaptado = tarifa["M"] as! Double
                }
                else if(tarifa["BO"] as! String == "REGULAR" && tarifa["CTV"] as! String == "RURAL") {
                    self.tarifaEsperaRural = tarifa["M"] as! Double
                }
                else if(tarifa["BO"] as! String == "AEROPUERTO" && tarifa["CTV"] as! String == "SEDAN") {
                    self.tarifaEsperaSedanAeropuerto = tarifa["M"] as! Double
                }
                else if(tarifa["BO"] as! String == "AEROPUERTO" && tarifa["CTV"] as! String == "MICROBUS") {
                    self.tarifaEsperaMicrobusAeropuerto = tarifa["M"] as! Double
                }
            
            case "T_DEMORA":
                if(tarifa["BO"] as! String == "REGULAR" && tarifa["CTV"] as! String == "SEDAN") {
                    self.tarifaPorDemoraSedan = tarifa["M"] as! Double
                }
                else if(tarifa["BO"] as! String == "REGULAR" && tarifa["CTV"] as! String == "ADPTDO_DISCAPCIDAD") {
                    self.tarifaPorDemoraAdaptado = tarifa["M"] as! Double
                }
                else if(tarifa["BO"] as! String == "REGULAR" && tarifa["CTV"] as! String == "RURAL") {
                    self.tarifaPorDemoraRural = tarifa["M"] as! Double
                }
                else if(tarifa["BO"] as! String == "AEROPUERTO" && tarifa["CTV"] as! String == "SEDAN") {
                    self.tarifaPorDemoraSedanAeropuerto = tarifa["M"] as! Double
                }
                else if(tarifa["BO"] as! String == "AEROPUERTO" && tarifa["CTV"] as! String == "MICROBUS") {
                    self.tarifaPorDemoraMicrobusAeropuerto = tarifa["M"] as! Double
                }
                
            default:
                print("none")
            }
        }
        
        
        
        self.totalPrice = tarifaPlanaSedan
        
        totalPriceRounded = 0
        traveledDistance = 0.0
        traveledTime = 0.0
        tiempoEnEspera = 0.0
        currentState = "Plana"
 
    }
    
    
    
    func advance(speed: Double, distance: Double, time: Double, initialLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D) {
        
        traveledDistance += distance
        traveledTime += time
        
        print("distancia Recorrida: \(traveledDistance)")
        print("tiempo Recorrido: \(traveledTime)")
        
        var tb = 0.0
        
        if(traveledDistance < distanciaInicial && traveledTime < tiempoFrontera) { // no aumentar nada en primer km
            currentState = "T_BANDERAZO"
        }
        /////******** Parche para dividir segmento *******//////////
            
        else if(traveledDistance-distance < distanciaInicial && traveledDistance > distanciaInicial && traveledTime-time < tiempoFrontera && traveledTime > tiempoFrontera) { // Segmento cruza por tiempo y por distancia
            
            tb = (traveledTime - time) + (time * ((1 - (traveledDistance - distance)) /  distance))
            // velocidad superior a frontera
            if(speed >= velocidadFrontera) {
                
                var d = 0.0
                
                if(tb <= tiempoFrontera) {
                    d = (traveledDistance) - distanciaInicial
                }
                else {
                    d = distance * ((traveledTime - tiempoFrontera) / time)
                }
                
                let segmentPrice = d * (tarifaVariable/1000)
                totalPrice = totalPrice + segmentPrice
                currentState = "T_VARIABLE"
            }
                // velocidad inferior a frontera
            else {
                var t = 0.0
                
                if(tb <= tiempoFrontera) {
                    t = time * ((traveledDistance - distanciaInicial) / distance)
                }
                else {
                    t = traveledTime - tiempoFrontera
                }
                
                let segmentPrice = t * (tarifaDemora/3600)
                totalPrice = totalPrice + segmentPrice
                currentState = "T_DEMORA"
            }
        }
            // se superó frontera por tiempo
        else if(traveledTime-time < tiempoFrontera &&  traveledTime > tiempoFrontera) {
            // velocidad superior a frontera
            if(speed >= velocidadFrontera) {
                let segmentCharged = (time - (tiempoFrontera - (traveledTime-time))) / time
                let segmentPrice = distance * (tarifaVariable/1000) * segmentCharged
                
                totalPrice = totalPrice + segmentPrice
                currentState = "T_VARIABLE"
            }
                // velocidad inferior a frontera
            else {
                let segmentCharged = (time - (tiempoFrontera - (traveledTime-time))) / time
                let segmentPrice = (tarifaDemora/3600) * segmentCharged
                totalPrice = totalPrice + segmentPrice
                currentState = "T_DEMORA"
            }
        }
            // se superó frontera por distancia
        else if(traveledDistance-distance < distanciaInicial && traveledDistance > distanciaInicial) { //cruza por distancia
            
            // velocidad superior a frontera
            if(speed >= velocidadFrontera) {
                let segmentCharged = (distance - (distanciaInicial - (traveledDistance - distance))) / distance
                let segmentPrice = distance * (tarifaVariable/1000) * segmentCharged
                totalPrice = totalPrice + segmentPrice
                currentState = "T_VARIABLE"
            }
                // velocidad inferior a frontera
            else {
                let segmentCharged = (distance - (distanciaInicial - (traveledDistance - distance))) / distance
                let segmentPrice = (tarifaDemora/3600) * segmentCharged
                totalPrice = totalPrice + segmentPrice
                currentState = "T_DEMORA"
            }
        }
            
        ///////******** FIN Parche para dividir segmento ********////////
            
        else if(speed < 1) {
            tiempoEnEspera += time
            if(tiempoEnEspera > tiempoMinimoEspera) {
                currentState = "T_ESPERA"
                totalPrice += time * (tarifaEspera/3600) // x valor de tiempo elapsado
            }
            else {
                currentState = "T_DEMORA"
                totalPrice += time * (tarifaDemora/3600) // x valor de segundo elapsado
            }
        }
        else if(speed > velocidadFrontera) {
            currentState = "T_VARIABLE"
            totalPrice += distance * (tarifaVariable/1000) // x valor de la distancia recorrida por metro
            
            tiempoEnEspera = 0
        }
        else if(speed <= velocidadFrontera) {
            currentState = "T_DEMORA"
            totalPrice += time * (tarifaDemora/3600) // x valor de segundo elapsado
            
            tiempoEnEspera = 0
        }
        
        //if(((Int(totalPrice) / unidadMinimaDeMonto) * unidadMinimaDeMonto) == Int(totalPrice)) {
        if(totalPrice.truncatingRemainder(dividingBy: Double(unidadMinimaDeMonto)) == 0) {
            totalPriceRounded = Int(totalPrice)
        }
        else {
            totalPriceRounded = ((Int(totalPrice) / unidadMinimaDeMonto) * unidadMinimaDeMonto) + unidadMinimaDeMonto
        }
        
        //for index in 0 ... 100 {
        
        let newSegment = Segment()
        
        newSegment.distance = distance // in m
        newSegment.acumulatedDistance = traveledDistance // in m
        newSegment.time = time // in seconds
        newSegment.acumulatedTime = traveledTime // in seconds
        newSegment.avgSpeed = speed // km/h
        newSegment.initialLatitude = initialLocation.latitude
        newSegment.initialLongitude = initialLocation.longitude
        newSegment.destinationLatitude = endLocation.latitude
        newSegment.destinationLongitude = endLocation.longitude
        
        newSegment.tarifaAplicable = currentState
        newSegment.acumulatedPrice = totalPrice
        
        currentTrip.append(newSegment)
        //}
        
    }
    
    
    
    func save () {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        //let managedContext = appDelegate.persistentContainer.viewContext
        let managedContext = appDelegate.managedObjectContext!
        
        // 2
        let entity = NSEntityDescription.entity(forEntityName: "Trip",
                                       in: managedContext)!
        
        let trip = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // 3
        
        trip.setValue(String(traveledTime), forKeyPath: "time")
        trip.setValue(String(traveledDistance), forKeyPath: "distance")
        trip.setValue(String(totalPriceRounded), forKeyPath: "price")
        trip.setValue(Date(), forKeyPath: "date")

        
        // 4
        do {
            try managedContext.save()
            //trips.append(trip)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    
    func makeEstimation (_ estimation: Estimation) -> Estimation {
        
        let segments = estimation.segments
        var estimatedPrice = 0.0
        let distanciaInicialKM = distanciaInicial / 1000
        let tiempoFronteraH = tiempoFrontera / 3600
        
        var distanceTraveled = 0.0
        var timeTraveled = 0.0
        
        // Caso 1: distancia y tiempo menor a frontera
        if(estimation.time <= tiempoFronteraH && estimation.distance <= distanciaInicialKM) {
            
            for segment in segments {
                currentState = "T_BANDERAZO"
                
                distanceTraveled = distanceTraveled + segment.distance
                timeTraveled = timeTraveled + segment.time
                segment.tarifaAplicable = currentState
                
                segment.acumulatedDistance = distanceTraveled
                segment.acumulatedTime = timeTraveled
                segment.acumulatedPrice = tarifaPlana
            }
            estimatedPrice = tarifaPlana
            
        }
        // Caso 2: distancia menor a frontera
        else if (estimation.distance <= distanciaInicialKM) {
            
            for segment in segments {
                // segmento en que se pasa frontera
                
                if(timeTraveled < tiempoFronteraH && (timeTraveled + segment.time) >= tiempoFronteraH) {
                    // velocidad superior a frontera
                    if(segment.avgSpeed >= velocidadFrontera) {
                        let segmentCharged = (tiempoFronteraH - timeTraveled) / segment.time
                        let segmentPrice = segment.distance * tarifaVariable * segmentCharged
                        estimatedPrice = estimatedPrice + segmentPrice
                        currentState = "T_VARIABLE"
                    }
                    // velocidad inferior a frontera
                    else {
                        let segmentCharged = (tiempoFronteraH - timeTraveled) / segment.time
                        let segmentPrice = tarifaDemora * segmentCharged
                        estimatedPrice = estimatedPrice + segmentPrice
                        currentState = "T_DEMORA"
                    }
                }
                // segmentos luego de frontera
                else if ((timeTraveled + segment.time) > tiempoFronteraH) {
                    // velocidad superior a frontera
                    if(segment.avgSpeed >= velocidadFrontera) {
                        let segmentPrice = segment.distance * tarifaVariable
                        estimatedPrice = estimatedPrice + segmentPrice
                        currentState = "T_VARIABLE"
                    }
                    // velocidad inferior a frontera
                    else {
                        let segmentPrice = tarifaDemora * segment.time
                        estimatedPrice = estimatedPrice + segmentPrice
                        currentState = "T_DEMORA"
                    }
                }
                else { // segmentos previos a frontera
                    
                    currentState = "T_BANDERAZO"
                }
                
                distanceTraveled = distanceTraveled + segment.distance
                timeTraveled = timeTraveled + segment.time
                
                segment.tarifaAplicable = currentState
                
                segment.acumulatedDistance = distanceTraveled
                segment.acumulatedTime = timeTraveled
                segment.acumulatedPrice = estimatedPrice + tarifaPlana
            }
            estimatedPrice = estimatedPrice + tarifaPlana
            
            
        }
        // Caso 3: Distancia > 1km
        else {
            
            for segment in segments {
                
                var segmentoFronteraTiempo = false
                var segmentoFronteraDistancia = false
                
                var tb = 0.0
                
                // Obtener si es segmento en que cruza frontera
                if(timeTraveled < tiempoFronteraH && (timeTraveled + segment.time) >= tiempoFronteraH && distanceTraveled < distanciaInicialKM) {
                    segmentoFronteraTiempo = true
                }
                if(distanceTraveled < distanciaInicialKM && (distanceTraveled + segment.distance) >= distanciaInicialKM && timeTraveled < tiempoFronteraH) {
                    segmentoFronteraDistancia = true
                }
                // segmento se cruza frontera por ambos casos
                if(segmentoFronteraTiempo && segmentoFronteraDistancia) {
                    tb = timeTraveled + (segment.time * ((1 - distanceTraveled) /  segment.distance))
                    
                    // velocidad superior a frontera
                    if(segment.avgSpeed >= velocidadFrontera) {
                        
                        var d = 0.0
                        
                        if(tb <= tiempoFronteraH) {
                            d = (distanceTraveled + segment.distance) - distanciaInicialKM
                        }
                        else {
                            d = segment.distance * ((timeTraveled + segment.time - tiempoFronteraH) / segment.time)
                        }
                        
                        let segmentPrice = d * tarifaVariable
                        estimatedPrice = estimatedPrice + segmentPrice
                        currentState = "T_VARIABLE"
                    }
                    // velocidad inferior a frontera
                    else {
                        var t = 0.0
                        
                        if(tb <= tiempoFronteraH) {
                            t = segment.time * ((distanceTraveled + segment.distance - distanciaInicialKM) / segment.distance)
                        }
                        else {
                            t = (timeTraveled + segment.time) - tiempoFronteraH
                        }
                        
                        let segmentPrice = t * tarifaDemora
                        estimatedPrice = estimatedPrice + segmentPrice
                        currentState = "T_DEMORA"
                    }
                }
                // se superó frontera por tiempo
                else if(segmentoFronteraTiempo) {
                    // velocidad superior a frontera
                    if(segment.avgSpeed >= velocidadFrontera) {
                        let segmentCharged = (segment.time - (tiempoFronteraH - timeTraveled)) / segment.time
                        let segmentPrice = segment.distance * tarifaVariable * segmentCharged
                        estimatedPrice = estimatedPrice + segmentPrice
                        currentState = "T_VARIABLE"
                    }
                    // velocidad inferior a frontera
                    else {
                        let segmentCharged = (segment.time - (tiempoFronteraH - timeTraveled)) / segment.time
                        let segmentPrice = tarifaDemora * segmentCharged
                        estimatedPrice = estimatedPrice + segmentPrice
                        currentState = "T_DEMORA"
                    }
                }
                // se superó frontera por distancia
                else if(segmentoFronteraDistancia) {
                    
                    // velocidad superior a frontera
                    if(segment.avgSpeed >= velocidadFrontera) {
                        //let segmentCharged = (distanciaInicialKM - distanceTraveled) / segment.distance
                        let segmentCharged = (segment.distance - (distanciaInicialKM - distanceTraveled)) / segment.distance
                        let segmentPrice = segment.distance * tarifaVariable * segmentCharged
                        estimatedPrice = estimatedPrice + segmentPrice
                        currentState = "T_VARIABLE"
                    }
                        // velocidad inferior a frontera
                    else {
                        let segmentCharged = (segment.distance - (distanciaInicialKM - distanceTraveled)) / segment.distance
                        let segmentPrice = tarifaDemora * segmentCharged
                        estimatedPrice = estimatedPrice + segmentPrice
                        currentState = "T_DEMORA"
                    }
                }
                // segmentos luego de frontera
                else if ((timeTraveled + segment.time) > tiempoFronteraH || (distanceTraveled + segment.distance) > distanciaInicialKM) {
                    // velocidad superior a frontera
                    if(segment.avgSpeed >= velocidadFrontera) {
                        let segmentPrice = segment.distance * tarifaVariable
                        estimatedPrice = estimatedPrice + segmentPrice
                        currentState = "T_VARIABLE"
                    }
                    // velocidad inferior a frontera
                    else {
                        let segmentPrice = tarifaDemora * segment.time
                        estimatedPrice = estimatedPrice + segmentPrice
                        currentState = "T_DEMORA"
                    }
                }
                else {
                    currentState = "T_BANDERAZO"
                    
                }
                
                distanceTraveled = distanceTraveled + segment.distance
                timeTraveled = timeTraveled + segment.time
                
                segment.tarifaAplicable = currentState
                segment.acumulatedDistance = distanceTraveled
                segment.acumulatedTime = timeTraveled
                segment.acumulatedPrice = estimatedPrice + tarifaPlana
            }
            
            estimatedPrice = estimatedPrice + tarifaPlana
        }
        
        
        estimation.taxiClass = taxiClass
        estimation.baseOperation = baseOperation
        //estimation.totalPrice = (Int(estimatedPrice) / unidadMinimaDeMonto) * unidadMinimaDeMonto
        
        if(estimatedPrice.truncatingRemainder(dividingBy: Double(unidadMinimaDeMonto)) == 0) {
            estimation.totalPrice = Int(estimatedPrice)
        }
        else {
            estimation.totalPrice = ((Int(estimatedPrice) / unidadMinimaDeMonto) * unidadMinimaDeMonto) + unidadMinimaDeMonto
        }
        
        return estimation
        //return estimatedPrice
    }

}
