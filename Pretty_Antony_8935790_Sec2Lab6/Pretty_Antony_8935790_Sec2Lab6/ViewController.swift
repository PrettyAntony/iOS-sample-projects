//
//  ViewController.swift
//  Pretty_Antony_8935790_Sec2Lab6
//
//  Created by user234138 on 10/20/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var todoListTable: UITableView!
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        showAddToDoAlert()
    }
    
    var todoListItems = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoListItems.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoListCell", for: indexPath) as! CustomTableViewCell

        let itemNam = self.todoListItems[indexPath.row]
        cell.itemName?.text = itemNam
        //cell.textLabel?.text = todoListItems[indexPath.row]
        
        cell.buttonDeleteAction = {[weak self] in self?.showDeleteItemAlert(at: indexPath)}
        

        return cell
    }
    
    func showAddToDoAlert() {
        let alertController = UIAlertController(title: "Add Item to ToDo", message: nil, preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "Add your item here"
        }

        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let newItem = alertController.textFields?.first?.text {
                self.todoListItems.append(newItem)
                self.todoListTable.reloadData()
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(addAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    
    func showDeleteItemAlert(at indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Delete item", message: "Are you sure to delete the item?", preferredStyle: .alert)

        let addAction = UIAlertAction(title: "Delete", style: .default) { _ in
            self.todoListItems.remove(at: indexPath.row)
            self.todoListTable.deleteRows(at: [indexPath], with: .fade)
            self.todoListTable.reloadData()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(addAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
//    func deleteItem(at indexPath: IndexPath) {
//            todoListItems.remove(at: indexPath.row)
//            todoListTable.deleteRows(at: [indexPath], with: .fade)
//        }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoListTable.dataSource = self
        todoListTable.delegate = self
    }


}

