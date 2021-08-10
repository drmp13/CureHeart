//
//  RecordingListController.swift
//  CureHeart
//
//  Created by Dwi RIzki Manggala Putra on 03/08/21.
//

import UIKit
import AVFoundation


class RecordingListController: UIViewController, AVAudioPlayerDelegate {

  var isAllRecording: Bool = false
  var selectedFolder: Folder = Folder()
  var recordings: [Recording] = [Recording]()
  var audioPlayer:AVAudioPlayer!
  var audioLength = 0.0
  var currentProgressSlider: UISlider? = nil
  var currentButton: UIButton? = nil
  var currentAudio: Recording? = nil
  
  @IBOutlet weak var navBar: UINavigationItem!
  @IBOutlet weak var labelTitle: UILabel!
  @IBOutlet weak var recordingTableView: UITableView!
  override func viewDidLoad() {
        super.viewDidLoad()
        navBar.title = ""



    if(isAllRecording){
      labelTitle.text = "All Recordings"
    }else{
      labelTitle.text = selectedFolder.name
    }



      let nib = UINib(nibName: "RecordingListTVC", bundle: nil)
      recordingTableView.register(nib, forCellReuseIdentifier: "RecordingListTVC")
      recordingTableView.delegate = self
      recordingTableView.dataSource = self
      recordingTableView.separatorColor = .none
      recordingTableView.showsVerticalScrollIndicator = false
      recordingTableView.tableFooterView = UIView(frame: .zero)

    refreshAllData()
        // Do any additional setup after loading the view.
    }

  override func viewDidAppear(_ animated: Bool) {
    refreshAllData()
  }

  func refreshAllData(){
    recordings = RecordingModel().getRecordingByFolder(folder: selectedFolder, isAllRecording: isAllRecording).data as! [Recording]
    recordingTableView.reloadData()
  }
    
  @IBAction func navBarBackPressed(_ sender: UIBarButtonItem) {
    self.dismiss(animated: true, completion: nil)
  }

  func preparePlayer(recording_url: URL, playerProgressSlider: UISlider, playerButton: UIButton, recording: Recording) -> AVAudioPlayer {
    currentProgressSlider = playerProgressSlider
    currentButton = playerButton

    if(currentAudio != recording){

      currentAudio = recording
    }
      var error: NSError?
      do {
        audioPlayer = AVAudioPlayer()
        audioPlayer = try AVAudioPlayer(contentsOf: recording_url as URL)
      } catch let error1 as NSError {
          error = error1
          audioPlayer = nil
      }

      if let err = error {
          print("AVAudioPlayer error: \(err.localizedDescription)")
      } else {
        do {
            //keep alive audio at background
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)))
        } catch _ {
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
        }
        UIApplication.shared.beginReceivingRemoteControlEvents()

        audioPlayer.volume = 10.0
        if(audioPlayer.prepareToPlay()){
          audioPlayer.delegate = self
          audioLength = audioPlayer.duration
          playerProgressSlider.maximumValue = CFloat(audioPlayer.duration)
          playerProgressSlider.minimumValue = 0.0
          playerProgressSlider.value = 0.0
        }else{
          print("cant prepare")
        }
    }


    return audioPlayer
  }


  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
      //recordButton.isEnabled = true
      //pauseButton.setTitle("Play", for: .normal)
    print("SELESAI")
    currentProgressSlider!.value = 0.0
    currentButton!.setImage(UIImage(systemName: "play.fill"), for: .normal)
    //play_status = false
  }


  func audioButtonExe(){
    if audioPlayer.isPlaying{
      audioPlayer.pause()
    }else{
      audioPlayer.play()
    }
  }

  



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RecordingListController: UITableViewDelegate {
  func tableView( _tableView: UITableView, didSelectRowAt indexPath: IndexPath){

  }
}

extension RecordingListController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = recordingTableView.dequeueReusableCell(withIdentifier: "RecordingListTVC", for: indexPath) as! RecordingListTVC
    cell.recording_data = recordings[indexPath.row]
    cell.labelName.text = recordings[indexPath.row].name
    cell.labelDate.text = helper_formatDate(date: recordings[indexPath.row].date!, dateFormat: "dd MMMM YYYY")
    cell.recording_url = getFileURL(recording_id: recordings[indexPath.row].path!) 
    cell.clipsToBounds = true
    cell.setupAudioLength()
    return cell
  }


  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var listData = 0
    if(tableView == recordingTableView) {
      if(recordings.count == 0) {
        tableView.setEmptyView(title: "Empty Data", message: "You don't have any recordings", constant: 10)
      }else {
        tableView.restore()
        listData = recordings.count
      }
    }
    return listData
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if(tableView == recordingTableView){
      print("TVC Clicked")
      //performSegue(withIdentifier: "gotoRecordingList", sender: self)
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 100
  }

  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteActionHandler = { (action: UIContextualAction, view: UIView, completion: @escaping (Bool) -> Void) in
      let _ = RecordingModel().deleteRecordingData(item: self.recordings[indexPath.row])
      self.recordings.remove(at: indexPath.row)
      tableView.beginUpdates()
      tableView.deleteRows(at: [indexPath], with: .fade)
      tableView.endUpdates()
    }

    let editActionHandler = { (action: UIContextualAction, view: UIView, completion: @escaping (Bool) -> Void) in
      let alert = createPromptAlert(title: "Edit Recording Name", subtitle: "Enter a name for this record", actionTitle: "Save", cancelTitle: "Cancel", inputPlaceholder: "Recording Name", inputKeyboardType: .default, actionHandler:
                                      { [self] (input:String?) in
                                        if(input != nil && input != ""){
                                          let _ = RecordingModel().updateRecordingDataName(item: self.recordings[indexPath.row], name: input!)
                                          refreshAllData()
                                        }else{
                                          let warning = createDefaultAlert(alertMessage: "Name can't be empty!")
                                          self.present(warning, animated: true)
                                        }

                          })

      self.present(alert, animated: true)

    }

    let edit_action = UIContextualAction(style: .normal, title: "Rename", handler: editActionHandler)
        edit_action.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
    let actions = [
      UIContextualAction(style: .destructive, title: "Delete", handler: deleteActionHandler),
      edit_action
    ]

    let swipe = UISwipeActionsConfiguration(actions: actions)
        swipe.performsFirstActionWithFullSwipe = false
    return swipe
  }


}

fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
  return input.rawValue
}
