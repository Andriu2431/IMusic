//
//  SearchViewController.swift
//  IMusic
//
//  Created by Andriy on 20.08.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchDisplayLogic: AnyObject {
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData)
}

class SearchViewController: UIViewController, SearchDisplayLogic {
    
    var interactor: SearchBusinessLogic?
    var router: (NSObjectProtocol & SearchRoutingLogic)?
    
    @IBOutlet weak var table: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    //Будемо зберігати тут масив треків
    private var searchViewModel = SearchViewModel.init(cells: [])
    //Зробимо таймер
    private var timer: Timer?
    //Це наш індикатор та лейбел загрузки 
    private lazy var footerView = FooterView()
    
    // MARK: Object lifecycle
    
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = SearchInteractor()
        let presenter             = SearchPresenter()
        let router                = SearchRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: Routing
    
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        setupSearchBar()
        setupTableView()
    }
    
    //Метод який створює searchBar
    private func setupSearchBar() {
        //Вставимо в navItem searchBar
        navigationItem.searchController = searchController
        //Для того щоб він появлявся зразу а не при свайпі
        navigationItem.hidesSearchBarWhenScrolling = false
        //Щоб екран не затемнювався при пошуку
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    //Метод рейструє контейнер
    private func setupTableView() {
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let nib = UINib(nibName: "TrackCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: TrackCell.reuseId)
        //Передаємо tableFooterView наше кастомне view на якамл індикатор загрузки з лейблом
        table.tableFooterView = footerView
    }
    
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
        
        switch viewModel {
        case .desplayTracks(searchViewModel: let searchViewModel):
            //Заповнюємо маисв
            self.searchViewModel = searchViewModel
            table.reloadData()
            //Коли данні занрузяться та таблиця обновиться то зупиним footerView
            footerView.hideLoader()
        case .displayFooterView:
            //Запускаємо FooterView
            footerView.showLoader()
        }
    }
    
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.reuseId, for: indexPath) as! TrackCell
        
        let cellViewModel = searchViewModel.cells[indexPath.row]
        cell.trackImageView.backgroundColor = .red
        //Заповнюємо елементи UI
        cell.set(viewModel: cellViewModel)
        return cell
    }
    
    //Тап на контейнер
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cellViewModel = searchViewModel.cells[indexPath.row]
        
        //Отримуємо вінко на якому находимось
        let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        //Беремо перший xib файл
        let trackDetailsView = Bundle.main.loadNibNamed("TrackDetailView", owner: self, options: nil)?.first as! TrackDetailView
        //Задамо розміри як на view
        trackDetailsView.frame = view.frame
        //Передаємо його щоб був над всією іерархією контроллерів
        window?.addSubview(trackDetailsView)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    //Це Header - label на tableView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter search term above."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }
    
    //Для того щоб Header пропав коли ми вводимо якісь значення
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //Скажемо якщо є контейнери то висота 0 якщо ні то 250
        return searchViewModel.cells.count > 0 ? 0 : 250
    }
}


// MARK: UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Запускаємо його
        timer?.invalidate()
        
        //Таймер для того щоб запит не робився після кожного символу а чекав 0.5 секунди
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            //Робим запит до interactor
            self.interactor?.makeRequest(request: .getTracks(searchTerm: searchText))
        })
    }
}
