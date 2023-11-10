//
//  CanadaViewController.swift
//  Pretty_Antony_MT_8935790
//
//  Created by user234138 on 10/28/23.
//

import UIKit

class Canada: UIViewController {
    
    //city array
    var cities : [String]=["Calgary","Halifax","Montreal","Toronto","Vancover","Winnipeg"]
    
    //city images array
    var cityImages = [UIImage(named: "Calgary"),UIImage(named: "Halifax"),UIImage(named: "Montreal"),UIImage(named: "Toronto"),UIImage(named: "Vancover"),UIImage(named: "Winnipeg"),UIImage(named: "Canada")]
    
    //variable for city name
    @IBOutlet weak var cityName: UITextField!
    
    //variable for city image
    @IBOutlet weak var cityImageView: UIImageView!
    
    //to get the corresponding city image
    @IBAction func getCityImage(_ sender: UIButton) {
        
        for i in 0..<cities.count{
            
            //checking the trimmed city name is equal to the city names in the array
            if(trimCityName(cityName.text!).lowercased() == self.cities[i].lowercased()){
                
                //if true, the corresponding image is displayed in the imageview
                cityImageView.image = self.cityImages[i]
                break
                
            }
            //check if index is equal to array last item index and show error alert.
            else if(i==cities.count-1){
                
                //to show the 'no city found' alert
                showErrorAlert()
                
                //to maintain the canada image even if not cities are matched.
                cityImageView.image = self.cityImages[6]
                cityName.text = ""
                break
            }
        }
    }
    
    //to trim the empty spaces in the end of the input string
    func trimCityName(_ cityName:String) -> String {
        return cityName.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    
    //to show 'no city found' alert
    func showErrorAlert() {
        
        //title and msg to the Alert
        let alertController = UIAlertController(title: "City is not found", message: "", preferredStyle: .alert)

        //if 'OK' is pressed, the alert will be dismissed
        let cancelAction = UIAlertAction(title: "OK", style: .cancel)

        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    //for dismissing the keyboard on external click
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        
        cityName.resignFirstResponder()
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
