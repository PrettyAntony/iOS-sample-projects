//
//  NewsTableViewController.swift
//  Pretty_Antony_FE_8935790
//
//  Created by user234138 on 12/2/23.
//

import UIKit
import SafariServices

class NewsTableViewController: UITableViewController {
    
    //variable declaration
    var receivedCityName: String?
    var receivedSourceOfTransaction: String?
    
    var newsArticlesArray = [Article]()
    var cityName = ""
    var sourceOfTransaction = ""
    
    var history : [History]?
    
    let content = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var newsTableView: UITableView!
    
    
    //on clicking '+' button, to show alert
    @IBAction func checkForNewCity(_ sender: UIBarButtonItem) {
        
        showAlertToAddCity()
    }
    
    func navigateToMapScene(){
        // Instantiate the map view controller from the storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Use your storyboard name
            if let mapViewController = storyboard.instantiateViewController(withIdentifier: "Map") as? MapViewController {
                
                // Pass data to the second view controller
                mapViewController.receivedCityName = self.cityName
                mapViewController.receivedSourceOfTransaction = "From News"
                
                navigationController?.pushViewController(mapViewController, animated: false)
                
            }
    }
    
    func navigateToWeatherScene(){
        // Instantiate the weather view controller from the storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Use your storyboard name
            if let weatherViewController = storyboard.instantiateViewController(withIdentifier: "Weather") as? WeatherViewController {
                
                // Pass data to the second view controller
                weatherViewController.receivedCityName = self.cityName
                weatherViewController.receivedSourceOfTransaction = "From News"
                
                navigationController?.pushViewController(weatherViewController, animated: false)
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Access and use the received data
        
        self.cityName = receivedCityName ?? "Waterloo"
        self.sourceOfTransaction = receivedSourceOfTransaction ?? "From Home"
        
        
        getNewsInformation()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        //setting title custom needed
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        // Set the back button color
        self.navigationController?.navigationBar.tintColor = UIColor.black
        //setting back button as home image
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "homekit"), style: .plain, target: self, action:#selector(goBack))
        
        newsTableView.delegate = self
        newsTableView.dataSource = self
    }
    
    @objc func goBack() {
            navigationController?.popToRootViewController(animated: true)
        }
    
    
    func navigateToMapScene(cityName : String){
        // Instantiate the map view controller from the storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Use your storyboard name
            if let mapViewController = storyboard.instantiateViewController(withIdentifier: "Map") as? MapViewController {
                
                // Pass data to the second view controller
                mapViewController.receivedCityName = cityName
                mapViewController.receivedSourceOfTransaction = "From News"
                
                navigationController?.pushViewController(mapViewController, animated: false)
                
            }
    }
    
    func navigateToWeatherScene(cityName : String){
        // Instantiate the weather view controller from the storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Use your storyboard name
            if let weatherViewController = storyboard.instantiateViewController(withIdentifier: "Weather") as? WeatherViewController {
                
                // Pass data to the second view controller
                weatherViewController.receivedCityName = cityName
                weatherViewController.receivedSourceOfTransaction = "From News"
                
                navigationController?.pushViewController(weatherViewController, animated: false)
            }
    }
    
