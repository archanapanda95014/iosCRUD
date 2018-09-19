//
//  MainVC.swift
//  toDoNew
//
//  Created by Archana Panda on 9/18/18.
//  Copyright © 2018 Archana Panda. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var tableData: [ToDoListNew] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self as UITableViewDelegate
        tableView.dataSource = self as UITableViewDataSource
        tableData = fetchData()
    }

 
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nav = segue.destination as! UINavigationController
        let dest = nav.topViewController as! AddItemVC
        dest.delegate = self
        
        if let indexPath = sender as? IndexPath{
            print("asdfgh")
            let data = tableData[indexPath.row]
            dest.indexPath = indexPath
            dest.titleStr = data.title!
            dest.notesStr = data.notes!
            dest.date =  data.dateOfItem
        }
        
    }
    func fetchData() ->[ToDoListNew]{
        
        var items:[ToDoListNew] = []
        let fetchRequest:NSFetchRequest = ToDoListNew.fetchRequest()
        
        do {
            items = try context.fetch(fetchRequest)
        } catch{
            print("FAILED")
        }
        return items
    }
    
}
extension MainVC:  AddItemVCDelegate{
    func addItem(_ title: String, _ notes: String, _ date: Date, _ indexPath:IndexPath?) {
        let item: ToDoListNew
        
        if let indexPath = indexPath{
            item = tableData[indexPath.row]
        }else {
            item = ToDoListNew(context: context)
            tableData.append(item)
        }
        item.dateOfItem = date
        item.notes = notes
        item.title = title
        saveContext()
        
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    
    }
}

extension MainVC:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"MyCell", for: indexPath) as! MyCell
        let data = tableData[indexPath.row]
        
        cell.titleField?.text = data.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        cell.dateField?.text =  dateFormatter.string(from: data.dateOfItem!)
        
        cell.notesField?.text = data.notes
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "delete"){
            action,view,done in
            
            let item = self.tableData[indexPath.row]
            self.context.delete(item)
            self.saveContext()
            self.tableData.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            done(true)
        }
        
        let edit = UIContextualAction(style: .normal, title: "edit"){
            action,view,done in
            self.performSegue(withIdentifier: "AddEditSegue", sender: indexPath)
        }
        edit.backgroundColor = .blue
        
        let done = UIContextualAction(style: .normal, title: "done"){
            action,view,done in
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = .checkmark
                self.saveContext()
                done(true)
            }
        }
        
        let actions:[UIContextualAction] = [delete, edit,done]
        return UISwipeActionsConfiguration(actions: actions)
}
}
