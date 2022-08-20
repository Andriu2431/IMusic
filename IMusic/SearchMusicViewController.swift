//
//  SearchViewController.swift
//  IMusic
//
//  Created by Andriy on 20.08.2022.
//

import UIKit
import Alamofire

struct TrackModel {
    var trackName: String
    var artistName: String
}

//Це буде контроллер пошуку музики - сюди будуть з нету приходити дані музики тому і UITableViewController
class SearchMusicViewController: UITableViewController {
    
    var networkServise = NetworkServise()
    //Зробимо таймер
    private var timer: Timer?
    let searchController = UISearchController(searchResultsController: nil)
    //Декодовані треки
    var tracks = [Trask]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    //Створення та насройка searchBar
    private func setupSearchBar() {
        //Вставимо в navItem searchBar
        navigationItem.searchController = searchController
        //Для того щоб він появлявся зразу а не при свайпі
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let track = tracks[indexPath.row]
        cell.imageView?.image = #imageLiteral(resourceName: "Image")
        cell.textLabel?.text = "\(track.trackName)\n\(track.artistName)"
        cell.textLabel?.numberOfLines = 2
        return cell
    }
}

extension SearchMusicViewController: UISearchBarDelegate {
    
    //Метод буде спацьовувати кожний раз коли ми будемо ввводити символ
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //Запускаємо його
        timer?.invalidate()
        
        //Таймер для того щоб запит не робився після кожного символу а чекав 0.5 секунди
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            self.networkServise.fetchTracks(searchText: searchText) { [weak self] searchResults in
                self?.tracks = searchResults?.results ?? []
                self?.tableView.reloadData()
            }
        })
    }
}
