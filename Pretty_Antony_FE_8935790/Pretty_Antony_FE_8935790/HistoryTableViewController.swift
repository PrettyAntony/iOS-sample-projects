//
//  HistoryTableViewController.swift
//  Pretty_Antony_FE_8935790
//
//  Created by user234138 on 12/2/23.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    @IBOutlet var historyTableView: UITableView!
    
    var history : [History]?
    
    let content = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        fetchHistory()
    }
    
    func fetchHistory(){
        
        do {
            self.history = try content.fetch(History.fetchRequest())
        } catch{
            
            print("no data")
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return history?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryTableViewCell

        // Configure the cell...
        let cityName = self.history?[indexPath.row].cityName!
        let sourceOfTransaction = self.history?[indexPath.row].sourceOfTransaction!
        let typeOfTransaction = self.history?[indexPath.row].typeOfTransaction!
        
        if(typeOfTransaction == "Weather"){
            
            let temparature = self.history?[indexPath.row].temperature ?? ""
            let humidity = self.history?[indexPath.row].humidity ?? ""
            let wind = self.history?[indexPath.row].wind ?? ""
            
            // Check if the string is not nil and not empty
            if let dateTimeString = self.history?[indexPath.row].dateTime, !dateTimeString.isEmpty {
                // Split the string into an array of substrings
                let dateTimeArray = dateTimeString.split(separator: " ")

                cell.labelItem6.text = "Date: "+String(dateTimeArray[0])+" Time: "+String(dateTimeArray[1])
                cell.labelItem6.textAlignment = .left
            }
            cell.labelItem5.text = temparature+"\n"+humidity+"\n"+wind
            
            cell.labelItem5.textAlignment = .center // Set text alignment
            cell.labelItem5.backgroundColor = UIColor(red: 0, green: 0, blue: 128/255, alpha: 1.0) // Set navy blue background color
            cell.labelItem5.textColor = UIColor.white
            
        }else if(typeOfTransaction == "Directions"){
            
            let startCity = self.history?[indexPath.row].startPlace ?? ""
            let endCity = self.history?[indexPath.row].endPlace ?? ""
            let distance = self.history?[indexPath.row].totalDistance ?? ""
            let modeOfTransport = self.history?[indexPath.row].modeOfTransport ?? ""
            
            cell.labelItem6.text = ""
            cell.labelItem5.text = "From: "+startCity+"\n\nTo: "+endCity+"\n\nMethod of Travel: "+modeOfTransport+"\n\nTotal Distance: "+distance
            
            cell.labelItem5.textAlignment = .center // Set text alignment
            cell.labelItem5.backgroundColor = UIColor.white
            cell.labelItem5.textColor = UIColor.black
            
        }else if(typeOfTransaction == "News"){
            
            let newsTitle = self.history?[indexPath.row].newsTitle ?? ""
            let newsDescription = self.history?[indexPath.row].newsDescription ?? ""
            let newsSource = self.history?[indexPath.row].newsSource ?? ""
            let newsAuthor = self.history?[indexPath.row].newsAuthor ?? ""
            
            cell.labelItem6.text = newsTitle
            cell.labelItem5.text = newsDescription+"\nAuthor:"+newsAuthor+"\nSource:"+newsSource
            
            cell.labelItem5.textAlignment = .justified // Set text alignment
            cell.labelItem5.backgroundColor = UIColor.white
            cell.labelItem5.textColor = UIColor.black
        }
        

        cell.labelCityName.text = cityName
        cell.labelSourceOfTransaction.text = sourceOfTransaction
        cell.labelTypeOfTransaction.text = typeOfTransaction

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the row so it doesn't remain highlighted
        tableView.deselectRow(at: indexPath, animated: true)
        
        let typeOfTransportation = self.history?[indexPath.row].typeOfTransaction ?? ""
        let cityName = self.history?[indexPath.row].cityName ?? ""
        
        //navigating to map and weather
        if(typeOfTransportation == "Directions"){
            self.navigateToMapScene(cityName: cityName)
        }else if(typeOfTransportation == "Weather"){
            self.navigateToWeatherScene(cityName: cityName)
        }
        
    }
    
    
    func navigateToMapScene(cityName : String){
        // Instantiate the map view controller from the storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Use your storyboard name
            if let mapViewController = storyboard.instantiateViewController(withIdentifier: "Map") as? MapViewController {
                
                // Pass data to the second view controller
                mapViewController.receivedCityName = cityName
                mapViewController.receivedSourceOfTransaction = "From History"
                
                navigationController?.popToRootViewController(animated: true)
                
                navigationController?.pushViewController(mapViewController, animated: false)
                
            }
    }
    
    func navigateToWeatherScene(cityName : String){
        // Instantiate the map view controller from the storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Use your storyboard name
            if let weatherViewController = storyboard.instantiateViewController(withIdentifier: "Weather") as? WeatherViewController {
                
                // Pass data to the second view controller
                weatherViewController.receivedCityName = cityName
                weatherViewController.receivedSourceOfTransaction = "From History"
                
                navigationController?.popToRootViewController(animated: true)
                
                navigationController?.pushViewController(weatherViewController, animated: false)
            }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            //show alert before deletion
            showDeleteConfirmationAlert(indexPath: indexPath)
        }
    }
    
    func showDeleteConfirmationAlert(indexPath: IndexPath) {
            let alertController = UIAlertController(title: "Delete Item", message: "Are you sure you want to delete this item?", preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)

            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                // Perform the deletion
                self?.deleteRow(at: indexPath)
            }
            alertController.addAction(deleteAction)

            present(alertController, animated: true, completion: nil)
        }

        func deleteRow(at indexPath: IndexPath) {
            let deleteItem = self.history?[indexPath.row]
            self.content.delete(deleteItem!)
            
            do{
                try self.content.save()
            }catch{
                print("Error saving data")
            }
            // Delete the row from the data source
            self.history?.remove(at: indexPath.row)
            self.historyTableView.deleteRows(at: [indexPath], with: .fade)
        }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
