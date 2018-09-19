//
//  AddItemVC.swift
//  toDoNew
//
//  Created by Archana Panda on 9/18/18.
//  Copyright © 2018 Archana Panda. All rights reserved.
//

import UIKit

protocol AddItemVCDelegate{
    func addItem(_ title:String, _ notes:String, _ date:Date,_ indexPath:IndexPath?)
}

class AddItemVC: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var notesField: UITextField!
    @IBOutlet weak var dateField: UIDatePicker!
    var indexPath: IndexPath?
    var titleStr = ""
    var notesStr = ""
    var date: Date?
    
    var delegate: AddItemVCDelegate?
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        delegate?.addItem(titleField.text!, notesField.text!, dateField.date, indexPath)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.text = titleStr
        notesField.text = notesStr
        if let temp = date {
            dateField.date = temp
        }
    }

}
