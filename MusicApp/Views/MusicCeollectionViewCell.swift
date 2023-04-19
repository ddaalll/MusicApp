//
//  MusicCeollectionViewCell.swift
//  MusicApp1
//
//  Created by DalHyun Nam on 2023/04/03.
//

import UIKit


final class MusicCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    var imageUrl: String? {
        didSet {
            loadImage()
        }
    }
    
    
    private func loadImage() {
        guard let urlString = self.imageUrl, let url = URL(string: urlString) else { return }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            
            guard self.imageUrl! == url.absoluteString else { return }
            
            DispatchQueue.main.async {
                self.mainImageView.image = UIImage(data: data)
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.mainImageView.image = nil
    }
}








