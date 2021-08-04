//
//  RecordAudioViewController.swift
//  Samples
//
//  Created by Dwi Rizki Manggala Putra on 30/07/21.
//
import UIKit
import AVFoundation
import Speech

class RecordingController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, SFSpeechRecognizerDelegate {

  @IBOutlet weak var recordButton: UIButton!
  @IBOutlet weak var pauseButton: UIButton!
  @IBOutlet weak var stopRecordingButton: UIButton!
  @IBOutlet weak var saveRecordingButton: UIButton!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var labelName: UITextField!

  var recordingSession: AVAudioSession!
  var audioRecorder: AVAudioRecorder!
  var audioPlayer:AVAudioPlayer!

  let concerning_id = ["bangsat", "anjing", "babi"]
  var concerning:String = ""

  private var timer:Timer?
  private var elapsedTimeInSecond:Int = 0

    //Speech Recognizer
  let audioEngine = AVAudioEngine()
  //    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
  let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "id-ID"))
  let request = SFSpeechAudioBufferRecognitionRequest()
  var recognitionTask: SFSpeechRecognitionTask?
  var isRecording = false
  var recording_id: UUID? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        recording_id = UUID()
        //setup Recorder



        self.requestSpeechAuthorization()
        self.setupView()

    }

    func setupView() {
        recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        // failed to record
                    }
                }
            }
        } catch {
            // failed to record
        }
    }

    func loadRecordingUI() {
      //Setting border radius
      recordButton.layer.cornerRadius = 10
      pauseButton.layer.cornerRadius = 10
      stopRecordingButton.layer.cornerRadius = 10
      saveRecordingButton.layer.cornerRadius = 10

      //Hide Unecessary Button
      recordButton.isHidden = false
      pauseButton.isHidden = true
      stopRecordingButton.isHidden = true
      saveRecordingButton.isHidden = true
      timeLabel.isHidden = true

      //Add UI Tap Gesture
      recordButton.addTarget(self, action: #selector(recordAudioButtonTapped), for: .touchUpInside)
      view.addSubview(recordButton)
    }

    func startTimer() {
      timeLabel.isHidden = false
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
          timeLabel.text = String(format: "%02d:%02d", minutes,seconds)

    }

    @objc func recordAudioButtonTapped(_ sender: UIButton) {
        if audioRecorder == nil {
            startRecording()
        }
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
          self.recordAndRecognizeSpeech()

          //Show Button
          startTimer()
          recordButton.isHidden = true
          pauseButton.isHidden = false
          stopRecordingButton.isHidden = false
          saveRecordingButton.isHidden = true
        } catch {
            finishRecording(success: false)
        }
    }

    func finishRecording(success: Bool) {
        pauseTimer()
        audioRecorder.stop()
        audioRecorder = nil
        cancelRecording()
//        if success {
//            recordButton.setTitle("Tap to Re-record", for: .normal)
//        } else {
//            recordButton.setTitle("Tap to Record", for: .normal)
//            // recording failed :(
//        }
    }

  @IBAction func stopRecordingButtonTapped(_ sender: UIButton) {
    finishRecording(success: true)

    //Show Button
    recordButton.isHidden = true
    pauseButton.isHidden = true
    stopRecordingButton.isHidden = true
    saveRecordingButton.isHidden = false

    //check concerning
    print(concerning)

  }

  @IBAction func playAudioButtonTapped(_ sender: UIButton) {
    if (sender.titleLabel?.text == "Play"){
        recordButton.isEnabled = false
        sender.setTitle("Stop", for: .normal)
        
    } else {
        audioPlayer.stop()
        sender.setTitle("Play", for: .normal)
    }
  }

    

    

    //MARK: Delegates

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }

    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error while recording audio \(error!.localizedDescription)")
    }

    

    //MARK: To upload video on server

    func uploadAudioToServer() {
        /*Alamofire.upload(
         multipartFormData: { multipartFormData in
         multipartFormData.append(getFileURL(), withName: "audio.m4a")
         },
         to: "https://yourServerLink",
         encodingCompletion: { encodingResult in
         switch encodingResult {
         case .success(let upload, _, _):
         upload.responseJSON { response in
         Print(response)
         }
         case .failure(let encodingError):
         print(encodingError)
         }
         })*/
    }

      func cancelRecording() {
          recognitionTask?.finish()
          recognitionTask = nil

          // stop audio
          request.endAudio()
          audioEngine.stop()
          audioEngine.inputNode.removeTap(onBus: 0)
      }

  @IBAction func saveRecordingButton(_ sender: UIButton) {
    performSegue(withIdentifier: "saveRecordingSegue", sender: self)
  }

  //MARK: - Recognize Speech
      func recordAndRecognizeSpeech() {
          let node = audioEngine.inputNode
          let recordingFormat = node.outputFormat(forBus: 0)
          node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
              self.request.append(buffer)
          }
          audioEngine.prepare()
          do {
              try audioEngine.start()
          } catch {
              //self.sendAlert(title: "Speech Recognizer Error", message: "There has been an audio engine error.")
              return print(error)
          }
          guard let myRecognizer = SFSpeechRecognizer() else {
              //self.sendAlert(title: "Speech Recognizer Error", message: "Speech recognition is not supported for your current locale.")
              return
          }
          if !myRecognizer.isAvailable {
              //self.sendAlert(title: "Speech Recognizer Error", message: "Speech recognition is not currently available. Check back at a later time.")
              // Recognizer is not available right now
              return
          }
          recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
              if let result = result {

                  let bestString = result.bestTranscription.formattedString
                  var lastString: String = ""
                  for segment in result.bestTranscription.segments {
                      let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                      lastString = String(bestString[indexTo...])
                  }
                  print(lastString)
                if(self.concerning_id.contains(lastString)){
                  self.concerning = self.concerning+" "+lastString
                }
                  //self.checkForColorsSaid(resultString: lastString)
              } else if let error = error {
                  //self.sendAlert(title: "Speech Recognizer Error", message: "There has been a speech recognition error.")
                  print(error)
              }
          })
      }

  //MARK: - Check Authorization Status
  func requestSpeechAuthorization() {
      SFSpeechRecognizer.requestAuthorization { authStatus in
          OperationQueue.main.addOperation {
//              switch authStatus {
//              case .authorized:
//                  self.startButton.isEnabled = true
//              case .denied:
//                  self.startButton.isEnabled = false
//                  self.detectedTextLabel.text = "User denied access to speech recognition"
//              case .restricted:
//                  self.startButton.isEnabled = false
//                  self.detectedTextLabel.text = "Speech recognition restricted on this device"
//              case .notDetermined:
//                  self.startButton.isEnabled = false
//                  self.detectedTextLabel.text = "Speech recognition not yet authorized"
//              @unknown default:
//                  return
//              }
          }
      }
  }

  // Segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    if segue.identifier == "saveRecordingSegue" {
      let destinationVC = segue.destination as! SaveRecordingController

      var recording_name = labelName.text
      if(recording_name==""){
        recording_name = "New Story"
      }
      destinationVC.recording_name = recording_name!
      destinationVC.recording_path = recording_id!.uuidString
      destinationVC.concerning_words = concerning
    }
  }


}

