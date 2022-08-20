//
//  SearchViewController.swift
//  IMusic
//
//  Created by Andriy on 20.08.2022.
//

import UIKit

struct TrackModel {
    var trackName: String
    var artistName: String
}

//Це буде контроллер пошуку музики - сюди будуть з нету приходити дані музики тому і UITableViewController
class SearchViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let tracks = [TrackModel(trackName: "bad guy", artistName: "Billie Eilish"),
                 TrackModel(trackName: "bury a friend", artistName: "Billie Eilish")
    ]
    
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

extension SearchViewController: UISearchBarDelegate {
    
    //Метод буде спацьовувати кожний раз коли ми будемо ввводити символ
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}
