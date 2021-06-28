//
//  ViewController.swift
//  NotesApplication
//
//  Created by Vu Duy on 28/06/2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var table:UITableView!
    @IBOutlet var label:UILabel!
    
    var models : [(title: String, note: String)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        title = "Notes"
    }
    
    @IBAction func addBtnClcked(){
        guard let viewController = storyboard?.instantiateViewController(identifier: "new") as? EntryViewController else{
            return
        }
        
        viewController.title = "New Note"
        viewController.navigationItem.largeTitleDisplayMode = .never
        viewController.completion = {title, note in
            self.navigationController?.popToRootViewController(animated: true)
            self.models.append((title: title, note: note))
            self.label.isHidden = true
            self.table.isHidden = false
            self.table.reloadData()
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // Table func:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        cell.detailTextLabel?.text = models[indexPath.row].note
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let noteToDisplay = models[indexPath.row]
        
        //Show note controller
        guard let viewController = storyboard?.instantiateViewController(identifier: "note") as? NotesViewController else{
            return
        }
        viewController.navigationItem.largeTitleDisplayMode = .never
        viewController.title = "Note"
        viewController.noteTitle = noteToDisplay.title
        viewController.note = noteToDisplay.note
        navigationController?.pushViewController(viewController, animated: true)
    }
}

