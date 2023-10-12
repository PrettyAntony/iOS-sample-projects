//
//  ViewController.swift
//  23FSec2Lab2
//
//  Created by user234138 on 9/17/23.
//

import UIKit

class ViewController: UIViewController {
    
    //variable to store counter value
    var count = 0
    
    //boolean variable to store stepButton value
    var stepButtonClicked = false

    @IBOutlet weak var Counter: UILabel!
    
    
    //function to increment the counter
    @IBAction func increment(_ sender: UIButton) {
        
        //checking if stepButton is clicked or not
        if(stepButtonClicked){
           count = count + 2
        }
        else {
            count = count + 1
        }
        print(count)
        Counter.text = String(count)
    }
    
    //function to decrement the counter
    @IBAction func decrement(_ sender: UIButton) {
        
        //checking if stepButton is clicked or not
        if(stepButtonClicked){
           count = count - 2
        }
        else {
            count = count - 1
        }
        print(count)
        Counter.text = String(count)
    }
    
    
    //function to reset the counter
    @IBAction func reset(_ sender: UIButton) {
        
        count = 0
        stepButtonClicked = false
        print(count,stepButtonClicked)
        Counter.text = String(count)
    }
    
    //function to toggle between step count 2 & 1
    @IBAction func stepButton(_ sender: UIButton) {
        
        //updating the stepButton boolean variable
        stepButtonClicked = !stepButtonClicked
        print(count,stepButtonClicked)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

