//
//  PictureCollectionCell.swift
//  NotesApplication
//
//  Created by Vu Duy on 02/07/2021.
//

import UIKit

class PictureCollectionCell: UICollectionViewCell {
    static let identifier = "PictureCollectionViewCell"
    
    public var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
}
