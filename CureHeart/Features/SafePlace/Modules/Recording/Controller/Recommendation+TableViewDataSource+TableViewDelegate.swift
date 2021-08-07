//
//  Recommendation+TableViewDataSource+TableViewDelegate.swift
//  CureHeart
//
//  Created by Kendra Arsena on 07/08/21.
//

import UIKit
import MessageUI

extension RecommendationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "supportSystemCell") as! SupportSystemCell
        if list_data_recommendation["\(indexPath.section)"]?.logo != "" {
            let url = URL(string: "https://bkpm-infomedia.com/drmp/cureheart/sp_logo/" + list_data_recommendation["\(indexPath.section)"]!.logo)!
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        cell.SupportSystemCell_ImageView.image = UIImage(data: data)
                    }
                }
            }
        } else {
            cell.SupportSystemCell_ImageView.image = UIImage(named: "noimage")
        }
        cell.SupportSystemCell_LabelName.text = list_data_recommendation["\(indexPath.section)"]?.name
        cell.SupportSystemCell_LabelDescription.text = list_data_recommendation["\(indexPath.section)"]?.description_short
        
        cell.BackgroundSupportSystemCell.layer.cornerRadius = 20
        cell.BackgroundSupportSystemCell.layer.masksToBounds = false
        cell.BackgroundSupportSystemCell.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.BackgroundSupportSystemCell.layer.shadowOpacity = 0.3
        cell.BackgroundSupportSystemCell.layer.shadowOffset = CGSize(width: 0, height: 3)
        cell.BackgroundSupportSystemCell.layer.shadowRadius = 2
        cell.BackgroundSupportSystemCell.layer.shouldRasterize = true
        cell.BackgroundSupportSystemCell.layer.rasterizationScale = UIScreen.main.scale
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return list_data_recommendation.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 60, y: 0, width: tableView.frame.width - 60, height: 0.5))
        footerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return footerView
    }
}

extension RecommendationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentindex = indexPath.section
        showActionSheet()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if list_data_recommendation["\(currentindex)"]?.whatsapp != "" {
            let image = UIImage(named: "whatsapp")
            let whatsapp = UIAlertAction(title: "WA \(list_data_recommendation["\(currentindex)"]?.name ?? "")", style: .default, handler: whatsapp)
            whatsapp.setValue(image!.withRenderingMode(.alwaysOriginal), forKey: "image")
            actionSheet.addAction(whatsapp) }
        
        if list_data_recommendation["\(currentindex)"]?.phone != "" {
            let image = UIImage(named: "call")
            let phone = UIAlertAction(title: "Call \(list_data_recommendation["\(currentindex)"]?.name ?? "")", style: .default, handler: call)
            phone.setValue(image!.withRenderingMode(.alwaysOriginal), forKey: "image")
            actionSheet.addAction(phone)
        }
        
        if list_data_recommendation["\(currentindex)"]?.email != "" {
            let image = UIImage(named: "mail")
            let email = UIAlertAction(title: "Email \(list_data_recommendation["\(currentindex)"]?.name ?? "")", style: .default, handler: email)
            email.setValue(image!.withRenderingMode(.alwaysOriginal), forKey: "image")
            actionSheet.addAction(email)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }
    
    func whatsapp(action: UIAlertAction) {
        if let url = URL(string: "https://wa.me/+62" + list_data_recommendation["\(currentindex)"]!.whatsapp){
            UIApplication.shared.open(url)
        }
    }
    
    func email(action: UIAlertAction) {
        let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients(["\(list_data_recommendation["\(currentindex)"]?.email ?? "")"])
//            mailVC.setSubject("Subject for email")
//            mailVC.setMessageBody("Email message string", isHTML: false)

        present(mailVC, animated: true, completion: nil)
    }
    
    func call(action: UIAlertAction) {
        if let url = URL(string: "tel://" + list_data_recommendation["\(currentindex)"]!.phone) {
            UIApplication.shared.open(url)
        }
    }
}
