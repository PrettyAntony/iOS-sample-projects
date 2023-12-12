//
//  MainViewController.swift
//  Pretty_Antony_FE_8935790
//
//  Created by user234138 on 12/2/23.
//

import UIKit
import MapKit
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    
    var customTabBarController : UITabBarController? = nil
    
    let manager = CLLocationManager()
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func onSearchItemClicked(_ sender: UIButton) {
        
        //to show search dialog Alert
        showSearchDialogAlert()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations location: [CLLocation]) {
        if let location = location.first{
            render(location)
        }
    }
    
    func render(_ location:CLLocation){
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        let pin = MKPointAnnotation()
        
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
        mapView.setRegion(region, animated: true)
        
    }
    
    func showSearchDialogAlert() {
        
        //title and msg to the Alert
        let alertController = UIAlertController(title: "Where would you like to go?", message: "Enter Your Destination", preferredStyle: .alert)

        //adding value to the placeholder in the alert
        alertController.addTextField { textField in
            textField.placeholder = "Type your city here"
        }

        //on clicking newsbutton
        let newsButton = UIAlertAction(title: "News", style: .default) { _ in
            if let city = alertController.textFields?.first?.text, !city.isEmpty {
                self.navigateToNewsScene(cityName : city)
            }
        }
        
        //on clicking mapbutton
        let mapButton = UIAlertAction(title: "Map", style: .default) { _ in
            if let city = alertController.textFields?.first?.text, !city.isEmpty {
                self.navigateToMapScene(cityName : city)
            }
        }
        //on clicking weatherbutton
        let weatherButton = UIAlertAction(title: "Weather", style: .default) { _ in
            if let city = alertController.textFields?.first?.text, !city.isEmpty {
                self.navigateToWeatherScene(cityName : city)
            }
        }
        
        //if cancel is pressed, the action will be cancelled
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(newsButton)
        alertController.addAction(mapButton)
        alertController.addAction(weatherButton)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    func navigateToNewsScene(cityName : String){
        // Instantiate the news view controller from the storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Use your storyboard name
            if let newsViewController = storyboard.instantiateViewController(withIdentifier: "News") as? NewsTableViewController {
                
                // Pass data to the second view controller
                newsViewController.receivedCityName = cityName
                newsViewController.receivedSourceOfTransaction = "From Home"
                
                navigationController?.pushViewController(newsViewController, animated: false)
                
            }
        
    }
    
    func navigateToMapScene(cityName : String){
        // Instantiate the map view controller from the storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Use your storyboard name
            if let mapViewController = storyboard.instantiateViewController(withIdentifier: "Map") as? MapViewController {
                
                // Pass data to the second view controller
                mapViewController.receivedCityName = cityName
                mapViewController.receivedSourceOfTransaction = "From Home"
                
                navigationController?.pushViewController(mapViewController, animated: false)
                
            }
    }
    
    func navigateToWeatherScene(cityName : String){
        // Instantiate the map view controller from the storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Use your storyboard name
            if let weatherViewController = storyboard.instantiateViewController(withIdentifier: "Weather") as? WeatherViewController {
                
                // Pass data to the second view controller
                weatherViewController.receivedCityName = cityName
                weatherViewController.receivedSourceOfTransaction = "From Home"
                
                navigationController?.pushViewController(weatherViewController, animated: false)
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //setUpBottomButtons()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
       
    }

}
