//
//  UserDefaults.swift
//  IMusic
//
//  Created by Andrii Malyk on 24.08.2022.
//

import Foundation

//27-7хв
extension UserDefaults {
    static let favouriteTrackKey = "favouriteTrackKey"
    
    //Вертає треки які уже є в базі данних
    func savedTracks() -> [SearchViewModel.Cell] {
        let defaults = UserDefaults.standard
        //звертаємось до обєкта з треками
        guard let savedTrack = defaults.object(forKey: UserDefaults.favouriteTrackKey) as? Data else { return [] }
        //Беремо звідтам дані та кастимо до потрібного типу 
        guard let decodedTrack = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedTrack) as? [SearchViewModel.Cell] else { return [] }
        
        return decodedTrack
     }
}
