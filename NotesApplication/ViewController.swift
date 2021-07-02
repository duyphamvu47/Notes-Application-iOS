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
    @IBOutlet weak var searchBar: UISearchBar!
    
    var goToDetailView:Bool = false
    
    var searchResult:[Note] = []
    var isSearching:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadNote()
        table.delegate = self
        table.dataSource = self
        title = "Notes"
    }


    
    // Create new note
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
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // Table func:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching{
            return searchResult.count
        }
        return noteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if isSearching{
            cell.textLabel?.text = searchResult[indexPath.row].title
            cell.detailTextLabel?.text = searchResult[indexPath.row].note
        }
        else{
            cell.textLabel?.text = noteList[indexPath.row].title
            cell.detailTextLabel?.text = noteList[indexPath.row].note
        }
        return cell
    }
    
    // View detail and edit cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Show note controller
        guard let viewController = storyboard?.instantiateViewController(identifier: "note") as? NotesViewController else{
            return
        }
        
        var noteToDisplay:Note = Note(title: "", note: "")
        let index:Int = indexPath.row

        if isSearching{
            noteToDisplay = searchResult[indexPath.row]
        }
        else{
            noteToDisplay = noteList[indexPath.row]
        }
        
        viewController.navigationItem.largeTitleDisplayMode = .never
        viewController.title = "Note"
        viewController.noteTitle = noteToDisplay.title
        viewController.note = noteToDisplay.note
        viewController.completion = {title, note in
            self.navigationController?.popToRootViewController(animated: true)
            let newNote = Note(title: title, note: note)
            
            if self.isSearching{
                if let row = noteList.firstIndex(where: {$0.title.lowercased() == noteToDisplay.title || $0.note.lowercased() == noteToDisplay.note}){
                    
                    noteList[row] = newNote
                }
                
                self.searchResult[index] = newNote
                
            }else{
                noteList[index] = newNote
            }
            self.label.isHidden = true
            self.table.isHidden = false
            self.saveNote()
            self.loadNote()
            
            if self.isSearching{
                self.table.reloadData()
            }
        }
        goToDetailView = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // delete cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            if isSearching{
                if let index = noteList.firstIndex(where: {$0.title.lowercased() == searchResult[indexPath.row].title.lowercased()}){
                    
                    noteList.remove(at: index)
                }
                searchResult.remove(at: indexPath.row)
            }else{
                noteList.remove(at: indexPath.row)
            }
            self.saveNote()
            self.loadNote()
        }
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
        self.table.reloadData()
    }
}

extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.count > 0){
            searchResult = noteList.filter({$0.title.lowercased().contains(searchText.lowercased()) ||
                $0.note.lowercased().contains(searchText.lowercased())})
            isSearching = true
        }else{
            isSearching = false
        }
        table.reloadData()

    }
}