    func showAlertToAddCity() {
        
        //title and msg to the Alert
        let alertController = UIAlertController(title: "Add a City to check News", message: nil, preferredStyle: .alert)

        //adding value to the placeholder in the alert
        alertController.addTextField { textField in
            textField.placeholder = "Add your city here"
        }

        //on adding, item is appended and array is updated and reloaded.
        let searchAction = UIAlertAction(title: "Search", style: .default) { _ in
            if let newItem = alertController.textFields?.first?.text, !newItem.isEmpty {
                self.cityName = newItem
                self.sourceOfTransaction = "From News"
                self.getNewsInformation()
            }
        }

        //if cancel is pressed, the action will be cancelled
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(searchAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    
    //weather api call function
    func getNewsInformation(){
        
        //newsapi service
        let newsApiCall = newsApi+"q="+self.cityName+"&apiKey="+newsApiKey+"&sortBy=publishedAt"
        
        print(newsApiCall)
        
        // Note this shouls be a VAR in when used in an application as the URL value will change with each call!
        // Create an instance of a URLSession Class and assign the value of your URL to the The URL in the Class
        let urlSession = URLSession(configuration:.default)
        let url = URL(string: newsApiCall)

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
                        let readableData = try jsonDecoder.decode(NewsData.self, from: data)
                            
                        //getting array
                        DispatchQueue.main.async {
                            self.newsArticlesArray = readableData.articles
                            self.newsTableView.reloadData()
                            
                            self.saveNewsDetails()
                        }
                        
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
    
    func saveNewsDetails(){
        
        let history = History(context: self.content)
        
        history.cityName = self.cityName
        history.sourceOfTransaction = self.sourceOfTransaction
        history.typeOfTransaction = "News"
        
        history.newsTitle = newsArticlesArray[0].title
        history.newsDescription = newsArticlesArray[0].description
        history.newsAuthor = newsArticlesArray[0].author ?? ""
        history.newsSource = newsArticlesArray[0].source.name
        
    
        do{
            try self.content.save()
            //print(history.startPlace!)
        }catch{
            print("Error saving data")
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articles = newsArticlesArray[indexPath.row]
        guard let url = URL(string: articles.url ) else {
            return
        }
            
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newsArticlesArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsTableViewCell

        // Configure the cell...
        let newsTitle = self.newsArticlesArray[indexPath.row].title
        let description = self.newsArticlesArray[indexPath.row].description
        let newsAuthor = self.newsArticlesArray[indexPath.row].author
        let newsSource = self.newsArticlesArray[indexPath.row].source.name
        
        if let authorName = newsAuthor, !authorName.isEmpty {
            // If title is not nil and not empty, display it
            cell.labelAuthor.text = authorName
        }else {
            // If title is nil or empty, display a placeholder or handle it as needed
            cell.labelAuthor.text = ""
            
        }

        cell.labelNewsTitle.text = newsTitle
        cell.newsDescription.text = description
        cell.labelSource.text = newsSource.isEmpty ? "" : newsSource
        
        
        //fetching image from NewsApi and load in UIImageView
        if let imageUrl = self.newsArticlesArray[indexPath.row].urlToImage , let url = URL(string: imageUrl) {
                        DispatchQueue.global().async {
                            if let imageData = try? Data(contentsOf: url) {
                                DispatchQueue.main.async {
                                    // Check if the cell is still visible
                                    if let currentIndexPath = tableView.indexPath(for: cell), currentIndexPath == indexPath {
                                        cell.newsImage.image = UIImage(data: imageData)
                                    }
                                }
                            }
                        }
        }else{ //setting default image
            cell.newsImage.image = UIImage(named: "DefaultImage")
        }

        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            let footerView = UIView()
            footerView.backgroundColor = UIColor.white // Set the background color as needed

            // Create buttons programatically with system icons for News, Map, and Weather
            let newsButton = createButton(title: "News", systemName: "newspaper", action: #selector(onNewsButtonClicked))
            let mapButton = createButton(title: "Direction", systemName: "map", action: #selector(onMapButtonClicked))
            let weatherButton = createButton(title: "Weather", systemName: "wind", action: #selector(onWeatherButtonClicked))

            // Adding buttons to the footer view
            footerView.addSubview(newsButton)
            footerView.addSubview(mapButton)
            footerView.addSubview(weatherButton)

            // Adding constraints to align buttons in the footer view
            NSLayoutConstraint.activate([
                newsButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
                newsButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),

                mapButton.leadingAnchor.constraint(equalTo: newsButton.trailingAnchor, constant: 30),
                mapButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),

                weatherButton.leadingAnchor.constraint(equalTo: mapButton.trailingAnchor, constant: 30),
                weatherButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            ])

            return footerView
        }

    //customising the button
    func createButton(title: String, systemName: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setImage(UIImage(systemName: systemName), for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .black
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true

        return button
    }
    
    @objc func onNewsButtonClicked() {
        //do nothing
    }

    @objc func onMapButtonClicked() {
        self.navigateToMapScene()
    }

    @objc func onWeatherButtonClicked() {
        self.navigateToWeatherScene()
    }
        
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50.0 // Set the desired height of the footer view
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
