//
//  NoteViewController.swift
//  MoodTrackingApp
//
//  Created by Paulina Guzior on 16/07/2022.
//

import UIKit

class NoteViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var noteLabel: UITextView!
    
    public var noteTitle: String?
    public var note: String?
    public var current: Int?
    
    var update: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = noteTitle
        noteLabel.text = note
        navigationItem.rightBarButtonItem = UIBarButtonItem(title:"Usuń", style: .done, target: self, action: #selector(didTapDelete))
    }
    
    @objc func didTapDelete(){
        guard let count = UserDefaults().value(forKey: "count") as? Int else { return }
        let newCount = count - 1
        UserDefaults().setValue(newCount, forKey: "count")
        guard let current = current else { return }
        UserDefaults().set(nil, forKey: "title_\(count-current)")
        UserDefaults().set(nil, forKey: "note_\(count-current)")
        for x in count-current...count{
            UserDefaults().set(UserDefaults().value(forKey:"title_\(x+1)"), forKey: "title_\(x)")
            UserDefaults().set(UserDefaults().value(forKey:"note_\(x+1)"), forKey: "note_\(x)")
        }
        update?()
        navigationController?.popViewController(animated: true)
    }
}
