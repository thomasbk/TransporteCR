//
//  TaxiMapViewController.swift
//  GMaps
//
//  Created by Novacomp on 1/3/18.
//  Copyright © 2018 Novacomp. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces


@objc class TaxiMapViewController: UIViewController,CLLocationManagerDelegate,UITextFieldDelegate {
    
    let mainColor = UIColor(red: 64/255, green: 175/255, blue: 255/255, alpha: 1.0)
    
    var mapView: GMSMapView!
    var markerPartida = GMSMarker()
    let markerDestino = GMSMarker()
    let taxi = Taxi()
    
    
    let locationUpdateFrequency = 1.0
    
    enum Steps {
        case inicio, calcularDestino, calcularPartida, calcularTipo, calcularFin
    }
    
    var currentStep = Steps.inicio
    var needsGPSUpdate = false
    
    var inRoute: Bool = false
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet var speedLabel: UILabel!
    @IBOutlet var stateLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var finishButton: UIButton!
    @IBOutlet var searchText: UITextField!
    @IBOutlet var infoView: UIView!
    @IBOutlet var calculatedLocationLabel: UILabel!
    @IBOutlet var calculatedDistanceLabel: UILabel!
    @IBOutlet var calculatedTimeLabel: UILabel!
    @IBOutlet var taxiPlateLabel: UILabel!
    @IBOutlet var taxiCompanyLabel: UILabel!
    @IBOutlet weak var taxiCompanyImage: UIImageView!
    @IBOutlet var taxiColorLabel: UILabel!
    @IBOutlet weak var taxiColorImage: UIImageView!
    @IBOutlet var taxiTypeLabel: UILabel!
    @IBOutlet weak var taxiTypeImage: UIImageView!
    @IBOutlet var dashboardView: UIView!
    @IBOutlet weak var dashboardRoundView: UIView!
    @IBOutlet weak var tipoTaxiView: UIView!
    @IBOutlet var speedView: UIView!
    @IBOutlet var stopButton: PushButtonView!
    @IBOutlet var centerLocationButton: PushButtonView!
    @IBOutlet weak var cancelarViajeButton: UIButton!
    
    @IBOutlet weak var calcularView: UIView!
    @IBOutlet weak var calcularViajePartidaLabel: UILabel!
    @IBOutlet weak var calcularViajeDestinoLabel: UILabel!
    
    @IBOutlet weak var calcularViajeSiguienteButton: UIButton!
    @IBOutlet weak var calcularViajeAtrasButton: UIButton!
    @IBOutlet weak var iniciarViajeOptionButton: UIButton!
    @IBOutlet weak var calcularTarifaOptionButton: UIButton!
    
    @IBOutlet weak var calcularInfoRoundView: UIView!
    @IBOutlet weak var calcularInfoView: UIView!
    @IBOutlet weak var calcularInfoPrecioLabel: UILabel!
    @IBOutlet weak var calcularInfoDistanciaLabel: UILabel!
    @IBOutlet weak var calcularInfoTiempoLabel: UILabel!
    
    
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    
    
    // variables to keep track of time
    
    weak var locationTimer: Timer?
    weak var timer: Timer?
    var startTime: Double = 0
    var time: Double = 0
    var elapsed: Double = 0
    
    let geoCoder = CLGeocoder()
    var locationManager = CLLocationManager()
    var userLocation:CLLocationCoordinate2D!
    
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var lastTime: Date!
    var startDate: Date!
    var traveledDistance: Double = 0
    var unitDistance: Double = 0
    var unitTime: Double = 0
    
    var myRules = Rules()
    var appData = AppData.sharedInstance
    
    var searchController: SearchViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dbHandler = DBHandler()
        if (!dbHandler.isUserRegistered()) {
            
            performSegue(withIdentifier: "registerSegue", sender: nil)
        }
        
        self.calcularTarifaOptionButton.isHidden = true
        self.iniciarViajeOptionButton.isHidden = true
        
        searchController = storyboard?.instantiateViewController(withIdentifier: "SearchController") as! SearchViewController
        searchController?.delegate = self
        
        searchController.view.isHidden = true
        self.view.addSubview(searchController.view)
        
        if(NetworkHandler.isReachable()) {
            
            Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(showProgress), userInfo: nil, repeats: false)
            
            // Revisa si hay viajes almacenados y los envía
            let savedTrips = DBHandler.loadSavedTripData()
            for trip in savedTrips {
                NetworkHandler.sendSavedTrip(tripData: trip.value(forKey: "tripData") as! String) {  (data) in
                    if let codigo = data["C"] as? String {
                        if(codigo == "00") {
                            DBHandler.deleteSavedTripData(id: trip.value(forKey: "id") as! Int)
                        }
                    }
                }
            }
            
            // Obtener la información de las tarifas actuales
            getFareData()
            
