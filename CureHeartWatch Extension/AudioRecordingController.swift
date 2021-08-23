//
//  AudioRecordingController.swift
//  CureHeartWatch Extension
//
//  Created by Dwi RIzki Manggala Putra on 21/08/21.
//

import WatchKit
import Foundation
import AVFoundation
import WatchConnectivity


class AudioRecordingController: WKInterfaceController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, WCSessionDelegate {

  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    print("session activated")
  }


  var recordingSession: AVAudioSession!
  var audioRecorder: AVAudioRecorder!
  var audioPlayer:AVAudioPlayer!
  var is_start: Bool = false

  private var timer:Timer?
  private var elapsedTimeInSecond:Int = 0

  var isRecording = false
  var recording_id: UUID? = nil

  @IBOutlet weak var timeLabel: WKInterfaceLabel!
  @IBOutlet weak var audioButton: WKInterfaceButton!

  fileprivate let watchSession : WCSession? = WCSession.isSupported() ? WCSession.default : nil

  func setupView() {
      recordingSession = AVAudioSession.sharedInstance()

      do {
          try recordingSession.setCategory(.playAndRecord, mode: .default)
          try recordingSession.setActive(true)
          recordingSession.requestRecordPermission() { [unowned self] allowed in
              DispatchQueue.main.async {
                  if allowed {
                      //self.loadRecordingUI()
                    audioButton.setEnabled(true)
                  } else {
                      // failed to record
                  }
              }
          }
      } catch {
          // failed to record
      }
  }
  
    override init() {
        super.init()

      watchSession?.delegate = self
      watchSession?.activate()
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        audioButton.setEnabled(false)
        recording_id = UUID()


    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        setupView()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

  func startTimer() {
        // Start every 1 second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (time) in
            self.elapsedTimeInSecond += 1
            self.updateTimeLabel()
        })
  }

  func pauseTimer()  {
        timer?.invalidate()
  }

  func resetTimer(){
        timer?.invalidate()
        elapsedTimeInSecond = 0
        updateTimeLabel()
  }

  func updateTimeLabel(){
        let seconds = elapsedTimeInSecond % 60
        let minutes = (elapsedTimeInSecond / 60) % 60
        timeLabel.setText(String(format: "%02d:%02d", minutes,seconds))
  }

  func startRecording() {
    let audioFilename = getFileURL(recording_id: recording_id!.uuidString)

      let settings = [
          AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
          AVSampleRateKey: 12000,
          AVNumberOfChannelsKey: 1,
          AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
      ]

      do {

        //Record
        audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
        audioRecorder.delegate = self
        audioRecorder.record()


        //Show Button
        startTimer()
      } catch {
          finishRecording(success: false)
      }
  }


  func finishRecording(success: Bool) {
      pauseTimer()
      audioRecorder.stop()
      audioRecorder = nil
  }

  @IBAction func audioButtonTapped() {
    print("Outstanding file transfers: \(WCSession.default.outstandingFileTransfers)")
    print("Has content pending: \(WCSession.default.hasContentPending)")
    if(!isRecording){
      if audioRecorder == nil {
          startRecording()
      }
      //audioButton.setTitle("Stop")
      audioButton.setBackgroundImageNamed("button-stop")
      isRecording = true
    }else{
      finishRecording(success: true)
      print("segue ke save")

      if(watchSession != nil){
        DispatchQueue.main.async {
          let transfer = self.watchSession?.transferFile(getFileURL(recording_id: self.recording_id!.uuidString).absoluteURL, metadata: nil)
          print("harusnya sih terkirim")
          print(transfer?.progress as Any)
        }

      }
      pushController(withName: "DoneRecording", context: nil)
    }

  }
  

  func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
      if (error != nil) {
          print("error")
      }else{
        print("success")
      }
  }

  func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
      print("applicationContext was received")

    if(watchSession != nil){
      DispatchQueue.main.async {
        let transfer = self.watchSession?.transferFile(getFileURL(recording_id: applicationContext["UUID"] as! String).absoluteURL, metadata: nil)
        print("harusnya sih terkirim")
        print(transfer?.progress as Any)
      }


    }

  }
}
