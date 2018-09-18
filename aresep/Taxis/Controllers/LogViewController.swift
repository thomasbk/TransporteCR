//
//  LogViewController.swift
//  GMaps
//
//  Created by Novacomp on 2/6/18.
//  Copyright © 2018 Novacomp. All rights reserved.
//

import UIKit
import MessageUI
import SideMenu
import CoreData

class LogViewController: UIViewController, MFMailComposeViewControllerDelegate,UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet var tableView: UITableView!
    
    var trips: [NSManagedObject] = []
    
    var managedContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadData()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func back() {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
        self.navigationController?.popViewController(animated: false)
        //self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func loadData () {
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        //managedContext = appDelegate.persistentContainer.viewContext
        managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Trip")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        //3
        do {
            trips = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    
    
    @IBAction func sendToWhatsapp () {
        
        tableView.reloadData()
        let date = Date()
        let msg = "Hi my dear friends\(date)"
        let urlWhats = "whatsapp://send?text=\(msg)"
        
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = NSURL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(whatsappURL as URL, options: [:], completionHandler: nil)
                    }
                    else {
                        UIApplication.shared.openURL(whatsappURL as URL)
                    }
                } else {
                    print("please install watsapp")
                }
            }
        }
    }
    
    
    @IBAction func sendEmail() {
        // servicio de enviar historial por correo
        
        self.showProgressIndicator()
        
        let userID = DBHandler.getUserID()
        NetworkHandler.exportTrips(userID: userID) { (data)  in
            
            self.hideProgressIndicator()
            
            let alert = UIAlertController(title: "Éxito", message: "Su solicitud de historial de viajes ha sido enviada, en breve recibirá un correo con esta información", preferredStyle: UIAlertControllerStyle.alert)
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
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let trip = trips[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell") as! LogCell
        
        cell.roundView.layer.cornerRadius = 10
        cell.roundView.layer.borderWidth = 1
        cell.roundView.layer.borderColor = UIColor(red: 63/255, green: 179/255, blue: 79/255, alpha: 1.0).cgColor
        
        
        var time = Double(trip.value(forKeyPath: "time")! as! String)!
        // Calculate minutes
        let minutes = UInt8(time / 60.0)
        time -= (TimeInterval(minutes) * 60)
        
        // Calculate seconds
        let seconds = UInt8(time)
        time -= TimeInterval(seconds)
        
        // Format time vars with leading zero
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        let roundedDistance = Double(round(100 * (Double(trip.value(forKeyPath: "distance")! as! String)!/100))/1000)
        
        
        cell.timeLabel.text = "\(strMinutes):\(strSeconds)"
        cell.distanceLabel.text = "\(roundedDistance.stringFormattedValue()) Km"
        
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale(identifier: "es_CR")
        currencyFormatter.currencySymbol = "₡"
        currencyFormatter.maximumFractionDigits = 0
        
        let priceString = currencyFormatter.string(from: Int(trip.value(forKeyPath: "price") as! String)! as NSNumber)!
        cell.priceLabel.text = priceString
        
        //cell.priceLabel.text = "₡\(priceString)"
        //cell.priceLabel.text = "₡\(trip.value(forKeyPath: "price") as! String)"
        
        
        
        let date = trip.value(forKeyPath: "date") as! Date
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        //formatter.dateFormat = "HH:mm dd/MM/yyyy"
        let myDate = formatter.string(from: date)
        cell.dateLabel.text = myDate
        
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            
            let trip = trips[indexPath.row]
            
            trips.remove(at: indexPath.row)
            managedContext.delete(trip)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            do {
                try managedContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
    
    
    // MARK: -
    // MARK: Table View Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

}

// MARK: -

/// The basic prototype table view cell that provides only a single label for textual presentation.
class LogCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet var roundView: UIView!
    
}
