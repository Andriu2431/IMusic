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
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    //Коли контейнери перевикористовуються
    override func prepareForReuse() {
        super.prepareForReuse()
        
        //Для того коли контейнер буде перевикористовуватись то фотки не буде - щоб не було багу з заміною фотки на іншу
        trackImageView.image = nil
    }
    
    //Метод який буде заповнювати UIелементи даними
    func set(viewModel: TrackCellViewModel) {
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionNameLabel.text = viewModel.collectionName
        
        guard let url = URL(string: viewModel.iconUrlString ?? "") else { return }
        
        //Ця бібліотека хороша тому що вона зразу кешує фото та потім не загружає їх знов а бере з кешу
        trackImageView.sd_setImage(with: url, completed: nil)
    }
}
