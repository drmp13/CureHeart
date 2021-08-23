//
//  PathHelper.swift
//  CureHeart
//
//  Created by Dwi RIzki Manggala Putra on 03/08/21.
//

import Foundation


func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

func getFileURL(recording_id:String) -> URL {
  let path = getDocumentsDirectory().appendingPathComponent("\(recording_id).m4a")
    print(path)
    return path as URL
}
