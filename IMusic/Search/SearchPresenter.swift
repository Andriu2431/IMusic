//
//  SearchPresenter.swift
//  IMusic
//
//  Created by Andriy on 20.08.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchPresentationLogic {
    func presentData(response: Search.Model.Response.ResponseType)
}

class SearchPresenter: SearchPresentationLogic {
    weak var viewController: SearchDisplayLogic?
    
    func presentData(response: Search.Model.Response.ResponseType) {
        
        switch response {
        case .presentTracks(searchResponse: let searchResponse):
            
           //Проходимось по масиву пісень та кожну з них передаємо в метод - а отримуємо масив вже підготовлених данних
           let cells = searchResponse?.results.map({ track in
                cellViewModel(from: track)
            }) ?? []
            
            //Ініціалізуємо SearchViewModel через масив треків
            let searchViewModel = SearchViewModel.init(cells: cells)
            
            //Передаємо на viewController уже підготовленні данні типу SearchViewModel
            viewController?.displayData(viewModel: .desplayTracks(searchViewModel: searchViewModel))
        case .presentFooterView:
            //передаємо до viewController
            viewController?.displayData(viewModel: .displayFooterView)
        }
    }
    
    //Метод буде конвертувати модель Track в модель Сell - тобто ми підготуємо данні для ViewControllera
    private func cellViewModel(from track: Trask) -> SearchViewModel.Cell {
        
        return SearchViewModel.Cell.init(iconUrlString: track.artworkUrl100,
                                         trackName: track.trackName,
                                         collectionName: track.collectionName,
                                         artistName: track.artistName,
                                         previewUrl: track.previewUrl)
    }
}
