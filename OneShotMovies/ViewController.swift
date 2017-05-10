//
//  ViewController.swift
//  OneShotMovies
//
//  Created by Adhita Selvaraj on 13/01/17.
//  Copyright © 2017 DreamCatcher. All rights reserved.
//

import UIKit

var movieName = ""
var movieYear = 0

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var movieNameTextField: UITextField!
    
    @IBOutlet var yearPickerView: UIPickerView!
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    var yearFiller = [Int()]
    
    func fillYear() {
        for i in 1980...2017 {
            if i != 0 {
                yearFiller.append(i)
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return yearFiller.count
    }
    
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if yearFiller[row] == 0 {
            movieYear = 0
            return "No Clue"
        }
        return String(yearFiller[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        movieYear = yearFiller[row]
        
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        
        movieName = movieNameTextField.text!
        movieName = movieName.replacingOccurrences(of: " ", with: "+")
        let alert = UIAlertController(title: "Alert", message: "Enter a Movie Name", preferredStyle: UIAlertControllerStyle.alert)
        
        let noSegueAction = UIAlertAction(title: "Ok", style: .default)
        
        if movieName == "" {
            alert.addAction(noSegueAction)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            
            present(movieDisplayViewController(), animated: true, completion: nil)
            
        }

        
    }
    
    @IBAction func favouritesButtonAction(_ sender: Any) {
       
        let alrt = UIAlertController(title: "Alert", message: "Add Favourites", preferredStyle: UIAlertControllerStyle.alert)
        
        let noSegeAction = UIAlertAction(title: "Ok", style: .default)
        
        print(moves.count)
        
        if moves.count == 0 {
            alrt.addAction(noSegeAction)
            self.present(alrt, animated: true, completion: nil)
        }
        else {
            
            self.present(favouritesViewController(), animated: true, completion: nil)
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        fillYear()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "searchBg")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

