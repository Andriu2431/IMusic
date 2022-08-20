//
//  NetworkServise.swift
//  IMusic
//
//  Created by Andriy on 20.08.2022.
//

import UIKit
import Alamofire

class NetworkServise {
    
    //Метод буде робити запит
    func fetchTracks(searchText: String, complition: @escaping (SearchResponse?) -> Void) {
        let url = "https://itunes.apple.com/search"
        let parametrs = ["term": "\(searchText)", "limit": "10", "media": "music"]
        
        //Робимо запит з парамитрами
        AF.request(url, method: .get, parameters: parametrs).responseData { dataResponse in
            if let error = dataResponse.error {
                print("Error received requestiong data: \(error)")
                complition(nil)
                return
            }
            
            guard let data = dataResponse.data else { return }
            
            //Декодуємо данні
            let decoder = JSONDecoder()
            
            do {
                let object = try decoder.decode(SearchResponse.self, from: data)
                complition(object)
                
            } catch let jsonError {
                print(jsonError.localizedDescription)
                complition(nil)
            }
        }
    }
}

