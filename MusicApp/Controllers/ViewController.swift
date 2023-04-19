//
//  ViewController.swift
//  MusicApp1
//
//  Created by DalHyun Nam on 2023/04/01.
//

import UIKit

class ViewController: UIViewController {

    let searchController = UISearchController(searchResultsController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController)
    
    @IBOutlet weak var musicTableView: UITableView!
    
    var networkManager = NetworkManager.shared
    
    var musicArray: [Music] = []
    
    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupSearchBar()
        setupDatas()
    }

    func setupSearchBar() {
        self.title = "Music Search"
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
    }

    
    func setupTableView() {
        musicTableView.dataSource = self
        musicTableView.delegate = self
        
        musicTableView.register(UINib(nibName: Cell.musicCellIdentifier, bundle: nil), forCellReuseIdentifier: Cell.musicCellIdentifier)
    }
    
    func setupDatas() {
        networkManager.fetchMusic(searchTerm: "jazz") { result in
            switch result {
            case .success(let musicData):
                self.musicArray = musicData
                DispatchQueue.main.async {
                    self.musicTableView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.musicArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = musicTableView.dequeueReusableCell(withIdentifier: Cell.musicCellIdentifier, for: indexPath) as! MusicCell
        
        cell.imageUrl = musicArray[indexPath.row].imageUrl
        cell.songNameLabel.text = musicArray[indexPath.row].songName
        cell.artistNameLabel.text = musicArray[indexPath.row].artistName
        cell.albumNameLabel.text = musicArray[indexPath.row].albumName
        cell.releaseDateLabel.text = musicArray[indexPath.row].releaseDateString
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}


extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("서치바에 입력되는 단어", searchController.searchBar.text ?? "")
        let vc = searchController.searchResultsController as! SearchResultViewController
        
        vc.searchTerm = searchController.searchBar.text ?? ""
    }
}
//
//extension ViewController: UISearchBarDelegate {
//    func searchBar(_ searhBar: UISearchBar, textDidChange searchText: String) {
//        print(searchText)
//        self.musicArray = []
//
//        networkManager.fetchMusic(searchTerm: searchText) { result in
//            switch result {
//            case .success(let musicDatas):
//                self.musicArray = musicDatas
//                DispatchQueue.main.async {
//                    self.musicTableView.reloadData()
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//}
