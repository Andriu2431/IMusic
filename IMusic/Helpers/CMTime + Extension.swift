//
//  CMTime + Extension.swift
//  IMusic
//
//  Created by Andriy on 21.08.2022.
//

import AVKit
import Foundation

//Перетворемо отримане значення типу CMTime в тип String
extension CMTime {
    
    func toDisplayString() -> String {
        guard !CMTimeGetSeconds(self).isNaN else { return "" }
        //Загальна кількість секунд
        let totalSecond = Int(CMTimeGetSeconds(self))
        let seconds = totalSecond % 60
        let minutes = totalSecond / 60
        //Отримаємо строку з хвилинами та секундами
        let timeFormatString = String(format: "%02d:%02d", minutes, seconds)
        
        return timeFormatString
    }
}
