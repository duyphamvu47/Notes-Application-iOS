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
    public var imageList:[String] = []
    
    public var completion: ((String, String, [String])-> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title_label.text = noteTitle
        note_label.text = note
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Pictures", style: .done, target: self, action: #selector(PictureBtnClicked))
    }
    
    @objc func PictureBtnClicked(){
        guard let viewController = storyboard?.instantiateViewController(identifier: "Pic") as? PictureCollectionView else{
            return
        }
        
        viewController.title = "Pictures"
        viewController.navigationItem.largeTitleDisplayMode = .never
        viewController.imageList = self.imageList
        viewController.completion = { list in
            self.imageList = list
            if let editedTitle = self.title_label.text, !editedTitle.isEmpty, let editedNote = self.note_label.text, !editedNote.isEmpty{
                self.completion?(editedTitle, editedNote, self.imageList)
            }
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let editedTitle = title_label.text, !editedTitle.isEmpty, let editedNote = note_label.text, !editedNote.isEmpty{
            completion?(editedTitle, editedNote, imageList)
        }
    }

    
//    func addImage(image: UIImage){
//        //create and NSTextAttachment and add your image to it.
//        let attachment = NSTextAttachment()
//        attachment.image = getSavedImage(named: imageName)
//        //put your NSTextAttachment into and attributedString
//        let attString = NSAttributedString(attachment: attachment)
//        //add this attributed string to the current position.
//        note_label.textStorage.insert(attString, at: note_label.selectedRange.location)
//    }

}


