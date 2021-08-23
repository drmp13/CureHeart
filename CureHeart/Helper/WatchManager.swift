import Foundation
import WatchConnectivity
class WatchManager: NSObject {
    static let shared: WatchManager = WatchManager()
    fileprivate var watchSession: WCSession?
    override init() {
        super.init()
        if (!WCSession.isSupported()) {
            watchSession = nil
            return
        }
        watchSession = WCSession.default
        watchSession?.delegate = self
        watchSession?.activate()
    }
    func sendParamsToWatch(dict: [String: Any]) {
        print("In watch manager")
        do {
            try watchSession?.updateApplicationContext(dict)
            print("data sent!")
        } catch {
            print("Error sending dictionary \(dict) to Apple Watch!")
        }
    }
}
extension WatchManager: WCSessionDelegate {
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        print("applicationContext was received")
        print(applicationContext)

    }

    func session(_ session: WCSession, didReceive file: WCSessionFile) {
      DispatchQueue.main.async {
        print("RECEIVE FILE")

      let newID = UUID()
      let recording_path = getFileURL(recording_id: newID.uuidString).path

      let sourceFileName = file.fileURL.deletingPathExtension().lastPathComponent
      print(sourceFileName)



      if FileManager.default.fileExists(atPath: file.fileURL.path) {
        print("file ada")
        do {
          try FileManager.default.moveItem(atPath: file.fileURL.path, toPath: recording_path)
          _ = FolderModel().createFolder(name: "Recording from WatchOS")
          let data = FolderModel().getFolderByName(name: "Recording from WatchOS", getCount: false)
          let save = RecordingModel().addNewRecord(name: "New Story from WatchOS", path: newID.uuidString, concerning_word: "", parentFolder: data.data as! Folder)
              //print("The new URL: \(newURL)")

          if(save.query_status != true){
            WatchManager.shared.sendParamsToWatch(dict: [
                "activity": "sendAudio",
                "status": "failed",
                "UUID"  : sourceFileName
            ]);
          }

        } catch {
          WatchManager.shared.sendParamsToWatch(dict: [
              "activity": "sendAudio",
              "status": "failed",
              "UUID"  : sourceFileName
          ]);
          print(error.localizedDescription)
        }
      }else{
        WatchManager.shared.sendParamsToWatch(dict: [
            "activity": "sendAudio",
            "status": "failed",
            "UUID"  : sourceFileName
        ]);
        print("file tidak ada")
      }

//        let recording_pathCek = getFileURL(recording_id: "5E274B2B-B6DC-4290-9816-630343CEE821").path
//      if FileManager.default.fileExists(atPath: recording_pathCek) {
//        print("file yg direkam ada")
//      }else{
//        print("file yg direkam tidak ada")
//      }
//
//
//        //list file
//          let urldoc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//
//        do {
//          let fileURLs = try FileManager.default.contentsOfDirectory(at: urldoc, includingPropertiesForKeys: nil)
//          print(fileURLs)  // process files
//        } catch {
//            print("Error while enumerating files ")
//        }




      }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidComplete")
    }
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive")
    }
    func sessionDidDeactivate(_ session: WCSession) {
        print("sessionDidDeactivate")
    }
}
