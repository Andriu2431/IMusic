//
//  SearchInteractor.swift
//  IMusic
//
//  Created by Andriy on 20.08.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchBusinessLogic {
    func makeRequest(request: Search.Model.Request.RequestType)
}

class SearchInteractor: SearchBusinessLogic {
    
    var networkServise = NetworkServise()
    var presenter: SearchPresentationLogic?
    var service: SearchService?
    
    func makeRequest(request: Search.Model.Request.RequestType) {
        if service == nil {
            service = SearchService()
        }
        
        switch request {
        case .getTracks(searchTerm: let searchTerm):
            //Коли спрацює цей кейст то викличемо у презентера ще один кейс
            presenter?.presentData(response: .presentFooterView)
            //Запит
            networkServise.fetchTracks(searchText: searchTerm) { [weak self] searchResponse in
                //Передаємо presenter
                self?.presenter?.presentData(response: .presentTracks(searchResponse: searchResponse))
            }
        }
    }
}
