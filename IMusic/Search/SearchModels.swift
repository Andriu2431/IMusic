//
//  SearchModels.swift
//  IMusic
//
//  Created by Andriy on 20.08.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Search {
   
  enum Model {
    struct Request {
      enum RequestType {
          case getTracks(searchTerm: String)
      }
    }
    struct Response {
      enum ResponseType {
          case presentTracks(searchResponse: SearchResponse?)
      }
    }
    struct ViewModel {
      enum ViewModelData {
          case desplayTracks(searchViewModel: SearchViewModel)
      }
    }
  }
}


//Тут зробимо модель данних яку заповнить presener - та дамо вже назви зрозумілі нам
struct SearchViewModel {
    struct Cell {
        var iconUrlString: String?
        var trackName: String?
        var collectionName: String?
        var artistName: String
    }
    
    let cells: [Cell]
}
