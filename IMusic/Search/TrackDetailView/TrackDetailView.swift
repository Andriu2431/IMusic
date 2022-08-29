//
//  TrackDetailView.swift
//  IMusic
//
//  Created by Andriy on 21.08.2022.
//

import UIKit
import SDWebImage
import AVKit

//делегат
protocol TrackMovingDelegate: AnyObject {
    //БУде нам вертати поперениій контейнер
    func moveBackForPreviousTrack() -> SearchViewModel.Cell?
    //БУде нам вертати наступний контейнер
    func moveForwardForPreviousTrack() -> SearchViewModel.Cell?
}

//Детальний контроллер
class TrackDetailView: UIView {
    @IBOutlet weak var miniTrackView: UIView!
    @IBOutlet weak var miniGoforwardButton: UIButton!
    @IBOutlet weak var miniTrackTitleLabel: UILabel!
    @IBOutlet weak var miniTrackImageView: UIImageView!
    @IBOutlet weak var miniPlayPauseButton: UIButton!
    
    @IBOutlet weak var maximazedStackView: UIStackView!
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
    
    //Створюємо обєкт делегата
    weak var delegate: TrackMovingDelegate?
    weak var tabBarDelegate: MainTabBarControllerDelegate?
    
    //MARK: awakeFromNib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Зробимо фото трохи меншою
        let scale: CGFloat = 0.8
        trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        trackImageView.layer.cornerRadius = 5
        
        miniPlayPauseButton.imageEdgeInsets = UIEdgeInsets(top: 11, left: 11, bottom: 11, right: 11)
        
