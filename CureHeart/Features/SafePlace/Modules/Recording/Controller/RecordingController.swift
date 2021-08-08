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

  var concerning:String = ""
  var concerning_point: Int = 0

  private var timer:Timer?
  private var elapsedTimeInSecond:Int = 0

    //Speech Recognizer
  let audioEngine = AVAudioEngine()
  //    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
  var speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
  let request = SFSpeechAudioBufferRecognitionRequest()
  var recognitionTask: SFSpeechRecognitionTask?
  var isRecording = false
  var recording_id: UUID? = nil
  var lastWord: String = ""
  var transcript: String = ""
  var lastWord_en: String = ""
  var transcript_en: String = ""


  struct ConcerningWord {
    let word: String
    let point: Int
  }

  let concerningWords: [ConcerningWord] = [
    ConcerningWord(word: "Mau bunuh diri", point: 5),
    ConcerningWord(word: "pengen bunuh diri", point: 5),
    ConcerningWord(word: "pengen mati", point: 5),
    ConcerningWord(word: "Depresi", point: 5),
    ConcerningWord(word: "Udah males banget hidup", point: 5),
    ConcerningWord(word: "Aku hancur", point: 5),
    ConcerningWord(word: "Aku ngerasa kotor", point: 5),
    ConcerningWord(word: "Aku diancam", point: 5),
    ConcerningWord(word: "Trauma", point: 5),
    ConcerningWord(word: "Mau kabur", point: 3),
    ConcerningWord(word: "pengen kabur", point: 3),
    ConcerningWord(word: "gak tahan lagi", point: 3),
    ConcerningWord(word: "gak kuat", point: 3),
    ConcerningWord(word: "Ga tau harus kaya gimana lagi", point: 3),
    ConcerningWord(word: "Aku malu", point: 3),
    ConcerningWord(word: "hina", point: 3),
    ConcerningWord(word: "Pengen keluar dari kondisi ini", point: 3),
    ConcerningWord(word: "Ga bisa gini terus", point: 3),
    ConcerningWord(word: "capek banget", point: 1),
    ConcerningWord(word: "Capek", point: 1),
    ConcerningWord(word: "bingung", point: 1),
    ConcerningWord(word: "pengen nangis", point: 1),
    ConcerningWord(word: "Mau nangis", point: 1)
  ]

  let concerningWords_en: [ConcerningWord] = [
    ConcerningWord(word: "Commit suicide", point: 5),
    ConcerningWord(word: "Suicide", point: 5),
    ConcerningWord(word: "want to die", point: 5),
    ConcerningWord(word: "depressed", point: 5),
    ConcerningWord(word: "I'm tired of living", point: 5),
    ConcerningWord(word: "I'm ruined", point: 5),
    ConcerningWord(word: "I feel dirty", point: 5),
    ConcerningWord(word: "I'm being threatened", point: 5),
    ConcerningWord(word: "I'm trauma", point: 5),
    ConcerningWord(word: "wish i could escape", point: 3),
    ConcerningWord(word: "exhausted", point: 3),
    ConcerningWord(word: "i can't handle it", point: 3),
    ConcerningWord(word: "I can't do this anymore", point: 3),
    ConcerningWord(word: "I don't know what else to do", point: 3),
    ConcerningWord(word: "ashamed", point: 3),
    ConcerningWord(word: "I wish I could escape from this situation", point: 3),
    ConcerningWord(word: "I can't keep doing this", point: 3),
    ConcerningWord(word: "I'm so tired", point: 1),
    ConcerningWord(word: "tired", point: 1),
    ConcerningWord(word: "confused", point: 1),
    ConcerningWord(word: "Overwhelmed", point: 1),
    ConcerningWord(word: "want to cry", point: 1)
  ]


    override func viewDidLoad() {
        super.viewDidLoad()
        recording_id = UUID()

      self.setupView()
        //setup Recorder
      //Hide Unecessary Button
      recordButton.isHidden = true
      pauseButton.isHidden = true
      stopRecordingButton.isHidden = true
      saveRecordingButton.isHidden = true
      timeLabel.isHidden = true
      self.requestSpeechAuthorization()


    }

  override func viewDidAppear(_ animated: Bool) {
    let alert = createOptionAlert(title: nil, subtitle: "In what language do you prefer to tell your story?", actionTitle: "English", cancelTitle: "Indonesia",
        cancelHandler:
                    { [] (input:String?) in
                      self.speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: input ?? "en-US"))

        },
        actionHandler:
                    { [] (input:String?) in
                      self.speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: input ?? "id-ID"))
        }, option1: "en-US", option2: "id-ID")

    self.present(alert, animated: true)
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
          //self.recordAndRecognizeSpeechEN()

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


  @IBAction func pauseRecordingTapped(_ sender: UIButton) {
    if(pauseButton.titleLabel?.text=="Pause"){
      audioRecorder.pause()
      pauseButton.setTitle("Resume", for: .normal)
      pauseTimer()
    }else{
      audioRecorder.record()
      pauseButton.setTitle("Pause", for: .normal)
      startTimer()
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

  func countPointByConcerningWord(concerningWord: ConcerningWord, concerningWords: [ConcerningWord]) -> Int{
    let observedTranscript:String = "--- "+transcript+" ---"
    let arrayTranscript = observedTranscript.components(separatedBy: concerningWord.word)

    if(arrayTranscript.count > 1){
      print("\(concerningWord.word) is concerning, \(concerningWord.point) point")
      let point: Int = (arrayTranscript.count-1)*concerningWord.point
      return point
    }else{
      return 0
    }


  }

  func countPoint(){
    for word in concerningWords {
        let point = countPointByConcerningWord(concerningWord: word, concerningWords: concerningWords)
        concerning_point += point
    }

    for word in concerningWords_en {
        let point = countPointByConcerningWord(concerningWord: word, concerningWords: concerningWords_en)
        concerning_point += point
    }
  }

  @IBAction func saveRecordingButton(_ sender: UIButton) {
//    recognizeSpeechFromRecord() { (response, error) in
//      print("woy")
//      self.transcript_en = response
//      self.countPoint()
//      print("Transcript ID: \(self.transcript)")
//      print("Transcript EN: \(self.transcript_en)")
//      print("Point: \(self.concerning_point)")
//      self.performSegue(withIdentifier: "saveRecordingSegue", sender: self)
//
//    }
    self.countPoint()
    print("Transcript ID: \(self.transcript)")
    print("Point: \(self.concerning_point)")
    self.performSegue(withIdentifier: "saveRecordingSegue", sender: self)
  }

  //MARK: - Recognize Speech

  func recognizeSpeechFromRecord(delegate: @escaping (_ responses_text: String, _ error: Error?) -> Void){
    let audioURL = getFileURL(recording_id: recording_id!.uuidString)

    let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    let request = SFSpeechURLRecognitionRequest(url: audioURL)



      request.shouldReportPartialResults = false

      if (recognizer?.isAvailable)! {
          recognizer?.recognitionTask(with: request) { result, error in
              guard error == nil else { print("Error: \(error!)"); return }
              guard let result = result else { print("No result!"); return }

            print("woy delegate")

                        delegate(
                            result.bestTranscription.formattedString,
                            nil
                        )
            //}
          }

      } else {
        //DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                    delegate(
                        "",
                        nil
                    )
        //}
      }


  }
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


        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { [self] result, error in
              if let result = result {

                  let bestString = result.bestTranscription.formattedString
                  var lastString: String = ""
                  for segment in result.bestTranscription.segments {
                      let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                      lastString = String(bestString[indexTo...])
                  }

                if(lastString != lastWord){
                  transcript += " "+lastWord
                  lastWord = lastString
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

