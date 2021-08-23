//
//  RecordingModel.swift
//
//  Created by Dwi Rizki Manggala Putra on 05/04/21.
//

import UIKit
import CoreData

class RecordingModel {
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

  func getRecordingByFolder(folder: Folder, isAllRecording: Bool = false) -> ModelResponseDefault {
    var response : ModelResponseDefault

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let request : NSFetchRequest<Recording> = Recording.fetchRequest()


    if(!isAllRecording){
      let predicateCompletion = NSPredicate(format: "parentFolder == %@", folder)
      request.predicate = predicateCompletion
    }

    request.sortDescriptors = [NSSortDescriptor(key:"date", ascending:false)]

    do{
      let datas = try context.fetch(request)
      response = ModelResponseDefault(query_status: true, message: "OK", data: datas)
    } catch {
      response = ModelResponseDefault(query_status: false, message: "Error: \(error)", data: Recording())
    }


    return response
  }
  func addNewRecord(name: String, date: Date = NSDate() as Date, path: String, concerning_word: String, parentFolder: Folder) -> ModelResponseDefault {
    var response : ModelResponseDefault

    let newItem = Recording(context: context)
    newItem.name = name
    newItem.date = date
    newItem.path = path
    newItem.concerning_word = concerning_word
    newItem.parentFolder = parentFolder
    do{
        try context.save()
        response = ModelResponseDefault(query_status: true, message: "OK", data: nil)
    } catch {
      response = ModelResponseDefault(query_status: false, message: "Error: \(error)", data: nil)
    }





    return response

  }

  func updateRecordingDataName(item: Recording, name: String) -> ModelResponseDefault {
    var response : ModelResponseDefault

      item.setValue(name, forKey: "name")
      do{
        try context.save()
        response = ModelResponseDefault(query_status: true, message: "OK", data: nil)
      } catch {
        response = ModelResponseDefault(query_status: false, message: "Error: \(error)", data: nil)
      }



    return response

  }

  func updateRecordingDataFolder(item: Recording, folder: Folder) -> ModelResponseDefault {
    var response : ModelResponseDefault

      item.setValue(folder, forKey: "parentFolder")
      do{
        try context.save()
        response = ModelResponseDefault(query_status: true, message: "OK", data: nil)
      } catch {
        response = ModelResponseDefault(query_status: false, message: "Error: \(error)", data: nil)
      }



    return response

  }

  func deleteRecordingData(item: Recording) -> ModelResponseDefault {
    var response : ModelResponseDefault

    context.delete(item)
    do{
      try context.save()
      response = ModelResponseDefault(query_status: true, message: "OK", data: nil)
    } catch {
      response = ModelResponseDefault(query_status: false, message: "Error: \(error)", data: nil)
    }


    return response

  }




}

