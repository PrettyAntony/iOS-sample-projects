//
//  MapViewController.swift
//  Pretty_Antony_FE_8935790
//
//  Created by user234138 on 12/2/23.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    //variable declaration
    var receivedCityName: String?
    var receivedSourceOfTransaction: String?
    
    var zoomValue = 0.30
    var typeOfTransportation = 1
    var cityName = ""
    var sourceOfTransaction = ""
    var startCity = ""
    var currentPolylineRenderer: MKPolylineRenderer?
    var customAnnotations: [MKAnnotation] = []
    
    var history : [History]?
    
    let content = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var startLocationCoordinates : CLLocation?
    var endLocationCoordinates : CLLocation?
    var currentLocation : CLLocationCoordinate2D?
    
    @IBOutlet weak var zoomSlider: UISlider!
    
    @IBOutlet weak var mapView: MKMapView!
    
    let manager = CLLocationManager()
    
    //setting location manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations location: [CLLocation]) {
        if let location = location.first{
            manager.startUpdatingLocation()
            render(location)
        }
    }
    
    //annotating current location
    func render(_ location:CLLocation){
        
        //setting slider value
        zoomValue = Double(1 - zoomSlider.value)
        print(zoomValue)
        
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        self.startLocationCoordinates = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        getCurrentLocationName()
        
        let span = MKCoordinateSpan(latitudeDelta: zoomValue, longitudeDelta: zoomValue)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        let pin = MKPointAnnotation()
        
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
        mapView.setRegion(region, animated: true)
        
        self.currentLocation = coordinate
        
    }
    
    @IBAction func onWalkingClicked(_ sender: Any) {
        
        typeOfTransportation = 3
        convertToAddress()
    }
    
    @IBAction func onCarClicked(_ sender: Any) {
        
        typeOfTransportation = 1
        convertToAddress()
    }
    
    @IBAction func onCycleClicked(_ sender: Any) {
        
        typeOfTransportation = 2
        convertToAddress()
    }
    
    //show alert and check for new city
    @IBAction func checkForNewCity(_ sender: UIBarButtonItem) {
        showAlertToAddCity()
    }
    
    //reloading mapview on changing zoom by slider
    @IBAction func onZoomSliderClicked(_ sender: UISlider) {

        zoomValue = Double(1 - sender.value)
        if let location = self.currentLocation {
            let span = MKCoordinateSpan(latitudeDelta: zoomValue, longitudeDelta: zoomValue)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    @IBAction func newsClicked(_ sender: Any) {
        
        navigateToNewsScene()
    }
    
    @IBAction func newsButtonClicked(_ sender: Any) {
        
        navigateToNewsScene()
    }
    
    @IBAction func weatherClicked(_ sender: Any) {
        
        navigateToWeatherScene()
    }
    
    @IBAction func weatherButtonClicked(_ sender: Any) {
        
        navigateToWeatherScene()
    }
    
    func navigateToNewsScene(){
        // Instantiate the news view controller from the storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Use your storyboard name
            if let newsViewController = storyboard.instantiateViewController(withIdentifier: "News") as? NewsTableViewController {
                
                // Pass data to the second view controller
                newsViewController.receivedCityName = self.cityName
                newsViewController.receivedSourceOfTransaction = "From Map"
                
                navigationController?.pushViewController(newsViewController, animated: false)
                
            }
        
    }
    
    func navigateToWeatherScene(){
        // Instantiate the weather view controller from the storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Use your storyboard name
            if let weatherViewController = storyboard.instantiateViewController(withIdentifier: "Weather") as? WeatherViewController {
                
                // Pass data to the second view controller
                weatherViewController.receivedCityName = self.cityName
                weatherViewController.receivedSourceOfTransaction = "From Map"
                
                navigationController?.pushViewController(weatherViewController, animated: false)
            }
    }
    
    func showAlertToAddCity() {
        
        //title and msg to the Alert
        let alertController = UIAlertController(title: "Add a City to check Directions", message: nil, preferredStyle: .alert)

        //adding value to the placeholder in the alert
        alertController.addTextField { textField in
            textField.placeholder = "Add your city here"
        }

        //on adding, item is appended and array is updated and reloaded.
        let searchAction = UIAlertAction(title: "Search", style: .default) { _ in
            if let newItem = alertController.textFields?.first?.text, !newItem.isEmpty {
                self.cityName = newItem
                self.sourceOfTransaction = "From Map"
                self.convertToAddress()
            }
        }

        //if cancel is pressed, the action will be cancelled
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(searchAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    //getting city name and set polyline to the destination
    func convertToAddress(){
        
        removePreviousOverlays()
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(self.cityName){
            (placemarks,error) in
            guard let placemarks = placemarks,
                  let location = placemarks.first?.location
            else{
                print("no location")
                return
            }
            print(location)
            self.mapThis(destinationCor : location.coordinate)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay : MKOverlay) -> MKOverlayRenderer{
     
        let routline = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        
        if(typeOfTransportation==1){
            routline.strokeColor = .green
        }else if(typeOfTransportation == 2){
            routline.strokeColor = .blue
            routline.lineDashPattern = [3, 10]
        }else{
            routline.strokeColor = .black
            routline.lineDashPattern = [1, 7]
        }
        
        currentPolylineRenderer = routline
        
        return routline
    }
    
    func mapThis(destinationCor : CLLocationCoordinate2D){
        
        let sourceCoordinate = manager.location?.coordinate
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate!)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCor)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destinationItem = MKMapItem(placemark: destinationPlacemark)
        
        let destinationRequest = MKDirections.Request()
        
        destinationRequest.source = sourceItem
        destinationRequest.destination = destinationItem
        
        if(self.typeOfTransportation == 1){
            destinationRequest.transportType = .automobile
            
        }else {
            destinationRequest.transportType = .walking
        }
            
        destinationRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: destinationRequest)
        directions.calculate{(response, error) in
            guard let response = response else{
                if error != nil{
                    print("something went wrong")
                }
                return
            }
            
            let route = response.routes[0]
            
            self.mapView.addOverlay(route.polyline)
            //self.currentPolylines.append(route.polyline)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            
            let pin = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude: destinationCor.latitude, longitude: destinationCor.longitude)
            
            self.endLocationCoordinates = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            pin.coordinate = coordinate
            pin.title = self.cityName
            self.mapView.addAnnotation(pin)
            
            //to add annotations to an array to remove easily
            self.customAnnotations.append(pin)
            
            self.saveDirectionDetails()
            
        }
    }
    
    func removePreviousOverlays(){
        if let existingRenderer = currentPolylineRenderer {
            self.mapView.removeOverlay(existingRenderer.overlay)
                }
                currentPolylineRenderer = nil
        
        //to remove all annotations except for the last location where trip is ended
        if(customAnnotations.count > 0){
            self.mapView.removeAnnotations(customAnnotations)
            
        }
        
    }
    
    func saveDirectionDetails(){
        
        let history = History(context: self.content)
        
        history.cityName = self.cityName
        history.sourceOfTransaction = self.sourceOfTransaction
        history.typeOfTransaction = "Directions"
        
        history.startPlace = self.startCity
        history.totalDistance = String(format : "%.2f", self.startLocationCoordinates!.distance(from: self.endLocationCoordinates!)/1000)+"kms"
        history.endPlace = self.cityName
        
        if(typeOfTransportation == 1){
            history.modeOfTransport = "Car"
        }else if(typeOfTransportation == 2){
            history.modeOfTransport = "Bicycle"
        }else {
            history.modeOfTransport = "Walking"
        }
        
    
        do{
            try self.content.save()
            //print(history.startPlace!)
        }catch{
            print("Error saving data")
        }
    }
    
    //getting start city name
    func getCurrentLocationName(){
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(startLocationCoordinates!){ (_placemarks,error) in
            guard let placemarks = _placemarks?.first,
                  let location = placemarks.locality
            else{
                print("no location")
                return
            }
            
            //print(location)
            self.startCity = location
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting title custom needed
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        // Set the back button color
        self.navigationController?.navigationBar.tintColor = UIColor.black
        //setting back button as home button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "homekit"), style: .plain, target: self, action:#selector(goBack))
        
        // Access and use the received data
        self.cityName = receivedCityName ?? "Waterloo"
        self.sourceOfTransaction = receivedSourceOfTransaction ?? "From Home"
        
        
        convertToAddress()
        // Do any additional setup after loading the view.
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        mapView.delegate = self
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
