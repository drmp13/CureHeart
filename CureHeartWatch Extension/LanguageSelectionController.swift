//
//  LanguageSelectionController.swift
//  CureHeartWatch Extension
//
//  Created by Dwi RIzki Manggala Putra on 21/08/21.
//

import WatchKit
import Foundation


class LanguageSelectionController: WKInterfaceController {

  @IBOutlet weak var buttonID: WKInterfaceButton!
  @IBOutlet weak var buttonGroup: WKInterfaceGroup!
  override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
    buttonGroup.setCornerRadius(10)
    
    
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

  @IBAction func languageSelectedID() {
    print("ID")
    pushController(withName: "AudioRecording", context: nil)
  }

  @IBAction func languageSelectedEN() {
    print("EN")
    pushController(withName: "AudioRecording", context: nil)
  }
}