        setupGesture()
    }
    
    //MARK: Setup
    
    //Метод який буде заповнювати UIелементи данними
    func set(viewModel: SearchViewModel.Cell) {
        miniTrackTitleLabel.text = viewModel.trackName
        
        trackTitleLabel.text = viewModel.trackName
        authorTitleLabel.text = viewModel.artistName
        playTrack(previewUrl: viewModel.previewUrl)
        //Викликаємо наглядача який буде очікувати коли включиться музика
        monitorStartTime()
        //Робота з часом музики
        observePlayerCurrentTime()
        //Кожного разу коли відкривається екран то міняємо кнопку на pause
        playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        
        //В URL змінемо 100 на 100 в 600 на 600, щоб отримати фотку більшу
        let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: string600 ?? "") else { return }
        
        //Запит через SDWebImage
        miniTrackImageView.sd_setImage(with: url, completed: nil)
        trackImageView.sd_setImage(with: url, completed: nil)
    }
    
    //Жести
    private func setupGesture() {
        //Дабавляємо жест по тапу
        miniTrackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximized)))
        //Дабавляємо жест коли тягнути будемо
        miniTrackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        //Свайп вниз - щоб закрити детальний екран
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissalPan)))
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
    
    //MARK: Gesture
    
    //Метод який буде відкривати додатковий екран по тапу малого екрану
    @objc private func handleTapMaximized() {
        self.tabBarDelegate?.maximizeTrackDetailController(viewModel: nil)
    }
    
    //Метод який буде відкривати додатковий екран коли тягнути будемо
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        //Обробимо стани жестів
        switch gesture.state {
        case .changed:
            handlePanChanged(gesture: gesture)
        case .ended:
            handlePanEnded(gesture: gesture)
        @unknown default:
            print("unknown default")
        }
    }
    
    //Логіка по якій міні плеєр буде рухатись за пальцем
    private func handlePanChanged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        
        let newAlpha = 1 + translation.y / 200
        self.miniTrackView.alpha = newAlpha < 0 ? 0 : newAlpha
        self.maximazedStackView.alpha = -translation.y / 200
    }
    
    //Останнє доторкання пальцем
    private func handlePanEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        //Швидкість свайпу пальця
        let velocity = gesture.velocity(in: self.superview)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut) {
            self.transform = .identity
            //Якщо ми підляли цей плеєр більше ніж 200 поінтів та з шидкістю 500 то презентуємо детальний екран
            if translation.y < -200 || velocity.y < -500 {
                self.tabBarDelegate?.maximizeTrackDetailController(viewModel: nil)
            } else {
                self.miniTrackView.alpha = 1
                self.maximazedStackView.alpha = 0
            }
        }
    }
    
    //Метод буде скривати детальний екран
    @objc private func handleDismissalPan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            let translation = gesture.translation(in: self.superview)
            maximazedStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        case .ended:
            let translation = gesture.translation(in: self.superview)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
                self.maximazedStackView.transform = .identity
                if translation.y > 70 {
                    self.tabBarDelegate?.minimizeTrackDetailController()
                }
            }
        @unknown default:
            print("unknown default")
        }
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
    
    //Метод буде слідкувати за позицією треку
    private func observePlayerCurrentTime() {
        
        let interval = CMTimeMake(value: 1, timescale: 2)
        
        //Що будемо робити кожну секунду проіграного треку
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            //Передамо цей час в лейбел
            self?.currentTimeLabel.text = time.toDisplayString()
            
            //фіксуємо скільки всього часу йде трек
            let durationTime = self?.player.currentItem?.duration
            //Скільки часу залишилось іграти музиці в теперешній час
            let currentDuratinText = ((durationTime ?? CMTimeMake(value: 1, timescale: 1)) - time).toDisplayString()
            self?.duratioLabel.text = "-\(currentDuratinText)"
            //Оновляємо слайдер
            self?.updateCurrentTimeSlider()
        }
    }
    
    //Метод який буде переміщати slider по часу коли йде музика
    private func updateCurrentTimeSlider() {
        //Точка де ми в цей час
        let currentTimeSecond = CMTimeGetSeconds(player.currentTime())
        //скільки загальний трек
        let durationSecons = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        //Шукаємо співвідношення в процентах
        let percentage = currentTimeSecond / durationSecons
        self.currentTimeSlider.value = Float(percentage)
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
        //Виклкикаємо метод який скриє анімовано екран до tabBar
        self.tabBarDelegate?.minimizeTrackDetailController()
    }
    
    @IBAction func handleCurrentTimeSlider(_ sender: Any) {
        //Кожен раз коли будемо пересувати слайдер то буде музика також пересуватись
        let percentage = currentTimeSlider.value
        guard let duration = player.currentItem?.duration else  { return }
        //Довжина треку в секундах
        let durationInSeconds = CMTimeGetSeconds(duration)
        //Де ми зара
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        //Секунди в стрінг конвертуємо в CMTime
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        player.seek(to: seekTime)
    }
    
    @IBAction func handleVolumeSlider(_ sender: Any) {
        player.volume = volumeSlider.value
    }
    
    @IBAction func previousTrack(_ sender: Any) {
        //Отримаємо попередній трек
        let cellViewModel = delegate?.moveBackForPreviousTrack()
        
        guard let cellViewModel = cellViewModel else { return }
        
        //Оновляємо данні
        self.set(viewModel: cellViewModel)
    }
    
    @IBAction func nextTrack(_ sender: Any) {
        //Отримаємо наступний трек
        let cellViewModel = delegate?.moveForwardForPreviousTrack()
        
        guard let cellViewModel = cellViewModel else { return }
        
        //Оновляємо данні
        self.set(viewModel: cellViewModel)
    }
    
    @IBAction func playPauseAction(_ sender: Any) {
        
        //Через if перевіримо чи трек іграє чи ні і від того будемо ставити на паузу або відтворювати
        if player.timeControlStatus == .paused {
            //Якщо ми на паузі нажимаємо на кнопку то включаємо музику та фото міняємо
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            //Маштабуємо фото в більший розмір
            enlargeTrackImageView()
        } else {
            //Якщо ні то наобород
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            //Маштабуємо фото в менший розмір
            reduceTrackImageView()
        }
    }
}
