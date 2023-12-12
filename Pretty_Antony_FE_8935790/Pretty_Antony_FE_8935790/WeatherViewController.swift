//
//  WeatherViewController.swift
//  Pretty_Antony_FE_8935790
//
//  Created by user234138 on 12/2/23.
//

import UIKit
import CoreData
import Foundation

class WeatherViewController: UIViewController {
    
    var receivedCityName: String?
    var receivedSourceOfTransaction: String?
    
    //variable for storing values
    var cityName : String = ""
    var sourceOfTransaction = ""
    var currentWeather : String = ""
    var temparature : Double = 0.00
    var humidity : Int = 0
    var wind : Double = 0.00
    var _weatherIcon = UIImage()
    
    var newCityName = ""
    
    var history : [History]?
    
    let content = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    @IBOutlet weak var labelCityName: UILabel!
    
    @IBOutlet weak var labelCity: UILabel!
    
    @IBOutlet weak var labelWeather: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var labelTemperature: UILabel!
    
    @IBOutlet weak var labelHumidity: UILabel!
    
    @IBOutlet weak var labelWind: UILabel!
    
    
    @IBAction func newsClicked(_ sender: Any) {
        
        navigateToNewsScene()
    }
    
    @IBAction func newsButtonClicked(_ sender: Any) {
        
        navigateToNewsScene()
    }
    
    @IBAction func mapClicked(_ sender: Any) {
        
        navigateToMapScene()
    }
    
    @IBAction func mapButtonClicked(_ sender: Any) {
        
        navigateToMapScene()
    }
    
    
    @IBAction func addNewCityToCheckWeather(_ sender: Any) {
        
        showAlertToAddCity()
    }
    
    func navigateToNewsScene(){
        // Instantiate the news view controller from the storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Use your storyboard name
            if let newsViewController = storyboard.instantiateViewController(withIdentifier: "News") as? NewsTableViewController {
                
                // Pass data to the second view controller
                newsViewController.receivedCityName = self.cityName
                newsViewController.receivedSourceOfTransaction = "From Weather"
                
                navigationController?.pushViewController(newsViewController, animated: false)
                
            }
        
    }
    
    func navigateToMapScene(){
        // Instantiate the map view controller from the storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Use your storyboard name
            if let mapViewController = storyboard.instantiateViewController(withIdentifier: "Map") as? MapViewController {
                
                // Pass data to the second view controller
                mapViewController.receivedCityName = self.cityName
                mapViewController.receivedSourceOfTransaction = "From Weather"
                
                navigationController?.pushViewController(mapViewController, animated: false)
                
            }
    }
    
    func showAlertToAddCity() {
        
        //title and msg to the Alert
        let alertController = UIAlertController(title: "Add a City to check Weather", message: nil, preferredStyle: .alert)

        //adding value to the placeholder in the alert
        alertController.addTextField { textField in
            textField.placeholder = "Add your city here"
        }

        //on adding, item is appended and array is updated and reloaded.
        let searchAction = UIAlertAction(title: "Search", style: .default) { _ in
            if let newItem = alertController.textFields?.first?.text {
                self.cityName = newItem
                self.sourceOfTransaction = "From Weather"
                self.getWeatherInformation()
            }
        }

        //if cancel is pressed, the action will be cancelled
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(searchAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    
    //weather api call function
    func getWeatherInformation(){
        
        let weatherApiCall = weatherApi+"q="+self.cityName+"&appid="+weatherApiKey
        
        print(weatherApiCall)
        
        // Note this shouls be a VAR in when used in an application as the URL value will change with each call!
        // Create an instance of a URLSession Class and assign the value of your URL to the The URL in the Class
        let urlSession = URLSession(configuration:.default)
        let url = URL(string: weatherApiCall)

        // Check for Valid URL
        if let url = url {
            // Create a variable to capture the data from the URL
            let dataTask = urlSession.dataTask(with: url) { (data, response, error) in
                
                // If URL is good then get the data and decode
                if let data = data {
                    print (data)
                    let jsonDecoder = JSONDecoder()
                    do {
                        // Create an variable to store the structure from the decoded stucture
                        let readableData = try jsonDecoder.decode(WeatherData.self, from: data)
                        
                        //setting values to all variables
                        self.cityName = readableData.name
                        self.currentWeather = readableData.weather[0].description
                        self.temparature = readableData.main.temp
                        self.humidity = readableData.main.humidity
                        self.wind = readableData.wind.speed
                        
                        //getting weather icon
                        let weatherIconUrl = getWeatherIconUrl+readableData.weather[0].icon+".png"
                        
                        if let iconURL = URL(string: weatherIconUrl),
                           let imageData = try? Data(contentsOf: iconURL),
                           let weatherIcon = UIImage(data: imageData) {
                           
                            self._weatherIcon = weatherIcon
                            
                        } else {
                            // Handle the case where the image couldn't be loaded
                            print("Error loading weather icon")
                        }
                        
                        //calling function to make display changes
                        self.setWeatherCastingDetails()
                        
                        
                        
                    }
                    //Catch the Broken URL Decode
                    catch {
                        print ("Can't Decode")
                        
                    }
                    
                }
                
            }
            dataTask.resume()// Resume the datatask method
            dataTask.response
        }

    }
    
    //rounding of the decimal places to 6 digits
    func formatValueAndSet(_ oldValue:Double)->Double{
        let newValue = String(format: "%6f", oldValue)
        return Double(newValue)!
    }
    
    //to update the weather details
    func setWeatherCastingDetails(){
        
        //to finish the background task and update label in the main thread
        DispatchQueue.main.async {
            self.labelCityName.text = self.cityName
            self.labelCity.text = self.cityName
            self.labelWeather.text = self.currentWeather
            self.labelTemperature.text = String(Int(self.temparature-273.15))+"°C"
            self.labelHumidity.text = "Humidity : "+String(self.humidity)+"%"
            self.labelWind.text = "Wind : "+String(self.wind)+"km/hr"
            self.weatherImage.image = self._weatherIcon
            
            let history = History(context: self.content)
            history.cityName = self.cityName
            history.sourceOfTransaction = self.sourceOfTransaction
            history.typeOfTransaction = "Weather"
            history.temperature = self.labelTemperature.text
            history.humidity = self.labelHumidity.text
            history.wind = self.labelWind.text
            history.dateTime = self.getCurrentDateTime()
            
            do{
                try self.content.save()
            }catch{
                print("Error saving data")
            }
        }
    }
    
    func getCurrentDateTime()->String{
        // Get the current date and time
        let currentDate = Date()

        // Create a date formatter
        let dateFormatter = DateFormatter()

        // Set the date format
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        // Format the current date and time
        let formattedDate = dateFormatter.string(from: currentDate)
        
        return formattedDate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Access and use the received data
        self.cityName = receivedCityName ?? "Waterloo"
        self.sourceOfTransaction = receivedSourceOfTransaction ?? "From Home"
        
        getWeatherInformation()
        
        //setting title custom needed
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        // Set the back button color
        self.navigationController?.navigationBar.tintColor = UIColor.black
        //setting back button as home image
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "homekit"), style: .plain, target: self, action:#selector(goBack))
       
    }
    
    @objc func goBack() {
        navigationController?.popToRootViewController(animated: true)
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
