//
//  Picture.swift
//  NotesApplication
//
//  Created by Vu Duy on 03/07/2021.
//

import UIKit

class Picture: UIViewController {
    @IBOutlet var imageView:UIImageView!
    public var imageName:String = ""
    public var completion: ((Bool)-> Void)?         // true: delete image

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deleteImage))
        
        let imageToShow = getSavedImage(named: imageName)
        if imageToShow == nil{
            let alert = UIAlertController(title: "Error", message: "Error when loading image", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            _ = navigationController?.popViewController(animated: true)
        }
        imageView.image = imageToShow
    }
    
    
    @objc func deleteImage(){
        completion?((true))
        _ = navigationController?.popViewController(animated: true)
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
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
