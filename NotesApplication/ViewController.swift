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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadNote()
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
            noteList.append(Note(title: title, note: note))
            self.label.isHidden = true
            self.table.isHidden = false
            self.saveNote()
            self.loadNote()
            self.table.reloadData()
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // Table func:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = noteList[indexPath.row].title
        cell.detailTextLabel?.text = noteList[indexPath.row].note
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let noteToDisplay = noteList[indexPath.row]
        
        //Show note controller
        guard let viewController = storyboard?.instantiateViewController(identifier: "note") as? NotesViewController else{
            return
        }
        viewController.navigationItem.largeTitleDisplayMode = .never
        viewController.title = "Note"
        viewController.noteTitle = noteToDisplay.title
        viewController.note = noteToDisplay.note
        viewController.completion = {title, note in
            self.navigationController?.popToRootViewController(animated: true)
            let newNote = Note(title: title, note: note)

            if let row = noteList.firstIndex(where: {$0.title == title || $0.note == note}) {
                   noteList[row] = newNote
            }
            else{
                noteList.append(newNote)
            }
            self.label.isHidden = true
            self.table.isHidden = false
            self.saveNote()
            self.loadNote()
            self.table.reloadData()
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    func saveNote(){
        do{
            let encoder = JSONEncoder()
            let data = try encoder.encode(noteList)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch{
            print("Unable to encode Note array(\(error))")
        }
        print("SaveData: ", noteList)
    }
    
    func loadNote(){
        if let data = UserDefaults.standard.data(forKey: storageKey){
            do{
                let decoder = JSONDecoder()
                noteList = try decoder.decode([Note].self, from: data)
            }catch{
                print("Unable to decode Note array(\(error))")
            }
        }
        print("LoadData: ", noteList)
        
    }
}

