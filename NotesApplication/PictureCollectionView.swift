//
//  PictureCollectionView.swift
//  NotesApplication
//
//  Created by Vu Duy on 02/07/2021.
//

import UIKit

private let reuseIdentifier = "Cell"

class PictureCollectionView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!

    public var imageList:[String] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.becomeFirstResponder()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(showChooseSourceTypeAlertController))
        collectionView.register(PictureCollectionCell.self, forCellWithReuseIdentifier: PictureCollectionCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.frame = .zero
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        view.addSubview(collectionView)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureCollectionCell.identifier, for: indexPath) as! PictureCollectionCell
//        cell.image = getSavedImage(named: imageList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/3 - 3, height: view.frame.size.height/3 - 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }

}
extension PictureCollectionView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func showChooseSourceTypeAlertController() {
        let photoLibraryAction = UIAlertAction(title: "Choose a Photo", style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        let cameraAction = UIAlertAction(title: "Take a New Photo", style: .default) { (action) in
            self.showImagePickerController(sourceType: .camera)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        AlertService.showAlert(style: .actionSheet, title: nil, message: nil, actions: [photoLibraryAction, cameraAction, cancelAction], completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            saveImage(image: editedImage.withRenderingMode(.alwaysOriginal))
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            saveImage(image: originalImage.withRenderingMode(.alwaysOriginal))
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func localTime(in timeZone: String) -> String {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        f.timeZone = TimeZone(identifier: timeZone)
        return f.string(from: Date())
    }
    
    
    func saveImage(image: UIImage) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            let imageName = localTime(in: "Asia/HaNoi")
            try data.write(to: directory.appendingPathComponent(imageName)!)
            imageList.append(imageName)
            collectionView.reloadData()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }

}

