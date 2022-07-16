//
//  journalHelper.swift
//  MoodTrackingApp
//
//  Created by Paulina Guzior on 15/07/2022.
//

import UIKit

class journalHelper: UIViewController{
    
    @IBOutlet var tableView: UITableView!
    
    var models = [(title: String, note: String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        updateNotes()
    }
    
    func updateNotes(){
        models.removeAll()
        guard let count = UserDefaults().value(forKey: "count") as? Int else{
            return
        }
        for x in 0..<count{
            if let newnote = UserDefaults().value(forKey: "note_\(count-x)") as? String{
                if let newtitle = UserDefaults().value(forKey: "title_\(count-x)") as? String{
                    self.models.append((title: newtitle, note: newnote))
                }
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func didTapNewNote(){
        let vc = storyboard?.instantiateViewController(identifier: "new") as! EntryViewController
        vc.update = {
            DispatchQueue.main.async{
                self.updateNotes()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension journalHelper: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(identifier: "note") as! NoteViewController
        vc.noteTitle = models[indexPath.row].title
        vc.note = models[indexPath.row].note
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension journalHelper: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        cell.detailTextLabel?.text = models[indexPath.row].note
        return cell
    }
}
