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
        case getTracks
      }
    }
    struct Response {
      enum ResponseType {
        case presentTracks
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case desplayTracks
      }
    }
  }
  
}
