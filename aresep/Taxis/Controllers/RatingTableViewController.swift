//
//  RatingTableViewController.swift
//  GMaps
//
//  Created by Novacomp on 2/7/18.
//  Copyright © 2018 Novacomp. All rights reserved.
//

import UIKit
import Cosmos

class RatingTableViewController: UITableViewController,UITextFieldDelegate {

    /// If non-nil, the controller presents data only for the assigned section; if nil, the controller presents all sectioned data in a single view.
    var section: Int?
    
    /// The source of the tabular data.
    var model: BasicTableDataModel!
    var ratings: [NSManagedObject] = []
    
    
    
    var fareTextField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        loadData()
        
        //fareTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
    }
    
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        
        if((textField.text?.count)! > 10) {
            let mySubstring = textField.text?.prefix(10)
            textField.text = String(mySubstring!)
        }
        
        // Formatear monto ingresado
        /*if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
         */
        
    }
    
    
    
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    
    func loadData () {
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
    
    
    
    
    
    
    
    // MARK: - Table View Data Source
    
    /// Returns the number of sections in the table.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return section == nil ? ratings.count : 1
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    /// Returns the number of rows in the requested table `section`.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    /// Returns the title for the requested table `section`.
    //override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //    let group = self.section ?? section
    //    return model.title(forSection: group)
    //}
    
    
    /// Returns a cell for the requested `indexPath` populated with the corresponding data.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if((section!*2)+indexPath.row < ratings.count) {
            
            let section = self.section ?? indexPath.section
            let cell = tableView.dequeueReusableCell(withIdentifier: "RatingCell") as! RatingCell
            
            let rating = ratings[(section*2)+indexPath.row]
            
            cell.titleLabel.text = rating.value(forKeyPath: "category") as? String
            cell.ratingStars.tag = rating.value(forKeyPath: "id") as! Int
            
            return cell
        }
        else {
            //let section = self.section ?? indexPath.section
            let cell = tableView.dequeueReusableCell(withIdentifier: "InputCell") as! InputCell
            
            fareTextField = cell.textField
            
            
            fareTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
            
            return cell
        }
        
    }
    
    /// Stub for responding to user row selection.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! RatingCell
        print("\(#function): indexPath = \(indexPath); value = \(cell.titleLabel.text!)")
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        
        textField.resignFirstResponder()
        
        return true
    }
    
}



// MARK: -

/// The basic prototype table view cell that provides only a single label for textual presentation.
class RatingCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingStars: CosmosView!
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        ratingStars.didFinishTouchingCosmos = mySaveFunction
        
        //ratingStars.didFinishTouchingCosmos = { rating in
            // Save the rating here (to a variable, local database, send to the server etc.)
            //mySaveFunction(rating)
        //}
    }
    
    func mySaveFunction(rating: Double) {
        // Save rating here
        DBHandler.setStarRating(id: ratingStars.tag, ratingSelected: Int(rating))
        
    }
    
}

class InputCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
}

extension String {
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencySymbol = ""
        currencyFormatter.locale = Locale(identifier: "es_CR")
        currencyFormatter.maximumFractionDigits = 0
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        if(amountWithPrefix == "₡" || amountWithPrefix == "") {
            amountWithPrefix = "0"
        }
        
        let number = Int(amountWithPrefix )! as NSNumber
        
        
        return currencyFormatter.string(from: number)!
        
    }
}
