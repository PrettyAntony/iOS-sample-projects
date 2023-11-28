//
//  ViewController.swift
//  Pretty_Antony_8935790_Sec2Lab7
//
//  Created by user234138 on 11/16/23.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    
    
    @IBOutlet weak var labelCurrentSpeed: UILabel!
    
    @IBOutlet weak var labelMaxSpeed: UILabel!
    
    @IBOutlet weak var labelAverageSpeed: UILabel!
    
    @IBOutlet weak var labelDistance: UILabel!
    
    @IBOutlet weak var labelMaxAcceleration: UILabel!
    
    @IBOutlet weak var startTrip: UIButton!
    
    @IBOutlet weak var stopTrip: UIButton!
    
    @IBOutlet weak var labelOverSpeed: UILabel!
    
    @IBOutlet weak var labelTripIndicator: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var timeTakenForTrip: Double = 0.0
    var distanceCovered: CLLocationDistance = 0.0
    var currentSpeed: CLLocationSpeed = 0.0
    var maxSpeed: CLLocationSpeed = 0.0
    var averageSpeed : CLLocationSpeed = 0.0
    var maxAcceleration: Double = 0.0
    var distanceTravelledBeforeOverSpeed : Double = 0.0
    var isDistanceTravelledBeforeOverSpeedStored = false
    var isStartButtonClicked = false
    var tripIsStarted = false
    var tripStartTime = Date()
    
    var locationStart: CLLocation?
    var locationCurrent: CLLocation?
    var locationPrevious: CLLocation?
        
    let manager = CLLocationManager()
    
    var customAnnotations: [MKAnnotation] = []

    
    @IBAction func buttonStartTrip(_ sender: Any) {
        
        //initializing values
        resetAllValues()
        
        isStartButtonClicked = true
        
        
        mapView.showsUserLocation = true
        locationStart = locationCurrent
        tripIsStarted = true
        manager.startUpdatingLocation()
        labelTripIndicator.backgroundColor = UIColor.green
        tripStartTime = Date()
        
        
        print(distanceCovered)
        print(distanceTravelledBeforeOverSpeed)
        
    }
    
    //reset all values in the view
    func resetAllValues(){
        timeTakenForTrip = 0.0
        distanceCovered = 0.0
        distanceTravelledBeforeOverSpeed = 0.0
        currentSpeed = 0.0
        maxSpeed = 0.0
        averageSpeed = 0.0
        maxAcceleration = 0
        
        //to remove all annotations except for the last location where trip is ended
        if(customAnnotations.count > 0){
            mapView.removeAnnotations(customAnnotations)
            
        }
    }
    
    @IBAction func buttonStopTrip(_ sender: Any) {
        
        manager.stopUpdatingLocation()
        mapView.showsUserLocation = false
        
        tripIsStarted = false
        labelOverSpeed.backgroundColor = UIColor.clear
        labelTripIndicator.backgroundColor = UIColor.gray
        
        isStartButtonClicked = false
        stopTrip.isEnabled = false
        
        //if speedlimit is crossed , distance covered before crossing speed limit will show as alert
        if(distanceTravelledBeforeOverSpeed > 0){
            showDistanceAsAlert()
        }
                
        // Add a static pin at the last known location
        addStaticPin(at: locationCurrent!.coordinate)
         
    }
    
    //to add a ststic pin for the location trip ended
    func addStaticPin(at coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Trip End"
        mapView.addAnnotation(annotation)
        
        //to add annotations to an array to remove easily
        customAnnotations.append(annotation)

        // Optionally, you can zoom to the added pin
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations location: [CLLocation]) {
        
        if isStartButtonClicked {
            stopTrip.isEnabled = true
        }else{
            stopTrip.isEnabled = false
        }
        
        if tripIsStarted {
            guard let newLocation = location.last else { return }

            if let previousLocation = locationCurrent {
                
                //getting distance and updating
                let distance = newLocation.distance(from: previousLocation)
                distanceCovered += distance

                //speed; 3.6 is multiplied to get speed in kilometer/hour
                let speed = newLocation.speed * 3.6
                currentSpeed = speed

                //speed
                maxSpeed = max(maxSpeed, speed)
                
                //calculating timeTakenForTrip based on previous location
                timeTakenForTrip += newLocation.timestamp.timeIntervalSince(previousLocation.timestamp)

                //average speed
                averageSpeed = distanceCovered / timeTakenForTrip

                //maximum acceleration
                let differenceInTime = newLocation.timestamp.timeIntervalSince(previousLocation.timestamp)
                if differenceInTime > 0 {
                    let acceleration = (speed - previousLocation.speed * 3.6) / differenceInTime
                    let absoluteAcceleration = abs(acceleration)
                    maxAcceleration = max(maxAcceleration, absoluteAcceleration)
                }
                                           
                //update all values in view
                getTripSummary()
                
                //to update mapview
                getMapUpdatedWithNewLocation(with: newLocation)
            }

            //to update start location
            if locationStart == nil {
                locationStart = newLocation
            }
            locationCurrent = newLocation
        }
    }
    
    //updating values based on updated location
        func getTripSummary() {
            
            //updating all labels in the view
            labelCurrentSpeed.text = String(format: "%.2f", currentSpeed) + "km/h"
            labelAverageSpeed.text = String(format: "%.2f", averageSpeed) + "km/h"
            labelMaxSpeed.text = String(format: "%.2f", maxSpeed) + "km/h"
            labelDistance.text = String(format: "%.2f", distanceCovered) + "km"
            labelMaxAcceleration.text = String(format: "%.2f", maxAcceleration) + "m/s^2"
            
            //changing top bar color to red when speed limit crosses 115
            if maxSpeed > 115.0 {
                labelOverSpeed.backgroundColor = UIColor.red
                
                //getting total distance covered before crossing speed limit
                if !isDistanceTravelledBeforeOverSpeedStored {
                    isDistanceTravelledBeforeOverSpeedStored = true
                    distanceTravelledBeforeOverSpeed = distanceCovered
                }
            } else {
                
                labelOverSpeed.backgroundColor = UIColor.clear
                
                //getting total distance covered before crossing speed limit
                if !isDistanceTravelledBeforeOverSpeedStored {
                    distanceTravelledBeforeOverSpeed = distanceCovered
                }
            }
        }
    
    //to show distance covered before crossing the speed limit
    func showDistanceAsAlert() {
        
        //title and msg to the Alert
        let alertController = UIAlertController(title: "Distance travelled before crossing Speed limt", message: String(format: "%.2f", distanceTravelledBeforeOverSpeed) + "km", preferredStyle: .alert)

        //if 'OK' is pressed, the alert will be dismissed
        let cancelAction = UIAlertAction(title: "OK", style: .cancel)

        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
        
    //to update map view
    func getMapUpdatedWithNewLocation(with location: CLLocation) {
        let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
   
    override func viewDidAppear(_ animated: Bool) {
        //making map visible and set to initial location
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        mapView.showsUserLocation = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //initializing values
        resetAllValues()
    }


}

