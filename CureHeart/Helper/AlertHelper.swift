//
//  AlertHelper.swift
//  CureHeart
//
//  Created by Dwi RIzki Manggala Putra on 01/08/21.
//

import UIKit

func createDefaultAlert(alertMessage: String, buttonTitle: String = "OK") -> UIAlertController {
  let dialogMessage = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: .alert)
  let ok = UIAlertAction(title:buttonTitle, style: .default, handler: { (action) -> Void in
      //print("Ok button tapped")
   })
  dialogMessage.addAction(ok)

  return dialogMessage
}

func createPromptAlert(title:String? = nil,
                       subtitle:String? = nil,
                       actionTitle:String? = "Add",
                       cancelTitle:String? = "Cancel",
                       inputPlaceholder:String? = nil,
                       inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                       cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                       actionHandler: ((_ text: String?) -> Void)? = nil) -> UIAlertController {

      let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
      alert.addTextField { (textField:UITextField) in
          textField.placeholder = inputPlaceholder
          textField.keyboardType = inputKeyboardType
      }
      alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
          guard let textField =  alert.textFields?.first else {
              actionHandler?(nil)
              return
          }
          actionHandler?(textField.text)
      }))
      alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))

      return alert
  }

func createOptionAlert(title:String? = nil,
                       subtitle:String? = nil,
                       actionTitle:String? = "Add",
                       cancelTitle:String? = "Cancel",
                       cancelHandler: ((_ text: String?) -> Void)? = nil,
                       actionHandler: ((_ text: String?) -> Void)? = nil,
                       option1: String? = nil,
                       option2: String? = nil) -> UIAlertController {

      let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)

      alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
        actionHandler?(option1)
      }))
      alert.addAction(UIAlertAction(title: cancelTitle, style: .default, handler: { (action:UIAlertAction) in
        cancelHandler?(option2)
      }))

      return alert
  }
