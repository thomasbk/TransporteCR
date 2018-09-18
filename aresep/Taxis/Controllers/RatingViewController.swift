//
//  RatingViewController.swift
//  GMaps
//
//  Created by Novacomp on 3/1/18.
//  Copyright © 2018 Novacomp. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController {
    
    var pageContainer: PageViewController!
    
    let mainColor = UIColor(red: 21/255, green: 136/255, blue: 218/255, alpha: 1.0)
    
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var backButton: UIButton!
    
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var roundView: UIView!
    
    var myRules:Rules!
    
    var ratings: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.layer.cornerRadius = 8
        nextButton.backgroundColor = mainColor
        //nextButton.layer.borderWidth = 2
        //nextButton.layer.borderColor = mainColor.cgColor
        
        backButton.layer.cornerRadius = 8
        backButton.backgroundColor = mainColor
        //backButton.layer.borderWidth = 2
        //backButton.layer.borderColor = mainColor.cgColor
        
        roundView.layer.cornerRadius = 10
        roundView.layer.borderWidth = 1
        roundView.layer.borderColor = UIColor(red: 63/255, green: 179/255, blue: 79/255, alpha: 1.0).cgColor
        
        setData(rules: myRules)
        //Looks for single or multiple taps.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData(rules: Rules) {
        
        var time = rules.traveledTime
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
        
        let roundedDistance = Double(round(100 * (rules.traveledDistance/100))/1000)
        //distanceLabel.text = "\(roundedDistance) Km"
        distanceLabel.text = "\(roundedDistance.stringFormattedValue()) Km"
        
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale(identifier: "es_CR")
        currencyFormatter.currencySymbol = "₡"
        currencyFormatter.maximumFractionDigits = 0
        
        let priceString = currencyFormatter.string(from: rules.totalPriceRounded as NSNumber)!
        priceLabel.text = priceString
        
        //priceLabel.text = "₡\(rules.totalPriceRounded)"
        
        
        //distanceLabel.text = String(rules.traveledDistance)
        //timeLabel.text = String(rules.traveledTime)
        //priceLabel.text = "₡\(rules.totalPriceRounded)"
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.destination {
            
        case let viewController1 as PageViewController:
            self.pageContainer = viewController1
            self.pageContainer.vc = self
            
        default:
            break
        }
    }
    
    
    @IBAction func next (_ sender: UIButton!) {
        
        pageContainer.goForward()
        backButton.isHidden = false
        
        nextButton.isEnabled = false
        Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(enableNextButton), userInfo: nil, repeats: false)
    }
    
    @IBAction func previous (_ sender: UIButton!) {
        
        pageContainer.goBack()
    }
    
    @objc func enableNextButton() {
        nextButton.isEnabled = true
    }
    
    func sendTrip(taxiFare:String) {
        
        self.showProgressIndicator()
        
        self.loadRatings()
        
        let tripID = arc4random_uniform(1000)
        
        NetworkHandler.addTrip(tripData:myRules,ratingData: ratings, taxiFare: taxiFare, tripID: Int(tripID)) { (data) in
            self.hideProgressIndicator()
            
            var title = "Éxito"
            var message = "Viaje finalizado exitosamente"
            
            if let codigo = data["C"] as? String {
                if(codigo == "00") {
                    DBHandler.deleteSavedTripData(id: Int(tripID))
                }
                else {
                    title = "Alerta"
                    message = "Ocurrió un error al finalizar el viaje."
                }
                
                let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                        print(data)
                        self.navigationController?.popViewController(animated: true)
                    case .cancel:
                        print("cancel")
                    case .destructive:
                        print("destructive")
                    }}))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    func loadRatings () {
        //1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        var managedContext: NSManagedObjectContext!
        //managedContext = appDelegate.persistentContainer.viewContext
        managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Rating")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        //3
        do {
            ratings = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    

}
