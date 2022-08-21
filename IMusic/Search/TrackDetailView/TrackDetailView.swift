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
    
    //Для проігрування музики
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        //Скажемо щоб затримка була мінімальна, та музика іграла зразу
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    //MARK: awakeFromNib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Зробимо фото трохи меншою
        let scale: CGFloat = 0.8
        trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        trackImageView.layer.cornerRadius = 5
        
        trackImageView.backgroundColor = .gray
    }
    
    //MARK: Setup
    
    //Метод який буде заповнювати UIелементи данними
    func set(viewModel: SearchViewModel.Cell) {
        trackTitleLabel.text = viewModel.trackName
        authorTitleLabel.text = viewModel.artistName
        playTrack(previewUrl: viewModel.previewUrl)
        //Викликаємо наглядача який буде очікувати коли включиться музика
        monitorStartTime()
        
        //В URL змінемо 100 на 100 в 600 на 600, щоб отримати фотку більшу
        let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: string600 ?? "") else { return }
        
        //Запит через SDWebImage
        trackImageView.sd_setImage(with: url, completed: nil)
    }
    
    //Метод буде робити запит по Url, яка буде загружати музику
    private func playTrack(previewUrl: String?) {
        
        guard let url = URL(string: previewUrl ?? "") else { return }
        //Отримуємо музику по url
        let playerItem = AVPlayerItem(url: url)
        //Передаємо її в player
        player.replaceCurrentItem(with: playerItem)
        //Запускаємо звук
        player.play()
    }
    
    //MARK: Time setup
    
    //Будемо відслідковувати коли трек починає іграти
    private func monitorStartTime() {
        
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        //Отримуємо коли трек почне іграти
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            //Як тільки музика включилась то фото збільшується
            self?.enlargeTrackImageView()
        }
    }
    
    //MARK: Animations
    
    //Метод збільшує картинку
    private func enlargeTrackImageView() {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: {
            //Ставимо в початковий чтан фото(100%)
            self.trackImageView.transform = .identity
        },
                       completion: nil)
    }
    
    //Метод зменшує картинку
    private func reduceTrackImageView() {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: {
            let scale: CGFloat = 0.8
            self.trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        },
                       completion: nil)
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
            //Маштабуємо фото в більший розмір
            enlargeTrackImageView()
        } else {
            //Якщо ні то наобород
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            //Маштабуємо фото в менший розмір
            reduceTrackImageView()
        }
    }
}
