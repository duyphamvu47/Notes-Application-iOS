//
//  EntryViewController.swift
//  NotesApplication
//
//  Created by Vu Duy on 28/06/2021.
//

import UIKit

class EntryViewController: UIViewController {
    @IBOutlet var titleField: UITextField!
    @IBOutlet var noteField: UITextView!
    
    public var completion: ((String, String)-> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        titleField.becomeFirstResponder()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveBtnClicked))
    }
    
    @objc func saveBtnClicked(){
        if let title = titleField.text, !title.isEmpty, let note = noteField.text, !note.isEmpty{
            completion?(title, note)
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
