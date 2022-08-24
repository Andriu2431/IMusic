//
//  TrackCell.swift
//  IMusic
//
//  Created by Andriy on 20.08.2022.
//

import UIKit
import SDWebImage

//Прротокол для того щоб реалізувати лише ті данні які в ньому записані
protocol TrackCellViewModel {
    var iconUrlString: String? { get }
    var trackName: String { get }
    var artistName: String { get }
    var collectionName: String { get }
}

class TrackCell: UITableViewCell {
    
    static let reuseId = "TrackCell"
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var addTrackOutlet: UIButton!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    //Коли контейнери перевикористовуються
    override func prepareForReuse() {
        super.prepareForReuse()
        
        //Для того коли контейнер буде перевикористовуватись то фотки не буде - щоб не було багу з заміною фотки на іншу
        trackImageView.image = nil
    }
    
    //Масив данних
    var cell: SearchViewModel.Cell?
    
    //Метод який буде заповнювати UIелементи даними
    func set(viewModel: SearchViewModel.Cell) {
        self.cell = viewModel
        
        //Перевіримо чи трек добавлений уже в UserDefaults
        
        //Витягуємо всі треки з бази
        let savedTrack = UserDefaults.standard.savedTracks()
        //Перевіримо чи цей трек уже є в базі данних
        let hasFavourite = savedTrack.firstIndex(where: {
            $0.trackName == self.cell?.trackName && $0.artistName == self.cell?.artistName
        }) != nil
        
        //Якщо є рівні то на тому треку на показуємо кнопку
        if hasFavourite {
            addTrackOutlet.isHidden = true
        } else {
            addTrackOutlet.isHidden = false
        }
        
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionNameLabel.text = viewModel.collectionName
        
        guard let url = URL(string: viewModel.iconUrlString ?? "") else { return }
        
        //Ця бібліотека хороша тому що вона зразу кешує фото та потім не загружає їх знов а бере з кешу
        trackImageView.sd_setImage(with: url, completed: nil)
    }
    
    
    @IBAction func addTrackaction(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        
        addTrackOutlet.isHidden = true
        
        guard let cell = cell else { return }
        
        //Масив треків які уже є в базі
        var listOfTracks = defaults.savedTracks()
        listOfTracks.append(cell)
        
        //Отримуємо данні треків
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: listOfTracks, requiringSecureCoding: false) {
            //Зберігаємо данні в UserDefaults
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
        }
    }
}
