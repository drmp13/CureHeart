//
//  RecordingListController.swift
//  CureHeart
//
//  Created by Dwi RIzki Manggala Putra on 03/08/21.
//

import UIKit


class RecordingListController: UIViewController {

  var selectedFolder: Folder = Folder()
  var recordings: [Recording] = [Recording]()
  
  @IBOutlet weak var navBar: UINavigationItem!
  @IBOutlet weak var labelTitle: UILabel!
  @IBOutlet weak var recordingTableView: UITableView!
  override func viewDidLoad() {
        super.viewDidLoad()
        navBar.title = ""
        labelTitle.text = selectedFolder.name

      let nib = UINib(nibName: "RecordingListTVC", bundle: nil)
      recordingTableView.register(nib, forCellReuseIdentifier: "RecordingListTVC")
      recordingTableView.delegate = self
      recordingTableView.dataSource = self
      recordingTableView.separatorColor = .none
      recordingTableView.showsVerticalScrollIndicator = false
      recordingTableView.tableFooterView = UIView(frame: .zero)
        // Do any additional setup after loading the view.
    }

  override func viewDidAppear(_ animated: Bool) {
    refreshAllData()
  }

  func refreshAllData(){
    recordings = RecordingModel().getRecordingByFolder(folder: selectedFolder).data as! [Recording]
    recordingTableView.reloadData()
  }
    
  @IBAction func navBarBackPressed(_ sender: UIBarButtonItem) {
    self.dismiss(animated: true, completion: nil)
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
