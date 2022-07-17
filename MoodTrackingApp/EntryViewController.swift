//
//  EntryViewController.swift
//  MoodTrackingApp
//
//  Created by Paulina Guzior on 16/07/2022.
//

import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet var titleField: UITextField!
    @IBOutlet var noteField: UITextView!
    
    var selectedDate = Date()
    
    var update: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        noteField.delegate = self
        noteField.becomeFirstResponder()
        titleField.text = CalendarHelper().dayString(date: selectedDate) + " " + CalendarHelper().monthString(date: selectedDate) + " " + CalendarHelper().yearString(date: selectedDate)
        noteField.text = "Drogi pamiętniczku,\n"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title:"Zapisz", style: .done, target: self, action: #selector(didTapSave))
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        didTapSave()
        
        return true
    }
    
    @objc func didTapSave(){
        if let text = titleField.text, !text.isEmpty{
            if let text2 = noteField.text, !text2.isEmpty{
                guard let count = UserDefaults().value(forKey: "count") as? Int else{
                    return
                }
                let newCount = count + 1
                UserDefaults().set(newCount, forKey: "count")
                UserDefaults().set(text, forKey: "title_\(newCount)")
                UserDefaults().set(text2, forKey: "note_\(newCount)")
                update?()
                navigationController?.popViewController(animated: true)
            }
        }
    }
}
