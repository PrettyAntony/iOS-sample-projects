//
//  QuadraticViewController.swift
//  Pretty_Antony_MT_8935790
//
//  Created by user234138 on 10/28/23.
//

import UIKit

class Quadratic: UIViewController {
    
    
    @IBOutlet weak var valueForA: UITextField!
    
    @IBOutlet weak var valueForB: UITextField!

    @IBOutlet weak var valueForC: UITextField!

    @IBOutlet weak var userMessageLabel: UILabel!

    @IBOutlet weak var valueOfX: UITextField!

    @IBOutlet weak var outputOfXStack: UIStackView!

    //local variables for storing values of A,B and C
    var valueA = 0.1;
    var valueB = 0.0;
    var valueC = 0.0;

    //function is called when caluculate button is clicked
    @IBAction func calculateValueForX(_ sender: UIButton) {
        
        //changing the hidden status of user message label
        userMessageLabel.isHidden = false

        //checking if inputs are valid or not
        if(validateInputs()){

            //calcualting the discriminant
            let discriminant = (valueB*valueB)-(4*valueA*valueC)
            print(discriminant)

            //calling fucntion to display message about X value in regards of discriminant
            getValueOfXWithUserMessage(discriminant)
        }
    }

    //to clear all fields and show user message to enter values for A, B and C
    @IBAction func buttonClear(_ sender: UIButton) {

        valueForA.text = ""
        valueForB.text = ""
        valueForC.text = ""

        userMessageLabel.textColor = UIColor.red
        userMessageLabel.isHidden = false
        outputOfXStack.isHidden = true
        userMessageLabel.text = "Enter a value for A,B and C to find X."
    }

    //to validate values entered for A, B and C
    func validateInputs() -> Bool {

        if(valueForA.text == "" || Double(valueForA.text!)!<=0){
            userMessageLabel.textColor = UIColor.red
            userMessageLabel.text = "The value you entered for A is invalid."
            return false
        }else if(valueForB.text == ""){
            userMessageLabel.textColor = UIColor.red
            userMessageLabel.text = "The value you entered for B is invalid."
            return false
        }else if(valueForC.text == ""){
            userMessageLabel.textColor = UIColor.red
            userMessageLabel.text = "The value you entered for C is invalid."
            return false
        }else{
            //valid inouts are converted to Double and stored in local variables.
            valueA = Double(valueForA.text!)!
            valueB = Double(valueForB.text!)!
            valueC = Double(valueForC.text!)!
            return true
        }
    }

    //to get value of X and to display message about X value in regards of discriminant
    func getValueOfXWithUserMessage(_ discriminant : Double){

        if(discriminant<0){
            userMessageLabel.textColor = UIColor.red
            userMessageLabel.text = "There are no results since the discriminant is less than zero."
        }else if(discriminant == 0){
            userMessageLabel.textColor = UIColor.green
            userMessageLabel.text = "There is only one value for X."
            
            //to get the value of X
            getValueOfX(discriminant)
        }else{
            userMessageLabel.textColor = UIColor.green
            userMessageLabel.text = "There are two values for X."
            
            //to get the two values of X; a boolean is passed to check if the X has two values
            getValueOfX(discriminant,true)
        }
    }

    //to get the two values of X; a boolean is passed to check if the X has two values
    func getValueOfX(_ discriminant : Double, _ hasTwoValues : Bool = false){

        //changing the hidden status of stack which contains X label and textfield
        outputOfXStack.isHidden = false
        
        //modularising the quadratic function
        let squareRootOfDiscriminant = sqrt(discriminant)

        //first value of X
        let firstValueOfX = (-valueB + squareRootOfDiscriminant)/(2 * valueA)
        print(firstValueOfX)
        
        //to display the value of X, rounding upto 2 decimal points
        valueOfX.text = String(format: "%.\(2)f", firstValueOfX)
        
        //checking if X has two values and displaying both values in the text field
        if(hasTwoValues){
            
            let secondValueOfX = (-valueB - squareRootOfDiscriminant)/(2 * valueA)
            
            //to display the two values of X, rounding upto 2 decimal places
            valueOfX.text = String(format: "%.\(2)f", firstValueOfX) + " Or " + String(format: "%.\(2)f", secondValueOfX)
        }

    }
    
    //fumction to hide Keyboard on outer click
    @IBAction func hideKeyBoard(_ sender: UITapGestureRecognizer) {
        valueForA.resignFirstResponder()
        valueForB.resignFirstResponder()
        valueForC.resignFirstResponder()
        valueOfX.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
