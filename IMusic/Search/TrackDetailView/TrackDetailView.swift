//
//  TrackDetailView.swift
//  IMusic
//
//  Created by Andriy on 21.08.2022.
//

import UIKit
import SDWebImage
import AVKit

//Детальний контроллер
class TrackDetailView: UIView {
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var duratioLabel: UILabel!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var authorTitleLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    //MARK: Logic
    
    //Для проігрування музики
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        //Скажемо щоб затримка була мінімальна, та музика іграла зразу
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        trackImageView.backgroundColor = .gray
    }
    
    //Метод який буде заповнювати UIелементи данними
    func set(viewModel: SearchViewModel.Cell) {
        trackTitleLabel.text = viewModel.trackName
        authorTitleLabel.text = viewModel.artistName
        playTrack(previewUrl: viewModel.previewUrl)
        
        //В URL змінемо 100 на 100 в 600 на 600, щоб отримати фотку більшу
        let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: string600 ?? "") else { return }
        
        //Запит через SDWebImage
        trackImageView.sd_setImage(with: url, completed: nil)
    }
    
    //Метод буде робити запит по Url, яка буде загружати музику
    private func playTrack(previewUrl: String?) {
        print("Track \(previewUrl ?? "no url")")
        
        guard let url = URL(string: previewUrl ?? "") else { return }
        //Отримуємо музику по url
        let playerItem = AVPlayerItem(url: url)
        //Передаємо її в player
        player.replaceCurrentItem(with: playerItem)
        //Запускаємо звук
        player.play()
    }
    
    //MARK: @IBAction
    
    @IBAction func dragDownButtonTapped(_ sender: Any) {
        //Звертаємо екран
        self.removeFromSuperview()
    }
    
    @IBAction func handleCurrentTimeSlider(_ sender: Any) {
    }
    
    @IBAction func handleVolumeSlider(_ sender: Any) {
    }
    
    @IBAction func previousTrack(_ sender: Any) {
    }
    
    @IBAction func nextTrack(_ sender: Any) {
    }
    
    @IBAction func playPauseAction(_ sender: Any) {
        
        //Через if перевіримо чи трек іграє чи ні і від того будемо ставити на паузу або відтворювати
        if player.timeControlStatus == .paused {
            //Якщо ми на паузі нажимаємо на кнопку то включаємо музику та фото міняємо
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        } else {
            //Якщо ні то наобород
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        }
    }
}
