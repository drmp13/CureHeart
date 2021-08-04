//
//  FolderModel.swift
//
//  Created by Dwi Rizki Manggala Putra on 05/04/21.
//

import UIKit
import CoreData

class FolderModel {
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


  func getFolderByName(name: String) -> ModelResponseDefault {
    var response : ModelResponseDefault

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let request : NSFetchRequest<Folder> = Folder.fetchRequest()
    let predicateCompletion = NSPredicate(format: "name == %@", name)
    request.predicate = predicateCompletion
    request.fetchLimit = 1

    do{
      let count = try context.count(for: request)
      response = ModelResponseDefault(query_status: true, message: "OK", data: count)
    } catch {
      response = ModelResponseDefault(query_status: false, message: "Error: \(error)", data: 0)
    }


    return response
  }

  func getFolders(canCreate: Bool = false) -> ModelResponseDefault {
    var response : ModelResponseDefault
    var datas: [Folder]

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let request : NSFetchRequest<Folder> = Folder.fetchRequest()
    request.predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [])
    request.sortDescriptors = [NSSortDescriptor(key:"name", ascending:true)]






    do{
      datas = try context.fetch(request)

      if(canCreate){
//        let newItem = Folder(context: <#T##NSManagedObjectContext#>)
//        newItem.name = "- Tambah Folder Baru -"
//        newItem.date = NSDate() as Date
//        datas.append(newItem)

      }



      response = ModelResponseDefault(query_status: true, message: "OK", data: datas)
    } catch {
      response = ModelResponseDefault(query_status: false, message: "Error: \(error)", data: [Folder]())
    }

    return response
  }



  func createFolder(name: String, date: Date = NSDate() as Date) -> ModelResponseDefault {
    var response : ModelResponseDefault

    let check = FolderModel().getFolderByName(name: name)
    if(check.query_status==true){
      if(check.data as! Int>0){
        response = ModelResponseDefault(query_status: false, message: "Duplicate Entry", data: nil)
      }else{
        let newItem = Folder(context: context)
        newItem.name = name
        newItem.date = date
        do{
          if(name != "- Tambah Folder Baru -"){
            try context.save()
            response = ModelResponseDefault(query_status: true, message: "OK", data: nil)
          }else{
            context.rollback()
            response = ModelResponseDefault(query_status: true, message: "OK", data: nil)
          }
        } catch {
          response = ModelResponseDefault(query_status: false, message: "Error: \(error)", data: nil)
        }
      }
    }else{
      response = ModelResponseDefault(query_status: false, message: "Error", data: nil)
    }



    return response

  }

  func truncateAllData(){
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Folder")
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

    do {
      try context.execute(deleteRequest)
    } catch let error as NSError {
        print(error)
    }
  }

  func updateFolderDataName(item: Folder, name: String) -> ModelResponseDefault {
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

  func deleteFolderData(item: Folder) -> ModelResponseDefault {
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

