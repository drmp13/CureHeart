//
//  StringHelper.swift
//  CureHeart
//
//  Created by Dwi RIzki Manggala Putra on 02/08/21.
//

import UIKit

func stringToArrayCD(_ value: Any?) -> Any? {
    let boxedData = try! NSKeyedArchiver.archivedData(withRootObject: value!, requiringSecureCoding: true)
    return boxedData
}

func arrayToStringCD(_ value: Any?) -> Any? {
    let typedBlob = value as! Data
    let data = try! NSKeyedUnarchiver.unarchivedObject(ofClasses: [String.self as! AnyObject.Type], from: typedBlob)
    return (data as! String)
}
