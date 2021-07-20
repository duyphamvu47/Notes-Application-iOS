//
//  PictureCollectionView.swift
//  NotesApplication
//
//  Created by Vu Duy on 02/07/2021.
//

import UIKit

private let reuseIdentifier = "Cell"

class PictureCollectionView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!

    public var imageList:[String] = []
    public var completion: (([String]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    override func viewWillDisappear(_ animated: Bool) {
        completion?((imageList))
    }
    
    // CollectionView func
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = storyboard?.instantiateViewController(identifier: "Pic detail") as? Picture else{
            return
        }
        viewController.title = "Picture"
        viewController.navigationItem.largeTitleDisplayMode = .never
        viewController.imageName = imageList[indexPath.row]
        viewController.completion = { result in
            self.navigationController?.popViewController(animated: true)
            if result {
                self.imageList.remove(at: indexPath.row)
                collectionView.deleteItems(at: [indexPath])
            }
        }
        navigationController?.pushViewController(viewController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageToShow = getSavedImage(named: imageList[indexPath.row])
        if imageToShow == nil {
            imageList.remove(at: indexPath.row)
            collectionView.reloadData()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PictureCollectionCell.identifier, for: indexPath) as? PictureCollectionCell
        cell!.imageView.image = imageToShow
        return cell!

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/3 - 3, height: view.frame.size.width/3 - 3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    // Support function
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
        var flag = true
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            flag = saveImage(image: editedImage.withRenderingMode(.alwaysOriginal))
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            flag = saveImage(image: originalImage.withRenderingMode(.alwaysOriginal))
        }
        dismiss(animated: true, completion: nil)
        if !flag {
            let alert = UIAlertController(title: "Error", message: "Error when loading image", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func localTime(in timeZone: String) -> String {
        let format = ISO8601DateFormatter()
        format.formatOptions = [.withInternetDateTime]
        format.timeZone = TimeZone(identifier: timeZone)
        return format.string(from: Date())
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

