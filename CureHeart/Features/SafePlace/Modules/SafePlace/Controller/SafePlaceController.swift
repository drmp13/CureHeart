//
//  SafePlaceController.swift
//  CureHeart
//
//  Created by Dwi RIzki Manggala Putra on 01/08/21.
//

import UIKit

class SafePlaceController: UIViewController {

  @IBOutlet weak var startButton: UIButton!
  @IBOutlet weak var allRecordingCell: UIView!
  @IBOutlet weak var folderTableView: UITableView!
  @IBOutlet weak var allRecordingsCell: UIView!
  
  var folders = [Folder]()
  var allRecordingClicked: Bool = false
  override func viewDidLoad() {
        super.viewDidLoad()

    startButton.layer.cornerRadius = 10
    allRecordingCell.layer.cornerRadius = 10
    folderTableView.delegate = self
    folderTableView.dataSource = self
    folderTableView.separatorColor = .none
    folderTableView.showsVerticalScrollIndicator = false
    folderTableView.tableFooterView = UIView(frame: .zero)
    

    let nib = UINib(nibName: "FolderCell", bundle: nil)
    folderTableView.register(nib, forCellReuseIdentifier: "FolderCell")

    let cg1Tap = UITapGestureRecognizer(target: self, action: #selector(setCategoryIndexCG1(tapGestureRecognizer:)))
    allRecordingsCell.addGestureRecognizer(cg1Tap)
    allRecordingsCell.isUserInteractionEnabled = true

    refreshAllData()

    }

  override func viewDidAppear(_ animated: Bool) {
    refreshAllData()
    allRecordingClicked = false
  }

  @IBAction func unwind( _ seg: UIStoryboardSegue) {
    refreshAllData()
    allRecordingClicked = false
  }

  
  

  func refreshAllData(){
    folders = FolderModel().getFolders().data as! [Folder]
    folderTableView.reloadData()
  }
    

  @IBAction func addFolderButtonTapped(_ sender: UIButton) {
    let alert = createPromptAlert(title: "New Folder", subtitle: "Enter a name for this folder", actionTitle: "Save", cancelTitle: "Cancel", inputPlaceholder: "Nama Folder", inputKeyboardType: .default, actionHandler:
                                    { [self] (input:String?) in
                          addNewFolder(value: input)
                        })

    self.present(alert, animated: true)
  }

  func addNewFolder(value: String?){
    if(value != ""){
      let createFolder = FolderModel().createFolder(name: value!)
      if(createFolder.query_status==true){
        print("Created")
        folders = FolderModel().getFolders().data as! [Folder]
        folderTableView.reloadData()
      }else{
        self.present(createDefaultAlert(alertMessage: createFolder.message),animated: true)
      }
    }else{
      self.present(createDefaultAlert(alertMessage: "Field can't be empty!"),animated: true)
    }

  }





  @objc func setCategoryIndexCG1(tapGestureRecognizer: UITapGestureRecognizer){
    allRecordingClicked = true
    performSegue(withIdentifier: "gotoRecordingList", sender: self)
  }

  // Segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    if segue.identifier == "gotoRecordingList" {
      let destinationVC = segue.destination as! RecordingListController

      if(allRecordingClicked){
        destinationVC.selectedFolder = Folder()
        destinationVC.isAllRecording = true
      }else{
        if let indexPath = folderTableView.indexPathForSelectedRow {
          destinationVC.selectedFolder = folders[indexPath.row]
          destinationVC.isAllRecording = false
        }
      }


    }
  }


}

extension SafePlaceController: UITableViewDelegate {
  func tableView( _tableView: UITableView, didSelectRowAt indexPath: IndexPath){

  }
}

extension SafePlaceController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = folderTableView.dequeueReusableCell(withIdentifier: "FolderCell", for: indexPath) as! FolderCell
    cell.labelFolderName.text = folders[indexPath.row].name
    cell.clipsToBounds = true
    return cell
  }


  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var listData = 0
    if(tableView == folderTableView) {
      if(folders.count == 0) {
        print("tesas")
        tableView.setEmptyView(title: "Empty Data", message: "You don't have any recording folder", constant: 10)
      }else {
        tableView.restore()
        listData = folders.count
      }
    }

    return listData
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if(tableView == folderTableView){
      performSegue(withIdentifier: "gotoRecordingList", sender: self)
    }
  }


  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

      return 100

  }

  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteActionHandler = { (action: UIContextualAction, view: UIView, completion: @escaping (Bool) -> Void) in
      let _ = FolderModel().deleteFolderData(item: self.folders[indexPath.row])
      self.folders.remove(at: indexPath.row)
      tableView.beginUpdates()
      tableView.deleteRows(at: [indexPath], with: .fade)
      tableView.endUpdates()
    }

    let editActionHandler = { (action: UIContextualAction, view: UIView, completion: @escaping (Bool) -> Void) in
      let alert = createPromptAlert(title: "Edit Folder Name", subtitle: "Enter a name for this folder", actionTitle: "Save", cancelTitle: "Cancel", inputPlaceholder: "Folder Name", inputKeyboardType: .default, actionHandler:
                                      { [self] (input:String?) in
                                        if(input != nil && input != ""){
                                          let _ = FolderModel().updateFolderDataName(item: self.folders[indexPath.row], name: input!)
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
