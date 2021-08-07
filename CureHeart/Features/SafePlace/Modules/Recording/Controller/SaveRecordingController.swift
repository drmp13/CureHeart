//
//  SaveRecordingController.swift
//  CureHeart
//
//  Created by Dwi RIzki Manggala Putra on 02/08/21.
//

import UIKit

class SaveRecordingController: UIViewController {

  var recording_name = ""
  var recording_path = ""
  var concerning_words = ""
  var pickerView = UIPickerView()
  var selectedFolder: Folder? = nil
  var folders = [Folder]()

  @IBOutlet weak var textFieldFolder: UITextField!
  @IBOutlet weak var addToFolderButton: UIButton!
  override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self


        //setting picker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let datePickerDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(datePickerDoneButtonPressed))
        toolbar.setItems([flexButton, datePickerDoneButton], animated: true)

        textFieldFolder.inputAccessoryView = toolbar
        textFieldFolder.inputView = pickerView
        textFieldFolder.textAlignment = .left

        addToFolderButton.layer.cornerRadius = 10

        folders = FolderModel().getFolders(canCreate: true).data as! [Folder]


        // Do any additional setup after loading the view.
    }

  @objc func datePickerDoneButtonPressed(){

    if(pickerView.selectedRow(inComponent: 0)==folders.count){
      let alert = createPromptAlert(title: "New Folder", subtitle: "Enter a name for this folder", actionTitle: "Save", cancelTitle: "Cancel", inputPlaceholder: "Folder Name", inputKeyboardType: .default, actionHandler:
                                      { [self] (input:String?) in
                              addNewFolder(value: input)
                          })

      self.present(alert, animated: true)
      selectedFolder = nil
    }else{
      let index = folders[pickerView.selectedRow(inComponent: 0)]
      textFieldFolder.text = index.name
      selectedFolder = index
    }

    textFieldFolder.resignFirstResponder()
    self.view.endEditing(true)



  }

  func addNewFolder(value: String?){
    if(value != ""){
      let createFolder = FolderModel().createFolder(name: value!)
      if(createFolder.query_status==true){
        folders = FolderModel().getFolders().data as! [Folder]
        pickerView.reloadAllComponents()
      }else{
        self.present(createDefaultAlert(alertMessage: createFolder.message),animated: true)
      }
    }else{
      self.present(createDefaultAlert(alertMessage: "Field can't be empty!"),animated: true)
    }

  }
    

  @IBAction func addFolderButtonPressed(_ sender: UIButton) {
    if(selectedFolder != nil){
      _ = RecordingModel().addNewRecord(name: recording_name, path: recording_path, concerning_word: concerning_words, parentFolder: selectedFolder!)
      performSegue(withIdentifier: "goToRecommendation", sender: self)
    }else{
      self.present(createDefaultAlert(alertMessage: "Please select recording folder!"), animated: true)
    }

  }

  // Segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    if segue.identifier == "gotoRecordingList" {
      let destinationVC = segue.destination as! RecordingListController
        destinationVC.selectedFolder = selectedFolder!
    }
    
    if segue.identifier == "goToRecommendation" {
      let destinationVC = segue.destination as! RecommendationViewController
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

//MARK: - Extension UIPicker for Folder
extension SaveRecordingController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return folders.count+1
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if(row < folders.count){
      return folders[row].name
    }else{
      return "- Tambah Folder Baru -"
    }
  }


}
