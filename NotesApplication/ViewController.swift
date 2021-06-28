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
        title = "Notes"
        table.delegate = self
        table.dataSource = self
    }
    
    @IBAction func addBtnClcked(){
        
    }
    
    // Table func:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cel", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        cell.detailTextLabel?.text = models[indexPath.row].note
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Show note controller
        guard let viewController = storyboard?.instantiateViewController(identifier: "notes") as? NotesViewController else{
            return
        }
        
        viewController.title = "Note"
        navigationController?.pushViewController(viewController, animated: true)
    }
}

