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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = noteTitle
        noteLabel.text = note
    }
}
