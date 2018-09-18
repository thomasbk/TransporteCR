//
//  TaxiInformationViewController.swift
//  GMaps
//
//  Created by Novacomp on 3/1/18.
//  Copyright © 2018 Novacomp. All rights reserved.
//

import UIKit
import SideMenu

class TaxiInformationViewController: UIViewController {
    
    @IBOutlet weak var derechosTextView: UITextView!
    @IBOutlet weak var liberacionTextView: UITextView!
    
    
    var appData = AppData.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //getGeneralInfo()
        
        if (appData.infoApp != nil && appData.infoApp! != "") {
            derechosTextView.text = appData.infoApp!
            liberacionTextView.text = appData.liberacionRespon!
        }
        

        // Do any additional setup after loading the view.
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (appData.infoApp != nil && appData.infoApp! != "") {
            derechosTextView.text = appData.infoApp!
            liberacionTextView.text = appData.liberacionRespon!
        }
        else {
            
            let alert = UIAlertController(title: "Conexión a internet", message: "Es necesario el acceso a internet para utilizar la aplicación. Debe salir del módulo de taxis y volver a intentarlo", preferredStyle: UIAlertControllerStyle.alert)
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
    
    func getGeneralInfo() {
        NetworkHandler.getGeneralInfo() { (data)  in
            //self.myRules.setRules(data)
        }
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

}
