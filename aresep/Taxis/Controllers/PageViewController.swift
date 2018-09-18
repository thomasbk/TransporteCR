//
//  PageViewController.swift
//  GMaps
//
//  Created by Novacomp on 3/1/18.
//  Copyright © 2018 Novacomp. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var vc:RatingViewController!
    
    /// The storyboard identifier for the view controller being paginated.
    let viewControllerIdentifier = "RatingTableViewController"
    
    /// The number of pages being presented.
    //let pageCount = LatinTableDataModel().numSections / 2 + (LatinTableDataModel().numSections % 2)
    let numberOfRatings = DBHandler.getNumberOfRatings()
    var pageCount = 1
    var currentPage = 0
    
    /// The source of the tabular data.
    var model: LatinTableDataModel!
    
    
    var myRules:Rules!
    
    
    /// Configures self as the data source, and installs the page indicator and first-presented view controller.
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        // Install this class as the data source
        dataSource = self
        
        //Disable user scroll
        for case let view as UIScrollView in self.view.subviews {
            view.isScrollEnabled = false;
        }
        
        pageCount = (numberOfRatings / 2) + (numberOfRatings % 2)
        
        self.model = LatinTableDataModel()
        
        // Install the first-presented view controller
        let tvc = storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifier) as! RatingTableViewController
        tvc.section = 0
        tvc.model = model
        setViewControllers([tvc], direction: .forward, animated: true, completion: nil)
        
        // Configure page indicator dot colors
        if #available(iOS 9.0, *) {
            let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [PageViewController.self])
            
            pageControl.pageIndicatorTintColor = .lightGray
            pageControl.currentPageIndicatorTintColor = .black
        } else {
            // Fallback on earlier versions
        }
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    /// Returns a new `TableViewController` configured with the given `model` and `section`.
    func newTableViewController(forSection section: Int, of model: LatinTableDataModel) -> RatingTableViewController {
        let newTVC = storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifier) as! RatingTableViewController
        newTVC.model = model
        newTVC.section = section
        return newTVC
    }
    
    
    /// Returns the index of the currently visible view controller.
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let viewControllers = viewControllers, viewControllers.count > 0 {
            return (viewControllers[0] as! RatingTableViewController).section!
        }
        return 0
    }
    
    
    // MARK: - Page View Controller Data Source
    
    /// Returns the _next_ view controller, or `nil` if there is no such controller.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let tvc = viewController as! RatingTableViewController
        return tvc.section! < pageCount - 1 ? newTableViewController(forSection: tvc.section! + 1, of: model) : nil
    }
    
    
    /// Returns the _previous_ view controller, or `nil` if there is no such controller.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let tvc = viewController as! RatingTableViewController
        return tvc.section! > 0 ? newTableViewController(forSection: tvc.section! - 1, of: model) : nil
    }
    
    func goForward () {
        
        if(currentPage < pageCount-1) {
            currentPage = currentPage + 1
            
            let tvc = newTableViewController(forSection: currentPage, of: model)
            self.setViewControllers([tvc], direction: .forward, animated: true, completion: nil)
            
            if(currentPage == pageCount-1) {
                vc.nextButton.setTitle("Finalizar",for: .normal)
                
            }
            else {
                vc.nextButton.setTitle("Siguiente",for: .normal)
            }
        }
        else {
            let tvc = self.viewControllers![0] as! RatingTableViewController
            
            let taxiFare = tvc.fareTextField.text!
            
            if(taxiFare != "") {
                vc.sendTrip(taxiFare: taxiFare)
            }
            else {
                let alert = UIAlertController(title: "Alerta", message: "Debe ingresar el monto cobrado por el taxista.", preferredStyle: UIAlertControllerStyle.alert)
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
            
            //vc.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    func goBack () {
        if(currentPage > 0) {
            currentPage = currentPage - 1
            
            if(currentPage == pageCount-1) {
                vc.nextButton.setTitle("Finalizar",for: .normal)
            }
            else {
                vc.nextButton.setTitle("Siguiente",for: .normal)
            }
            
            let tvc = newTableViewController(forSection: currentPage, of: model)
            setViewControllers([tvc], direction: .reverse, animated: true, completion: nil)
            
            if(currentPage == 0) {
                vc.backButton.isHidden = true
            }
            else {
                vc.backButton.isHidden = false
            }
        }
        else {
            //vc.dismiss(animated: true, completion: nil)
        }

        
    }
    
    
    
    
    
    
    /// Returns the number of pages to represent in the `UIPageControl` page indicator.
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageCount
    }
}
