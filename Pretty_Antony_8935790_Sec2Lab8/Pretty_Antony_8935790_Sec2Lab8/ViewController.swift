//
//  ViewController.swift
//  Pretty_Antony_8935790_Sec2Lab8
//
//  Created by user234138 on 11/27/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    //location manager
    let manager = CLLocationManager()
    
    //variables for latitude & longiude
    var currentLatitude = 0.00
    var currentLongitude = 0.00
    
    //label outlets and images
    @IBOutlet weak var labelCityName: UILabel!
    
    @IBOutlet weak var labelCurrentWeather: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var labelTemperature: UILabel!
    
    @IBOutlet weak var labelHumidity: UILabel!
    
    @IBOutlet weak var labelWind: UILabel!
    
    //variable for storing values
    var cityName : String = ""
    var currentWeather : String = ""
    var temparature : Double = 0.00
    var humidity : Int = 0
    var wind : Double = 0.00
    var _weatherIcon = UIImage()
    
    //to fetch current location lattitude and longitude
    func locationManager(_ manager: CLLocationManager, didUpdateLocations location: [CLLocation]) {
        if let location = location.last{
            
            //rounding of the decimal places to 6 digits
            currentLatitude = formatValueAndSet(location.coordinate.latitude)
            currentLongitude = formatValueAndSet(location.coordinate.longitude)
            
            //uncomment the code for stoping the location updation
            manager.stopUpdatingLocation()
            getWeatherInformation()
            
            
            
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
            self.labelCurrentWeather.text = self.currentWeather
            self.labelTemperature.text = String(Int(self.temparature-273.15))+"°C"
            self.labelHumidity.text = "Humidity : "+String(self.humidity)+"%"
            self.labelWind.text = "Wind : "+String(self.wind)+"km/hr"
            self.weatherImage.image = self._weatherIcon
        }
    }
    
    //weather api call function
    func getWeatherInformation(){
        let weatherApiCall = weatherApi+"lat="+String(currentLatitude)+"&lon="+String(currentLongitude)+"&appid="+appId
        
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

    override func viewDidLoad() {
        super.viewDidLoad()
       
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }


}

