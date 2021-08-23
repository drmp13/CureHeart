//
//  InterfaceController.swift
//  CureHeartWatch Extension
//
//  Created by Dwi RIzki Manggala Putra on 20/08/21.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController {

  var watchSession: WCSession?

    override func awake(withContext context: Any?) {
      super.awake(withContext: context)
      // Configure interface objects here.
      watchSession = WCSession.default
      watchSession?.delegate = self
      watchSession?.activate()
    }
    
    override func willActivate() {
      // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
      // This method is called when watch view controller is no longer visible
    }

}

extension InterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Session activation did complete")
    }
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("watch received app context: ", applicationContext)
//        let newTask = Task(taskName: applicationContext["taskName"] as! String,
//                           finishedTime: applicationContext["finishedTime"] as! String,
//                           iconName: "work",
//                           color: UIColor.cyan)
//        tasks.append(newTask)
//        configureTable()
    }
}
