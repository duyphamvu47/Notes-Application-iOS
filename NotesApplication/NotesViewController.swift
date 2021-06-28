//
//  NotesViewController.swift
//  NotesApplication
//
//  Created by Vu Duy on 28/06/2021.
//

import UIKit

class NotesViewController: UIViewController {
    @IBOutlet var title_label: UITextField!
    @IBOutlet var note_label: UITextView!
    
    public var noteTitle: String = ""
    public var note: String = ""
    
    public var completion: ((String, String)-> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title_label.text = noteTitle
        note_label.text = note
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveBtnClicked))
    }
    
    @objc func saveBtnClicked(){
        if let editedTitle = title_label.text, !editedTitle.isEmpty, let editedNote = note_label.text, !editedNote.isEmpty{
            completion?(editedTitle, editedNote)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
