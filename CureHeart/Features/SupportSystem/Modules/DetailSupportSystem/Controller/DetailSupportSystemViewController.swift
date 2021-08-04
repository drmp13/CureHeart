//
//  DetailSupportSystemViewController.swift
//  CureHeart
//
//  Created by Kendra Arsena on 31/07/21.
//

import UIKit
import MessageUI

class DetailSupportSystemViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var detailData: [String: FetchSupportSystemData.RawServerResponse.PayloadData] = [:]
    var type = ""
    var index = 0

    @IBOutlet weak var image_layanan: UIImageView!
    @IBOutlet weak var label_nama: UILabel!
    @IBOutlet weak var label_deskripsi: UILabel!
    @IBOutlet weak var label_layanan: UILabel!
    @IBOutlet weak var label_list_layanan: UILabel!
    @IBOutlet weak var label_waktu_layanan: UILabel!
    @IBOutlet weak var label_hari_layanan: UILabel!
    @IBOutlet weak var label_lokasi: UILabel!
    @IBOutlet weak var label_alamat: UILabel!
    @IBOutlet weak var button_contact: UIButton!
    
    var array_list_layanan: [String] = []
    var array_list_jadwal: [String] = []
    
    var list_layanan: String = ""
    var list_jadwal: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button_contact.layer.cornerRadius = 10
        
        FetchSupportSystemData().fetchAll(type: "\(type)"){ datas in
            self.detailData = datas.data
            DispatchQueue.main.async {
                self.setUI()
            }
        }
    }
    
    func setUI() {
        label_nama.text = detailData["\(index)"]?.name
        label_deskripsi.text = detailData["\(index)"]?.description
        
        for i in 0..<(detailData["\(index)"]?.services.count)! {
            array_list_layanan.append("\(detailData["\(index)"]?.services[i].value ?? "")")
        }
        label_list_layanan.text = array_list_layanan.joined(separator: "\n")

        for i in 0..<(detailData["\(index)"]?.schedules.count)! {
            array_list_jadwal.append("\(detailData["\(index)"]?.schedules[i].value ?? "")")
        }
        print(array_list_jadwal)
        label_hari_layanan.text = array_list_jadwal.joined(separator: "\n")
        
        label_alamat.text = detailData["\(index)"]?.address
    }
    
    @IBAction func buttonContact_onClick(_ sender: Any) {
        showActionSheet()
    }
    
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if detailData["\(index)"]?.whatsapp != nil {
            let whatsapp = UIAlertAction(title: "WA \(detailData["\(index)"]?.name ?? "")", style: .default, handler: whatsapp)
            actionSheet.addAction(whatsapp) }
        
        if detailData["\(index)"]?.phone != nil {
            let phone = UIAlertAction(title: "Call \(detailData["\(index)"]?.name ?? "")", style: .default, handler: call)
            actionSheet.addAction(phone)
        }
        
        if detailData["\(index)"]?.email != nil {
            let email = UIAlertAction(title: "Email \(detailData["\(index)"]?.name ?? "")", style: .default, handler: email)
            actionSheet.addAction(email)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }
    
    func whatsapp(action: UIAlertAction) {
        if let url = URL(string: "https://wa.me/+62" + detailData["\(index)"]!.whatsapp){
            UIApplication.shared.open(url)
        }
    }
    
    func email(action: UIAlertAction) {
        let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients(["\(detailData["\(index)"]?.email ?? "")"])
//            mailVC.setSubject("Subject for email")
//            mailVC.setMessageBody("Email message string", isHTML: false)

        present(mailVC, animated: true, completion: nil)
    }
    
    func call(action: UIAlertAction) {
        if let url = URL(string: "tel://" + detailData["\(index)"]!.phone) {
            UIApplication.shared.open(url)
        }
    }
}
