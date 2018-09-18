//
//  RegisterUserViewController.swift
//  aresep
//
//  Created by Pro Retina on 4/16/18.
//  Copyright © 2018 SOIN. All rights reserved.
//

import UIKit

class RegisterUserViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var idTypeTextField: UITextField!
    @IBOutlet var nameText: UITextField!
    @IBOutlet var idText: UITextField!
    @IBOutlet var emailText: UITextField!
    
    @IBOutlet var registerButton: UIButton!
    @IBOutlet weak var idTypeButton: DropdownButton!
    
    var formattingPattern = "##-####-####"
    var replacementChar: Character = "#"

    override func viewDidLoad() {
        super.viewDidLoad()

        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        registerButton.layer.cornerRadius = 5;
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        
        // Observe the UITextFieldTextDidChange notification to be notified in the below block when text is changed
        NotificationCenter.default.addObserver(forName: .UITextFieldTextDidChange, object: idText, queue: OperationQueue.main, using:
            {_ in
                if(self.idTypeButton.title(for: .normal) == self.idTypeButton.dropView.dropdownOptions[0]) {
                    self.textDidChange()
                }
        })
        
        idTypeButton.dropView.dropdownOptions = ["Nacional", "Extranjero"]
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
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
    
    
    @IBAction func changeIDType(_ sender: Any) {
    }
    
    
    @IBAction func exit(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
        
        NotificationCenter.default.post(name: Notification.Name("DismissTaxis"), object: nil)
    }
    
    @IBAction func register () {
        
        if(nameText.text! != "" && idText.text! != "" && emailText.text! != "") {
            if(self.idTypeButton.title(for: .normal) == self.idTypeButton.dropView.dropdownOptions[0] && idText.text!.count != 12) {
                
                showMessage(title: "", message: "Debe ingresar un número de identificación válida con formato 01-0123-0123")
            }
            else {
            if(isValidEmail(testStr: emailText.text!)) {
                let dbHandler = DBHandler()
                if (dbHandler.registerUser(name: nameText.text!, id: idText.text!, email: emailText.text!)) {
                    
                    //self.dismiss(animated: true, completion: nil)
                }
                
                NetworkHandler.registerUser(name: nameText.text!, id: idText.text!, email: emailText.text!) {
                    (data)  in
                    self.dismiss(animated: true, completion: nil)
                }
            }
            else {
                showMessage(title: "", message: "Debe ingresar una dirección de correo valida")
            }
            }
        }
        else {
            showMessage(title: "", message: "Todos los campos son requeridos")
        }
    }
    
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
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
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        
        if (textField == idText) {
            nameText.becomeFirstResponder()
        }
        else if (textField == nameText) {
            emailText.becomeFirstResponder()
        }
        else {
            
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    
    
    
    func makeOnlyDigitsString(string: String) -> String {
        return string.components(separatedBy: (NSCharacterSet.decimalDigits.inverted)).joined()
    }
    
    func textDidChange() {
        
        
        if idText.text!.count > 0 && formattingPattern.count > 0 {
            if(idText.text!.count == 1 && idText.text! != "0") {
                idText.text = "0\(idText.text!)"
            }
            let tempString = makeOnlyDigitsString(string: idText.text!)
            
            var finalText = ""
            var stop = false
            
            var formatterIndex = formattingPattern.startIndex
            var tempIndex = tempString.startIndex
            
            while !stop {
                 let formattingPatternRange = formatterIndex ..< formattingPattern.index(formatterIndex, offsetBy: 1)
                
                 if formattingPattern[formattingPatternRange] != String(replacementChar) {
                    finalText = finalText + formattingPattern[formattingPatternRange]
                } else if tempString.count > 0 {
                    let pureStringRange = tempIndex ..< tempString.index(tempIndex, offsetBy: 1)
                    finalText = finalText + tempString[pureStringRange]
                    tempIndex = tempString.index(after: tempIndex)
                }
                
                formatterIndex = formattingPattern.index(after: formatterIndex)
                
                if formatterIndex >= formattingPattern.endIndex || tempIndex >= tempString.endIndex {
                    stop = true
                }
            }
            
            idText.text = finalText
        }
 
 
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
