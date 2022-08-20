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
class SearchViewController: UITableViewController {
    
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
        cell.textLabel?.text = "\(track.trackName ?? "")\n\(track.artistName)"
        cell.textLabel?.numberOfLines = 2
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    //Метод буде спацьовувати кожний раз коли ми будемо ввводити символ
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //Запускаємо його
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            
            let url = "https://itunes.apple.com/search"
            let parametrs = ["term": "\(searchText)", "limit": "10"]
            
            //Робимо запит з парамитрами
            AF.request(url, method: .get, parameters: parametrs).responseData { dataResponse in
                if let error = dataResponse.error {
                    print("Error received requestiong data: \(error)")
                    return
                }
                
                guard let data = dataResponse.data else { return }
                
                let decoder = JSONDecoder()
                do {
                    let object = try decoder.decode(SearchResponse.self, from: data)
                    print(object)
                    //Заповнюємо масив данними
                    self.tracks = object.results
                    self.tableView.reloadData()
                } catch let jsonError {
                    print(jsonError.localizedDescription)
                }
                
            }
        })
    }
}
