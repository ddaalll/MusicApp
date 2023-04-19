//
//  SearchResultViewController.swift
//  MusicApp1
//
//  Created by DalHyun Nam on 2023/04/01.
//

import UIKit

final class SearchResultViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let flowLayout = UICollectionViewFlowLayout()
    
    let networkManager = NetworkManager.shared
    
    var musicArray: [Music] = []
    
    var searchTerm: String? {
        didSet {
            setupDatas()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupCollectionView()
    }
    
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        flowLayout.scrollDirection = .vertical
        
        let collectionCellWidth = (UIScreen.main.bounds.width - CVCell.spacingWitdh * (CVCell.cellColumns - 1)) / CVCell.cellColumns
        
        flowLayout.itemSize = CGSize(width: collectionCellWidth, height: collectionCellWidth)
        flowLayout.minimumInteritemSpacing = CVCell.spacingWitdh
        flowLayout.minimumLineSpacing = CVCell.spacingWitdh
        
        collectionView.collectionViewLayout = flowLayout
    }
    
    func setupDatas() {
        guard let term = searchTerm else { return }
        print("네트워킹 시작 단어 \(term)")
        
        self.musicArray = []
        
        networkManager.fetchMusic(searchTerm: term) { result in
            switch result {
            case .success(let musicDatas):
                self.musicArray = musicDatas
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.musicCollectionViewCellIdentifier, for: indexPath) as! MusicCollectionViewCell
        cell.imageUrl = musicArray[indexPath.row].imageUrl
        
        return cell
    }
    
  
}
