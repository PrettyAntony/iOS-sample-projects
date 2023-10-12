//
//  ViewController.swift
//  Pretty_Antony_8935790_23FSec2Lab3
//
//  Created by user234138 on 9/20/23.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var countryName: UITextField!
        
    @IBOutlet weak var ageValue: UITextField!
    
    @IBOutlet weak var fullDetailsTextView: UITextView!
    
    @IBOutlet weak var successMessageLabel: UILabel!
    
    //to fetch all input details and concatinate to view the details entered in the TextView
    @IBAction func addDetails(_ sender: UIButton) {
        
        //clear message lable
        successMessageLabel.text = ""
        
        var fullName = ""
        
        //Concatinating all entered inputs
        if firstName.text != "" {
            fullName += "Full Name : "+String(firstName.text!)
        }
        
        if lastName.text != "" {
            fullName += " "+String(lastName.text!)
        }
        
        if countryName.text != "" {
            fullName += "\nCountry : "+String(countryName.text!)
        }
        
        if ageValue.text != "" {
            fullName += "\nAge : "+String(ageValue.text!)
        }
        
        
        print(fullName)
        
        //to display the details in the TextView
        fullDetailsTextView.text = fullName
        
    }
    
    //checking for empty fields and submiting after validation
    @IBAction func submitDetails(_ sender: UIButton) {
        
        if !checkForEmptyFields() {
            
            //if no empty fields label is shown in green color
            successMessageLabel.textColor = UIColor.green
            successMessageLabel.text = "Successfully submitted!"
        }else {
            
            //if there is empty fields label is shown in red color
            successMessageLabel.textColor = UIColor.red
            successMessageLabel.text = "Complete the missing Info!"
        }
        
    }
    
    //to clear all the fields
    @IBAction func clearDetails(_ sender: UIButton) {
        
        successMessageLabel.text = ""
        firstName.text = ""
        lastName.text = ""
        countryName.text = ""
        ageValue.text = ""
        fullDetailsTextView.text = ""
    }
    
    // to check for empty input fields and return corresponding boolean values
    func checkForEmptyFields() -> Bool{
        
        if (firstName.text == "" || lastName.text == "" || countryName.text == "" || ageValue.text == "") {
            
            return true
            
        }else {
            return false
        }
    }
    
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        
        firstName.resignFirstResponder()
        lastName.resignFirstResponder()
        countryName.resignFirstResponder()
        ageValue.resignFirstResponder()
        
        print("ho")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