            // Obtener las categorias
            if #available(iOS 9.0, *) {
                getRatingCategories()
            } else {
                // Fallback on earlier versions
            }
            
            
            // Obtener la información general de la aplicación
            //getGeneralInfo()
            // Obtener los tipos de vehiculos
            //getVehiculos()
            
        }
        else {
            self.iniciarViajeOptionButton.isHidden = false
            self.iniciarViajeOptionButton.frame = CGRect(x:0,
                                            y:self.iniciarViajeOptionButton.frame.origin.y,
                                            width:self.view.frame.size.width,
                                        height:self.iniciarViajeOptionButton.frame.size.height)
        }
            
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("DismissTaxis"), object: nil)
        
        dashboardView.dropShadow()
        
        dashboardRoundView.layer.cornerRadius = 10
        dashboardRoundView.layer.borderWidth = 1
        dashboardRoundView.layer.borderColor = UIColor(red: 63/255, green: 179/255, blue: 79/255, alpha: 1.0).cgColor
        
        calcularInfoRoundView.layer.cornerRadius = 10
        calcularInfoRoundView.layer.borderWidth = 1
        calcularInfoRoundView.layer.borderColor = UIColor(red: 63/255, green: 179/255, blue: 79/255, alpha: 1.0).cgColor
        
        dashboardView.isHidden = true
        infoView.isHidden = true
        speedView.layer.cornerRadius = speedView.frame.size.width / 2
        speedView.isHidden = true
        stopButton.isHidden = true
        cancelarViajeButton.isHidden = true
        
        taxiPlateLabel.isHidden = true
        taxiCompanyLabel.isHidden = true
        taxiColorLabel.isHidden = true
        taxiTypeLabel.isHidden = true
        stateLabel.isHidden = true
        
        
        // Do any additional setup after loading the view, typically from a nib.
        let camera = GMSCameraPosition.camera(withLatitude: 9.914005, longitude: -84.029685, zoom: 16.0)
        mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
        view.addSubview(mapView)
        mapView.delegate = self
        let topConst = NSLayoutConstraint(item: mapView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let botConst = NSLayoutConstraint(item: mapView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        let leftConst = NSLayoutConstraint(item: mapView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        let rigthConst = NSLayoutConstraint(item: mapView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([topConst,botConst,leftConst,rigthConst])
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.sendSubview(toBack: mapView)
        
        getLocation()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController) {
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    @objc func canRotate() -> Void {}
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            menuButton.isHidden = true
            print("Landscape")
        } else {
            menuButton.isHidden = false
            print("Portrait")
        }
    }
    
    @objc func showProgress() {
        showProgressIndicator()
    }
    
    
    // servicio de obtener tarifas
    func getFareData() {
        
        self.showProgressIndicator()
        
        NetworkHandler.getFareData() { (data) in
            self.myRules.setRules(data)
            self.appData.lastUpdate = Date()
            
            // Obtener la información general de la aplicación
            self.getGeneralInfo()
        }
    }
    
    // servicio de obtener tipos de vehiculos
    func getVehiculos() {
        NetworkHandler.getVehiculos() { (data) in
            
        }
    }
    
    
    // Obtener la información general de la aplicación
    func getGeneralInfo() {
        
        self.showProgressIndicator()
        NetworkHandler.getGeneralInfo() { (data) in
            self.appData.setData(data)
            
            self.calcularTarifaOptionButton.isHidden = true
            self.iniciarViajeOptionButton.isHidden = true
            
            if(!self.appData.showViajeCalculado) {
                self.calcularTarifaOptionButton.isHidden = true
                self.iniciarViajeOptionButton.isHidden = false
                self.iniciarViajeOptionButton.frame = CGRect(x:0,
                                        y:self.iniciarViajeOptionButton.frame.origin.y,
                                        width:self.view.frame.size.width,
                                        height:self.iniciarViajeOptionButton.frame.size.height)
            }
            else {
                self.calcularTarifaOptionButton.isHidden = false
                self.iniciarViajeOptionButton.isHidden = false
            }
            self.hideProgressIndicator()
            
        }
    }
    
    // servicio de obtner información de un taxi
    func getTaxiInfo(taxi:String) {
        
        self.showProgressIndicator()
        NetworkHandler.getTaxiInfo(taxi: taxi) { (data)  in
            
            self.hideProgressIndicator()
            
            if(data["BO"] as! String == "REGULAR" || data["BO"] as! String == "AEROPUERTO") { // SI se obtuvo información del taxi y se salta la opcion de elegir tipo de taxi
                
                self.tipoTaxiView.isHidden = true
                self.infoView.isHidden = false
                
                if(data["BO"] as! String == "REGULAR" && data["CTV"] as! String == "SEDAN") {
                    self.myRules.setTaxiClass(taxiClass: .Sedan)
                    self.taxi.color = "Taxi Rojo"
                    self.taxi.tipo = "Sedán"
                    self.taxi.compania = "No disponible"
                }
                else if(data["BO"] as! String == "REGULAR" && data["CTV"] as! String == "RURAL") {
                    self.myRules.setTaxiClass(taxiClass: .Rural)
                    self.taxi.color = "Taxi Rojo"
                    self.taxi.tipo = "Rural"
                    self.taxi.compania = "No disponible"
                }
                else if(data["BO"] as! String == "REGULAR" && data["CTV"] as! String == "ADPTDO_DISCAPCIDAD") {
                    self.myRules.setTaxiClass(taxiClass: .Adaptado)
                    self.taxi.color = "Taxi Rojo"
                    self.taxi.tipo = "Vehículo Adaptado"
                    self.taxi.compania = "No disponible"
                }
                else if(data["BO"] as! String == "AEROPUERTO" && data["CTV"] as! String == "SEDAN") {
                    self.myRules.setTaxiClass(taxiClass: .SedanAeropuerto)
                    self.taxi.color = "Aeropuerto"
                    self.taxi.tipo = "Sedán"
                    self.taxi.compania = "No disponible"
                }
                else if(data["BO"] as! String == "AEROPUERTO" && data["CTV"] as! String == "MICROBUS") {
                    self.myRules.setTaxiClass(taxiClass: .MicrobusAeropuerto)
                    self.taxi.color = "Aeropuerto"
                    self.taxi.tipo = "Microbús"
                    self.taxi.compania = "No disponible"
                }
                else {
                    self.myRules.setTaxiClass(taxiClass: .Sedan)
                    self.taxi.color = "Taxi Rojo"
                    self.taxi.tipo = "Sedán"
                    self.taxi.compania = "No disponible"
                }
                
                self.taxiCompanyLabel.text = data["NC"] as? String
                self.taxiColorLabel.text = self.taxi.color
                self.taxiColorImage.image = self.taxi.color == "Taxi Rojo" ? UIImage(named: "sedanRojo") : UIImage(named: "sedanAeropuerto")
                self.taxiTypeLabel.text = self.taxi.tipo
                
                switch (self.taxi.tipo) {
                    case "Sedán":
                        self.taxiTypeImage.image = UIImage(named: "sedanGris")
                    case "Microbús":
                        self.taxiTypeImage.image = UIImage(named: "microbusGris")
                    case "Rural":
                        self.taxiTypeImage.image = UIImage(named: "ruralGris")
                    case "Vehículo Adaptado":
                        self.taxiTypeImage.image = UIImage(named: "discapacitadosGris")
                    default:
                        self.taxiTypeImage.image = UIImage(named: "sedanGris")
                }
                
                
            }
            else { // NO obtuvo información del taxi
                
                self.tipoTaxiView.isHidden = false
                
                for index in 11 ... 15 {
                    let tmpButton = self.view.viewWithTag(index) as? UIButton
                    tmpButton?.layer.borderColor = UIColor.clear.cgColor
                }
            
            }
        }
    }
    
    // servicio de obtener categorias de clasificación
    @available(iOS 9.0, *)
    func getRatingCategories() {
        NetworkHandler.getRatingCategories() { (data)  in
            //self.myRules.setRules(data)
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            
            //let managedContext = appDelegate.persistentContainer.viewContext
            let managedContext = appDelegate.managedObjectContext!
            
            let entity = NSEntityDescription.entity(forEntityName: "Rating", in: managedContext)!
            
            let list = data["RO"] as? [Dictionary<String, Any>]
            
            // Remove all old elements
            if(list!.count > 0) {
                
                let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Rating")

                let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

                do {
                    try managedContext.execute(deleteRequest)
                    try managedContext.save()
                } catch {
                    print ("There was an error")
                }
            }
            
            for rate in list! {
                
                let rating = NSManagedObject(entity: entity,insertInto: managedContext)
            
                rating.setValue(rate["Id"], forKeyPath: "id")
                rating.setValue(rate["D"], forKeyPath: "category")
                rating.setValue(0, forKeyPath: "value")
            
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    
    
    // centrar mapa en ubicación actual
    @IBAction func centerLocation (_ sender: UIButton!) {
        
        // Check internet connection
        if(NetworkHandler.isReachable() && (userLocation != nil)) {
            
            // Check GPS access
            if CLLocationManager.locationServicesEnabled() && (CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
        
                let mapLocation = GMSCameraPosition.camera(withLatitude: userLocation.latitude, longitude: userLocation.longitude, zoom: 15.0)
                self.mapView.animate(to: mapLocation)
            }
            else {
                showMessage(title: "Servicios de localización", message: "Es necesario que habilite los servicios de localización para utilizar la aplicación.")
            }
        }
        else {
            showMessage(title: "Conexión a internet", message: "Es necesario el acceso a internet para utilizar la aplicación")
        }
    }
    
    @IBAction func cancelarViaje(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Reiniciar el viaje", message: "¿Desea reiniciar el viaje?", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Aceptar", style: .default, handler: {
            alert -> Void in
            
            self.inRoute = false
            self.myRules.restart()
            self.startDrive(nil)
            self.mapView.clear()
            let roundedDistance = 0.0
            self.distanceLabel.text = "\(roundedDistance.stringFormattedValue()) Km"
        })
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        alertController.view.tintColor = mainColor
    }
    
    // Seleccionado opción de iniciar viaje en tiempo real
    @IBAction func iniciarViajeSelected(_ sender: Any) {
        
        // Check internet connection
        if(NetworkHandler.isReachable() && myRules.hasUpdated) {
            
            // Check GPS access
            if CLLocationManager.locationServicesEnabled() && (CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
        
                myRules.reset()
                iniciarViajeOptionButton.isHidden = true
                calcularTarifaOptionButton.isHidden = true
                
                let alertController = UIAlertController(title: "Ingrese la placa del taxi", message: "", preferredStyle: .alert)
                
                let saveAction = UIAlertAction(title: "Aceptar", style: .default, handler: {
                    alert -> Void in
                    
                    let firstTextField = alertController.textFields![0] as UITextField
                    self.taxiPlateLabel.text = firstTextField.text
                    self.taxiPlateLabel.isHidden = false
                    self.taxiCompanyLabel.isHidden = false
                    self.taxiColorLabel.isHidden = false
                    self.taxiTypeLabel.isHidden = false
                    self.myRules.plate = firstTextField.text!
                    
                    self.getTaxiInfo(taxi: firstTextField.text!)
                })
                
                let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: {
                    (action : UIAlertAction!) -> Void in
                    
                    
                    self.iniciarViajeOptionButton.isHidden = false
                    self.calcularTarifaOptionButton.isHidden = false
                    
                })
                
                alertController.addTextField { (textField : UITextField!) -> Void in
                    textField.placeholder = "Placa del taxi"
                    // Observe the UITextFieldTextDidChange notification to be notified in the below block when text is changed
                    NotificationCenter.default.addObserver(forName: .UITextFieldTextDidChange, object: textField, queue: OperationQueue.main, using:
                        {_ in
                            
                            let textCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                            let textIsNotEmpty = textCount > 0
                            
                            textField.text = textField.text?.uppercased()
                            
                            saveAction.isEnabled = textIsNotEmpty
                            
                            if((textField.text?.count)! > 10) {
                                let mySubstring = textField.text?.prefix(10) 
                                textField.text = String(mySubstring!)
                            }
                            
                            if textField.text!.count > 0 {
                                let allowedCharacters = CharacterSet.alphanumerics.inverted
                                
                                textField.text = textField.text!.trimmingCharacters(in: allowedCharacters)
                            }
                    })
                }
                saveAction.isEnabled = false
                alertController.addAction(saveAction)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
                
                alertController.view.tintColor = mainColor
            }
            else {
                showMessage(title: "Servicios de localización", message: "Es necesario que habilite los servicios de localización para utilizar la aplicación.")
            }
        }
        else {
            if(!NetworkHandler.isReachable()) {
                showMessage(title: "Conexión a internet", message: "Es necesario el acceso a internet para utilizar la aplicación")
            }
            else {
                showMessage(title: "Alerta", message: "La no se pudo actualizar los datos. Debe salir del módulo de taxis y volver a intentarlo")
                
            }
        }
    }
    
    
    
    
    // Seleccionado opción de calcular viaje
    @IBAction func calcularTarifaSelected(_ sender: Any) {
        
        myRules.reset()
        
        iniciarViajeOptionButton.isHidden = true
        calcularTarifaOptionButton.isHidden = true
        calcularView.isHidden = false
        destinationLabel.font = UIFont.boldSystemFont(ofSize: destinationLabel.font.pointSize)
        originLabel.font = UIFont.systemFont(ofSize: originLabel.font.pointSize)
        
        searchText.isHidden = false
        searchText.text = ""
        searchText.placeholder = "Destino"
        searchButton.isHidden = false
        
        calcularViajeSiguienteButton.isEnabled = false
        
        centerLocationButton.isHidden = false
        centerLocationButton.frame = CGRect(x: centerLocationButton.frame.origin.x,
                                    y:calcularView.frame.origin.y-centerLocationButton.frame.size.height-15,
                                    width:centerLocationButton.frame.size.width,
                                    height:centerLocationButton.frame.size.height)
        
        
        currentStep = .calcularDestino
    }
    
    
    // Seleccionado botón de siguiente en seccion de Calcular Viaje
    @IBAction func calcularViajeSiguienteAction(_ sender: Any) {
        
        if(currentStep == .calcularDestino) {
            currentStep = .calcularPartida
            
            searchText.text = ""
            searchText.placeholder = "Punto de partida"
            calcularViajeAtrasButton.setTitle("ATRAS", for: .normal)
            
            destinationLabel.font = UIFont.systemFont(ofSize: destinationLabel.font.pointSize)
            originLabel.font = UIFont.boldSystemFont(ofSize: originLabel.font.pointSize)
        }
        else if(currentStep == .calcularPartida) {
            currentStep = .calcularTipo
            
            calcularViajeSiguienteButton.setTitle("CALCULAR", for: .normal)
            
            searchText.isHidden = true
            searchButton.isHidden = true
            
            calcularView.frame = CGRect(x: calcularView.frame.origin.x,
                                         y:calcularView.frame.origin.y-tipoTaxiView.frame.size.height,
                                         width:calcularView.frame.size.width,
                                         height:calcularView.frame.size.height)
            
            centerLocationButton.frame = CGRect(x: centerLocationButton.frame.origin.x,
                                                y:calcularView.frame.origin.y-centerLocationButton.frame.size.height-15,
                                                width:centerLocationButton.frame.size.width,
                                                height:centerLocationButton.frame.size.height)
            
            calcularViajeSiguienteButton.isEnabled = false
            tipoTaxiView.isHidden = false
            
            for index in 11 ... 15 {
                let tmpButton = self.view.viewWithTag(index) as? UIButton
                tmpButton?.layer.borderColor = UIColor.clear.cgColor
            }
        }
        else if(currentStep == .calcularTipo) {
            currentStep = .calcularFin
            
            calcularView.frame = CGRect(x: calcularView.frame.origin.x,
                                        y:calcularView.frame.origin.y+tipoTaxiView.frame.size.height,
                                        width:calcularView.frame.size.width,
                                        height:calcularView.frame.size.height)
            
            
            tipoTaxiView.isHidden = true
            
            calcularViajeSiguienteButton.setTitle("SIGUIENTE", for: .normal)
            
            getRoute()
        }
    }
    
    // Seleccionado botón de Cancelar en seccion de Calcular Viaje
    @IBAction func calcularViajeCancelarAction(_ sender: Any) {
        
        if(currentStep == .calcularDestino) {
            searchText.isHidden = true
            searchButton.isHidden = true
            calcularView.isHidden = true
            
            iniciarViajeOptionButton.isHidden = false
            calcularTarifaOptionButton.isHidden = false
            
            centerLocationButton.isHidden = true
            
            currentStep = .inicio
            
            markerDestino.map = nil
            
            getLocation()
        }
        else if(currentStep == .calcularPartida) {
            
            currentStep = .calcularDestino
            calcularViajeAtrasButton.setTitle("CANCELAR", for: .normal)
            
            searchText.text = ""
            searchText.placeholder = "Destino"
            
            markerPartida.map = nil
            
            destinationLabel.font = UIFont.boldSystemFont(ofSize: destinationLabel.font.pointSize)
            originLabel.font = UIFont.systemFont(ofSize: originLabel.font.pointSize)
        }
        else if(currentStep == .calcularTipo) {
            
            currentStep = .calcularPartida
            
            searchText.text = ""
            searchText.placeholder = "Punto de partida"
            
            //markerPartida.map = nil
            
            destinationLabel.font = UIFont.systemFont(ofSize: destinationLabel.font.pointSize)
            originLabel.font = UIFont.boldSystemFont(ofSize: originLabel.font.pointSize)
            
            searchText.isHidden = false
            searchButton.isHidden = false
            
            calcularViajeSiguienteButton.setTitle("SIGUIENTE", for: .normal)
            calcularViajeSiguienteButton.isEnabled = true
            
            calcularView.frame = CGRect(x: calcularView.frame.origin.x,
                                        y:calcularView.frame.origin.y+tipoTaxiView.frame.size.height,
                                        width:calcularView.frame.size.width,
                                        height:calcularView.frame.size.height)
            
            centerLocationButton.frame = CGRect(x: centerLocationButton.frame.origin.x,
                                                y:calcularView.frame.origin.y-centerLocationButton.frame.size.height-15,
                                                width:centerLocationButton.frame.size.width,
                                                height:centerLocationButton.frame.size.height)
            
            tipoTaxiView.isHidden = true
        }
    }
    
    
    // Seleccionado botón de Aceptar luego de Calcular Viaje
    @IBAction func calcularViajeFinalizarAction(_ sender: Any) {
        calcularInfoView.isHidden = true
        calcularView.isHidden = true
        
        iniciarViajeOptionButton.isHidden = false
        calcularTarifaOptionButton.isHidden = false
        
        mapView.clear()
        markerDestino.position = CLLocationCoordinate2D.init()
        //markerPartida.position = CLLocationCoordinate2D.init()
        markerPartida = GMSMarker()
        
        calcularViajeDestinoLabel.text = ""
        calcularViajePartidaLabel.text = "Ubicación actual"
        
        centerLocationButton.isHidden = true
        
        currentStep = .inicio
        
        getLocation()
    }
    
    
    // seleccionado un tipo de vehiculo
    @IBAction func setTaxiType(_ sender: Any) {
        let button = sender as? UIButton
        let tag = button?.tag
        
        switch(tag) {
        case 11:
            myRules.setTaxiClass(taxiClass: .Sedan)
            taxi.color = "Taxi Rojo"
            taxi.tipo = "Sedán"
            taxi.compania = "No disponible"
        case 12:
            myRules.setTaxiClass(taxiClass: .Rural)
            taxi.color = "Taxi Rojo"
            taxi.tipo = "Rural"
            taxi.compania = "No disponible"
        case 13:
            myRules.setTaxiClass(taxiClass: .Adaptado)
            taxi.color = "Taxi Rojo"
            taxi.tipo = "Vehículo Adaptado"
            taxi.compania = "No disponible"
        case 14:
            myRules.setTaxiClass(taxiClass: .SedanAeropuerto)
            taxi.color = "Aeropuerto"
            taxi.tipo = "Sedán"
            taxi.compania = "No disponible"
        case 15:
            myRules.setTaxiClass(taxiClass: .MicrobusAeropuerto)
            taxi.color = "Aeropuerto"
            taxi.tipo = "Microbús"
            taxi.compania = "No disponible"
        default:
            myRules.setTaxiClass(taxiClass: .Sedan)
            taxi.color = "Taxi Rojo"
            taxi.tipo = "Sedán"
            taxi.compania = "No disponible"
        }
        
        if(currentStep == .calcularTipo) {
            
            calcularViajeSiguienteButton.isEnabled = true
            
            //button?.backgroundColor = UIColor.lightGray
            button?.layer.cornerRadius = 5
            button?.layer.borderWidth = 2
            
            button?.layer.borderColor = (button?.tag)! <= 13 ? UIColor(red: 192/255, green: 39/255, blue: 45/255, alpha: 1.0).cgColor : UIColor(red: 252/255, green: 103/255, blue: 34/255, alpha: 1.0).cgColor
        }
        else {
            tipoTaxiView.isHidden = true
            infoView.isHidden = false
            
            taxiCompanyLabel.text = taxi.compania
            //taxiCompanyImage.image =
            taxiColorLabel.text = taxi.color
            taxiColorImage.image = taxi.color == "Taxi Rojo" ? UIImage(named: "sedanRojo") : UIImage(named: "sedanAeropuerto")
            taxiTypeLabel.text = taxi.tipo
            
            switch (taxi.tipo) {
            case "Sedán":
                taxiTypeImage.image = UIImage(named: "sedanGris")
            case "Microbús":
                taxiTypeImage.image = UIImage(named: "microbusGris")
            case "Rural":
                taxiTypeImage.image = UIImage(named: "ruralGris")
            case "Vehículo Adaptado":
                taxiTypeImage.image = UIImage(named: "discapacitadosGris")
            default:
                taxiTypeImage.image = UIImage(named: "sedanGris")
            }
            
        }
        
    }
    
    
    @IBAction func startDrive (_ sender: UIButton!) {
        
        // If button status is true use stop function, relabel button and enable reset button
        if (inRoute) {
            stop()
            //sender.setTitle("START", for: .normal)
            //resetBtn.isEnabled = true
            finishDrive()
            
            // If button status is false use start function, relabel button and disable reset button
        } else {
            
            if(taxiPlateLabel.text != "") {
                
                UIApplication.shared.isIdleTimerDisabled = true
                
                // Set an accuracy level. The higher, the better for energy.
                //locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                
                // Enable automatic pausing
                //locationManager.pausesLocationUpdatesAutomatically = true
                // Specify the type of activity your app is currently performing
                locationManager.activityType = CLActivityType.automotiveNavigation
                
                
                locationManager.startUpdatingLocation()
                
                /* Use Timer for GPS Update
                if #available(iOS 9.0, *) {
                    //getMyLocationInterval()
                    locationManager.startUpdatingLocation()
                    locationTimer = Timer.scheduledTimer(timeInterval: locationUpdateFrequency, target: self, selector: #selector(getMyLocationInterval), userInfo: nil, repeats: true)
                } else {
                    // Fallback on earlier versions
                    locationManager.startUpdatingLocation()
                }
                 */
                
                self.start()
                dashboardView.isHidden = false
                infoView.isHidden = true
                speedView.isHidden = false
                stopButton.isHidden = false
                cancelarViajeButton.isHidden = false
                centerLocationButton.isHidden = false
                centerLocationButton.frame = CGRect(x: centerLocationButton.frame.origin.x,
                                                    y:view.frame.height-centerLocationButton.frame.size.height-20,
                                                    width:centerLocationButton.frame.size.width,
                                                    height:centerLocationButton.frame.size.height)
            }
        }
        
    }
    
    @objc func getMyLocationInterval () {
        
        locationManager.startUpdatingLocation()
        if #available(iOS 9.0, *) {
            //locationManager.requestLocation()
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    
    
    @IBAction func cancelDrive(_ sender: Any) {
        
        iniciarViajeOptionButton.isHidden = false
        calcularTarifaOptionButton.isHidden = false
        infoView.isHidden = true
        centerLocationButton.isHidden = true
        
        mapView.clear()
    }
    
    
    
    
    // Seleccionado finalizar viaje
    @IBAction func finishDrive () {
        
        let alert = UIAlertController(title: "Finalizar el viaje", message: "¿Desea finalizar el viaje?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
            
        
        UIApplication.shared.isIdleTimerDisabled = false
        self.needsGPSUpdate = true
        
        self.locationManager.stopUpdatingLocation()
        
        self.myRules.save()
        
        self.searchText.isHidden = true
        self.searchButton.isHidden = true
        self.stopButton.isHidden = true
        self.cancelarViajeButton.isHidden = true
        self.speedView.isHidden = true
        self.dashboardView.isHidden = true
        self.centerLocationButton.isHidden = false
        self.centerLocationButton.frame = CGRect(x: self.centerLocationButton.frame.origin.x,
                                            y:self.iniciarViajeOptionButton.frame.origin.y-self.centerLocationButton.frame.size.height-8,
                                            width:self.centerLocationButton.frame.size.width,
                                            height:self.centerLocationButton.frame.size.height)
        
        self.iniciarViajeOptionButton.isHidden = false
        self.calcularTarifaOptionButton.isHidden = false
        self.infoView.isHidden = true
        
        if(self.inRoute) {
            //removed for prototype
            self.performSegue(withIdentifier: "ratingSegue", sender: nil)
            self.inRoute = false
        }
        self.stop()
        
        self.mapView.clear()
                
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }}))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: { action in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.destination {
            
        case let viewController1 as RatingViewController:
            viewController1.myRules = myRules
        default:
            break
        }
    }
    
    
    
    @objc func methodOfReceivedNotification(notification: Notification){
        
        let navController = self.navigationController
        navController!.dismiss(animated: true, completion: nil)
    }
    
    
    // Delegate selected
    func setSearchDestination(location: CLLocation) {
        
        let address = searchText.text!
        
        let marker = self.currentStep == .calcularDestino ? self.markerDestino : self.markerPartida
        let markerImage = self.currentStep == .calcularDestino ? UIImage(named: "destino") : UIImage(named: "punto_partida")
        
        //let location = placeMark.location!
        
        marker.position = location.coordinate
        marker.title = "Destino"
        marker.snippet = ""
        marker.map = self.mapView
        marker.iconView = UIImageView(image: markerImage)
        
        let mapLocation = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15.0)
        self.mapView.animate(to: mapLocation)
        
        
        self.searchText.text = ""
        if(self.currentStep == .calcularPartida) {
            self.calcularViajePartidaLabel.text = address
        }
        else if(self.currentStep == .calcularDestino) {
            self.calcularViajeDestinoLabel.text = address
            self.calcularViajeSiguienteButton.isEnabled = true
        }
        
        searchController.view.isHidden = true
    }
    
    
    @IBAction func getCoordinates () {
        
        searchText.resignFirstResponder()
        let address = "\(searchText.text!)"
        
        showProgressIndicator()
        
        let placesClient = GMSPlacesClient.shared()
        
        let filter = GMSAutocompleteFilter()
        //filter.type = .establishment
        filter.country = "CR"
        placesClient.autocompleteQuery(address, bounds: nil, filter: filter, callback: {(results, error) -> Void in
            
            self.hideProgressIndicator()
            
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
            
            if let results = results {
                if(results.count > 0) {
                    self.searchController.setData(locations: results)
                    self.searchController.view.isHidden = false
                }
            }
            else {
                self.showMessage(title: "Alerta", message: "No se encontró ninguna ubicación")
            }
            
        })
    
    }
    
    
    
    
    func getLocation () {
        //First get current location, then get cities list.
        
        if (NetworkHandler.isReachable()) {
            
            // Ask for Authorization from the User.
            self.locationManager.requestAlwaysAuthorization()
            
            // For use in foreground
            //self.locationManager.requestWhenInUseAuthorization()
            
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                //locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
                locationManager.startUpdatingLocation()
                
                if #available(iOS 9.0, *) {
                    locationManager.allowsBackgroundLocationUpdates = true
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        else { // Cant connect to internet
            
            //guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            //    return
            //}
            
            //refresher.endRefreshing()
        }
    }
    
    
    
    
    @IBAction func resetBtn(_ sender: Any) {
        
        // Invalidate timer
        timer?.invalidate()
        
        // Reset timer variables
        startTime = 0
        time = 0
        elapsed = 0
        //status = false
        
    }
    
    
    
    func start() {
        
        startTime = Date().timeIntervalSinceReferenceDate - elapsed
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        // Set Start/Stop button to true
        inRoute = true
        
    }
    
    
    
    func stop() {
        traveledDistance = 0
        time = 0
        elapsed = 0
        startDate = nil
        startLocation = nil
        //startTime = 0
        //elapsed = Date().timeIntervalSinceReferenceDate - startTime
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
        locationManager = CLLocationManager()
        getLocation()
        
        locationTimer?.invalidate()
        
        // Set Start/Stop button to false
        inRoute = false
        
        let location = GMSCameraPosition.camera(withLatitude: userLocation.latitude, longitude: userLocation.longitude, zoom: mapView.camera.zoom, bearing: 0, viewingAngle: mapView.camera.viewingAngle)
        mapView.animate(to: location)
    }
    
    
    
    @objc func updateCounter() {
        
        // Calculate total time since timer started in seconds
        time = Date().timeIntervalSinceReferenceDate - startTime
        
        // Calculate minutes
        let minutes = UInt8(time / 60.0)
        time -= (TimeInterval(minutes) * 60)
        
        // Calculate seconds
        let seconds = UInt8(time)
        time -= TimeInterval(seconds)
        
        // Format time vars with leading zero
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        // Add time vars to relevant labels
        timeLabel.text = "\(strMinutes):\(strSeconds)"
        
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if(needsGPSUpdate) {
            needsGPSUpdate = false
            return
        }
        
        userLocation = manager.location!.coordinate
        
        print("locations = \(userLocation.latitude) \(userLocation.longitude)")
        print("accuracy = \(manager.location!.horizontalAccuracy)")
        //print("location age:",  locations.last?.timestamp.timeIntervalSinceNow as Any)
        
        var cameraZoom: Float
        
        if(!inRoute) {
            locationManager.stopUpdatingLocation()
            
            mapView.isMyLocationEnabled = true
            
            cameraZoom = 15
            
            // center map on location
            let location = GMSCameraPosition.camera(withLatitude: userLocation.latitude, longitude: userLocation.longitude, zoom: cameraZoom)
            mapView.animate(to: location)
        }
        else {
            
            cameraZoom = mapView.camera.zoom
            
            if startDate == nil {
                startDate = Date()
                lastTime = startDate
                myRules.date = startDate
            } else {
                print("elapsedTime:", String(format: "%.0fs", Date().timeIntervalSince(startDate)))
                
                unitTime = Date().timeIntervalSince(lastTime)
                print("Unit Time:",  unitTime)
                lastTime = Date()
            }
            if startLocation == nil {
                startLocation = locations.first
                lastLocation = locations.first
            } else if let location = locations.last {
                unitDistance = lastLocation.distance(from: location)
                print("Unit Distance:",  unitDistance)
                traveledDistance += lastLocation.distance(from: location)
                print("Traveled Distance:",  traveledDistance)
                print("Straight Distance:", startLocation.distance(from: locations.last!))
            }
            
            
            var speed: CLLocationSpeed = CLLocationSpeed()
            speed = (locationManager.location?.speed)!
            speed = speed * 3.6
            speed = speed < 0 ? 0 : round(speed)
            speedLabel.text = "\(speed.cleanValue)"
            
            
            var segmentSpeed = 0.0
            if(unitTime > 0) {
                segmentSpeed = (unitDistance / unitTime) * 3.6
            }
            
            
            print("Speed:", speed);
            
            var endLocation = CLLocationCoordinate2D()
            
            if let location = locations.last {
                endLocation = location.coordinate
            }
            
            myRules.advance(speed: segmentSpeed, distance: unitDistance, time: unitTime, initialLocation: startLocation.coordinate, endLocation:endLocation)
            
            stateLabel.text = myRules.currentState
            let roundedDistance = Double(round(100 * (myRules.traveledDistance/100))/1000)
            distanceLabel.text = "\(roundedDistance.stringFormattedValue()) Km"
            
            
            let currencyFormatter = NumberFormatter()
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = .currency
            // localize to your grouping and decimal separator
            currencyFormatter.locale = Locale(identifier: "es_CR")
            currencyFormatter.currencySymbol = "₡"
            currencyFormatter.maximumFractionDigits = 0
            
            let priceString = currencyFormatter.string(from: myRules.totalPriceRounded as NSNumber)!
            priceLabel.text = priceString
            //priceLabel.text = "₡\(myRules.totalPriceRounded)"
            
            
            // center map on location
            let location = GMSCameraPosition.camera(withLatitude: userLocation.latitude, longitude: userLocation.longitude, zoom: mapView.camera.zoom, bearing: manager.location!.course, viewingAngle: mapView.camera.viewingAngle)
            
            mapView.animate(to: location)
            
            
            //draw route
            if startLocation == nil {
                startLocation = locations.first
            } else if let location = locations.last, let lastLoc = lastLocation {
                let path = GMSMutablePath()
                path.add(CLLocationCoordinate2D(latitude: lastLoc.coordinate.latitude, longitude: lastLoc.coordinate.longitude))
                path.add(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
                let polyline = GMSPolyline(path: path)
                
                if( speed >= 3) {
                    polyline.strokeColor = UIColor(red: 63/255, green: 179/255, blue: 79/255, alpha: 1.0)
                }
                else if( speed < 3) {
                    polyline.strokeColor = UIColor(red: 192/255, green: 39/255, blue: 45/255, alpha: 1.0)
                }
                polyline.strokeWidth = 8.0
                polyline.map = mapView
            }
            
            
            lastLocation = locations.last
            
        }
        
        //locationManager.stopUpdatingLocation() //Add to use location timer
        
    }
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        let alert = UIAlertController(title: "Alerta", message: "Habilitar servicio de ubicación para poder obtener su ubicación actual.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
        
        if presentedViewController == nil {
            //self.present(alert, animated: true, completion: updateUI)
        }
    }
    
    
    
    func getRoute() {
        
        let originPoint = CLLocationCoordinate2DIsValid(markerPartida.position) ? markerPartida.position : userLocation
        
        self.showProgressIndicator(withText: "Calculando ruta", andDescription: "")
        
        NetworkHandler.getEstimation(originCoordinate: originPoint!, destinationCoordinate:markerDestino.position) { (data) in
            
            self.hideProgressIndicator()
            
            
            if(data.distanceString == nil || data.distanceString == "") {
                self.calcularInfoDistanciaLabel.text = "-"
                self.calcularInfoTiempoLabel.text = "-"
                self.calcularInfoPrecioLabel.text = "-"
            }
            else {
                // set data in labels
                self.calcularInfoDistanciaLabel.text = data.distanceString
                self.calcularInfoTiempoLabel.text = data.timeString
                
                let currencyFormatter = NumberFormatter()
                currencyFormatter.usesGroupingSeparator = true
                currencyFormatter.numberStyle = .currency
                // localize to your grouping and decimal separator
                currencyFormatter.locale = Locale(identifier: "es_CR")
                currencyFormatter.currencySymbol = "₡"
                currencyFormatter.maximumFractionDigits = 0
                
                let priceString = currencyFormatter.string(from: Int(self.myRules.makeEstimation(data).totalPrice) as NSNumber)!
                
                self.calcularInfoPrecioLabel.text = priceString
                
                //self.calcularInfoPrecioLabel.text = "₡\(self.myRules.makeEstimation(data).totalPrice)"
                
                
                // draw lines
                 
                 //for route in data.segments
                 //{
                let points = data.points
                let path = GMSPath.init(fromEncodedPath: points!)
                 
                let polyline = GMSPolyline(path: path)
                polyline.strokeColor = UIColor(red: 21/255, green: 136/255, blue: 218/255, alpha: 1.0)
                polyline.strokeWidth = 8.0
                polyline.map = self.mapView
                 
                 //}
                
                
                NetworkHandler.sendEstimation(tripData:data) { (data) in
                    
                    print(data)
                }
            }
            
            self.calcularInfoView.isHidden = false
            self.tipoTaxiView.isHidden = true
            
            self.centerLocationButton.frame = CGRect(x: self.centerLocationButton.frame.origin.x,
                                                y:self.calcularInfoView.frame.origin.y-self.centerLocationButton.frame.size.height-15,
                                                width:self.centerLocationButton.frame.size.width,
                                                height:self.centerLocationButton.frame.size.height)
            
            // show view animated
            /*let duration: TimeInterval = 0.5
            UIView.animate(withDuration: duration, animations: { () -> Void in
             
                
            })*/
            
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


extension TaxiMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        // Custom logic here
        
        searchText.resignFirstResponder()
        
        if(currentStep == .calcularPartida || currentStep == .calcularDestino) {
        
            let marker = currentStep == .calcularDestino ? markerDestino : markerPartida
            let markerImage = currentStep == .calcularDestino ? UIImage(named: "destino") : UIImage(named: "punto_partida")
        
            marker.position = coordinate
            marker.title = "Destino"
            marker.snippet = ""
            marker.map = mapView
            
            marker.iconView = UIImageView(image: markerImage)
            //marker.iconView?.transform = CGAffineTransform(scaleX: 2, y: 2)
        
            // Get string for address and display it in textfield
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
            
                // Address dictionary
                var address = ""
                
                if let locationName = placeMark.name as String? {
                    address += locationName
                }
                //if let street = placeMark.thoroughfare as String? {
                //    address += street
                //}
                if let sublocality = placeMark.subLocality as String? {
                    address += " \(sublocality)"
                }
                if let locality = placeMark.locality as String? {
                    address += " \(locality)"
                }
                
                if(self.currentStep == .calcularPartida) {
                    self.calcularViajePartidaLabel.text = address
                }
                else if(self.currentStep == .calcularDestino) {
                    self.calcularViajeDestinoLabel.text = address
                    self.calcularViajeSiguienteButton.isEnabled = true
                }
            
            })
            
        }
        
    }
    
    
    func showMessage(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}


extension UIView {
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 2
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}


extension Double
{
    var cleanValue: String
    {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    
    func stringFormattedValue() -> String
    {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale(identifier: "es_CR")
        currencyFormatter.currencySymbol = ""
        currencyFormatter.maximumFractionDigits = 2
        
        return currencyFormatter.string(from: self as NSNumber)!
    }
}

extension CLLocationCoordinate2D {
    //distance in meters, as explained in CLLoactionDistance definition
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let destination=CLLocation(latitude:from.latitude,longitude:from.longitude)
        return CLLocation(latitude: latitude, longitude: longitude).distance(from: destination)
    }
}

extension UIAlertController {
    
    @objc func canRotate() -> Void {}
}

