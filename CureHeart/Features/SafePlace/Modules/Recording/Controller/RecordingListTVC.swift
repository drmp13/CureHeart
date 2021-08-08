//
//  RecordingListTVC.swift
//  CureHeart
//
//  Created by Dwi RIzki Manggala Putra on 03/08/21.
//

import UIKit
import AVFoundation

class RecordingListTVC: UITableViewCell,AVAudioPlayerDelegate {

  @IBOutlet weak var innerFrame: UIView!
  @IBOutlet weak var labelName: UILabel!
  @IBOutlet weak var labelDate: UILabel!
  @IBOutlet weak var buttonAudio: UIButton!
  @IBOutlet weak var playerProgressSlider: UISlider!
  @IBOutlet weak var totalLengthOfAudioLabel: UILabel!

  var play_status: Bool = false
  var audioPlayer:AVAudioPlayer!
  var audioLength = 0.0
  var timer:Timer!
  var totalLengthOfAudio = ""
  var recording_data: Recording = Recording()
  var already_play  = false
  var recording_url: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
  
  override func awakeFromNib() {
        super.awakeFromNib()
    innerFrame.layer.cornerRadius = 10
    assingSliderUI()
    setupAudioLength()

    //playerProgressSlider.isEnabled = false


        // Initialization code
    }

  func setupAudioLength(){
    print(recording_url)
    let asset = AVURLAsset(url: recording_url.absoluteURL, options: nil)
    let audioDuration = asset.duration

    print(asset)
    audioLength = CMTimeGetSeconds(audioDuration)
    showTotalSongLength()
  }



    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }



  



  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
      //recordButton.isEnabled = true
      //pauseButton.setTitle("Play", for: .normal)
    print("SELESAI TVC")
    playerProgressSlider.value = 0.0
    buttonAudio.setImage(UIImage(systemName: "play.fill"), for: .normal)
    play_status = false
  }

  func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
      print("Error while playing audio \(error!.localizedDescription)")
  }



  @IBAction func audioButtonPressed(_ sender: UIButton) {
    var param = false
    if(audioPlayer != nil){
      param = audioPlayer.isPlaying
    }else{
      param = false
    }

    if param {
      print("pause")
      audioPlayer.pause()
      play_status = false
    }else{
      print("CEK2 \(recording_data)")
      if(already_play == false){
        audioPlayer = RecordingListController().preparePlayer(recording_url: recording_url.absoluteURL, playerProgressSlider: playerProgressSlider, playerButton: buttonAudio, recording: recording_data)
        audioPlayer.delegate = self
        already_play = true
        print("ass")
      }

      print("play")

      startTimer()
      audioPlayer.play()
      play_status = true
    }
    buttonAudio.setImage(UIImage(systemName: param ? "play.fill" : "pause.fill"), for: UIControl.State())
    //audioPlayer.play()
  }

  func assingSliderUI () {
      //let minImage = UIImage(named: "slider-track-fill")
      //let maxImage = UIImage(named: "slider-track")
      let thumb = UIImage(named: "thumb")

      //playerProgressSlider.setMinimumTrackImage(minImage, for: UIControl.State())
      //playerProgressSlider.setMaximumTrackImage(maxImage, for: UIControl.State())
      playerProgressSlider.setThumbImage(thumb, for: UIControl.State())
  }

  //This returns song length
  func calculateTimeFromNSTimeInterval(_ duration:TimeInterval) ->(minute:String, second:String){
     // let hour_   = abs(Int(duration)/3600)
      let minute_ = abs(Int((duration/60).truncatingRemainder(dividingBy: 60)))
      let second_ = abs(Int(duration.truncatingRemainder(dividingBy: 60)))

     // var hour = hour_ > 9 ? "\(hour_)" : "0\(hour_)"
      let minute = minute_ > 9 ? "\(minute_)" : "0\(minute_)"
      let second = second_ > 9 ? "\(second_)" : "0\(second_)"
      return (minute,second)
  }

  func showTotalSongLength(){
      calculateSongLength()
      totalLengthOfAudioLabel.text = totalLengthOfAudio
  }

  func calculateSongLength(){
      print("AUDIOLENG \(audioLength)")
      let time = calculateTimeFromNSTimeInterval(audioLength)
      totalLengthOfAudio = "\(time.minute):\(time.second)"
    totalLengthOfAudioLabel.text = String(totalLengthOfAudio)
  }

  func startTimer(){
      if timer == nil {
          timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(RecordingListTVC.update(_:)), userInfo: nil,repeats: true)
          timer.fire()
      }
  }

  deinit {
      //timer.invalidate()
  }

  func stopTimer(){
      timer.invalidate()

  }

  @objc func update(_ timer: Timer){
      if !audioPlayer.isPlaying{
          return
      }
      //let time = calculateTimeFromNSTimeInterval(audioPlayer.currentTime)
      //progressTimerLabel.text  = "\(time.minute):\(time.second)"
      playerProgressSlider.value = CFloat(audioPlayer.currentTime)
      UserDefaults.standard.set(playerProgressSlider.value , forKey: "playerProgressSliderValue")


  }

  func retrievePlayerProgressSliderValue(){
      let playerProgressSliderValue =  UserDefaults.standard.float(forKey: "playerProgressSliderValue")
      if playerProgressSliderValue != 0 {
          playerProgressSlider.value  = playerProgressSliderValue
          audioPlayer.currentTime = TimeInterval(playerProgressSliderValue)

          //let time = calculateTimeFromNSTimeInterval(audioPlayer.currentTime)
          //progressTimerLabel.text  = "\(time.minute):\(time.second)"
          playerProgressSlider.value = CFloat(audioPlayer.currentTime)

      }else{
          playerProgressSlider.value = 0.0
          audioPlayer.currentTime = 0.0
          //progressTimerLabel.text = "00:00:00"
      }
  }

  @IBAction func uiSliderValueChange(_ sender: UISlider) {
    audioPlayer.currentTime = TimeInterval(sender.value)
  }
}


