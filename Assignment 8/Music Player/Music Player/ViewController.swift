//
//  ViewController.swift
//  Music Player
//
//  Created by Malika Zhenis on 30.10.2026.
//

import UIKit
import AVFoundation

final class ViewController: UIViewController, AVAudioPlayerDelegate {

    // MARK: - Outlets (required)
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!

    // MARK: - Outlets (progress bar, optional until connected)
    @IBOutlet weak var progressSlider: UISlider?
    @IBOutlet weak var elapsedLabel: UILabel?
    @IBOutlet weak var durationLabel: UILabel?

    // MARK: - State
    private let tracks = TrackLibrary.tracks
    private var currentIndex = 0
    private var isPlaying = false
    private var player: AVAudioPlayer?
    private var progressTimer: Timer?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true)

    
        elapsedLabel?.font = .monospacedDigitSystemFont(ofSize: 12, weight: .regular)
        durationLabel?.font = .monospacedDigitSystemFont(ofSize: 12, weight: .regular)

        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.updateProgress()
        }

        loadTrack(at: 0)
        refreshUI()
    }

    deinit {
        progressTimer?.invalidate()
    }

    // MARK: - Actions
    @IBAction func playPauseTapped(_ sender: UIButton) {
        guard let player = player else {
            print("Player is not created: the audio file was not loaded")
            return
        }
        if isPlaying {
            player.pause()
            isPlaying = false
        } else {
            isPlaying = player.play()
        }
        refreshUI()
    }

    @IBAction func nextTapped(_ sender: UIButton) {
        switchTrack(to: (currentIndex + 1) % tracks.count)
    }

    @IBAction func previousTapped(_ sender: UIButton) {
        switchTrack(to: (currentIndex - 1 + tracks.count) % tracks.count)
    }

    @IBAction func sliderChanged(_ sender: UISlider) {
        player?.currentTime = TimeInterval(sender.value)
        elapsedLabel?.text = format(TimeInterval(sender.value))
    }

    // MARK: - Playback
    private func loadTrack(at index: Int) {
        currentIndex = index
        player?.stop()
        player = nil

        progressSlider?.value = 0
        elapsedLabel?.text = "0:00"
        durationLabel?.text = "0:00"

        let track = tracks[index]
        let name = (track.fileName as NSString).deletingPathExtension
        let ext = (track.fileName as NSString).pathExtension

        let url = Bundle.main.url(forResource: name, withExtension: ext)
            ?? Bundle.main.url(forResource: name, withExtension: ext, subdirectory: "music")

        guard let url = url else {
            print("File not found in bundle: \(track.fileName)")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.prepareToPlay()

            progressSlider?.minimumValue = 0
            progressSlider?.maximumValue = Float(player?.duration ?? 0)
            durationLabel?.text = format(player?.duration ?? 0)
        } catch {
            print("Could not open \(track.fileName): \(error)")
        }
    }

    private func switchTrack(to index: Int) {
        let wasPlaying = isPlaying
        loadTrack(at: index)
        if wasPlaying, let player = player {
            isPlaying = player.play()
        } else {
            isPlaying = false
        }
        refreshUI()
    }

    // MARK: - AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = true
        switchTrack(to: (currentIndex + 1) % tracks.count)
    }

    // MARK: - UI
    private func refreshUI() {
        let track = tracks[currentIndex]
        coverImageView.image = UIImage(named: track.coverImageName)
        titleLabel.text = track.title
        artistLabel.text = track.artist

        let config = UIImage.SymbolConfiguration(pointSize: 32)
        let symbol = isPlaying ? "pause.fill" : "play.fill"
        playPauseButton.setImage(UIImage(systemName: symbol, withConfiguration: config), for: .normal)

        updateProgress()
    }

    private func updateProgress() {
        guard let player = player else { return }
        if let slider = progressSlider, !slider.isTracking {
            slider.value = Float(player.currentTime)
        }
        elapsedLabel?.text = format(player.currentTime)
        durationLabel?.text = format(player.duration)
    }

    private func format(_ time: TimeInterval) -> String {
        let total = Int(time)
        return String(format: "%d:%02d", total / 60, total % 60)
    }
}
