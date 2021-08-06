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
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        button_contact.layer.cornerRadius = 10
        
        FetchSupportSystemData().fetchAll(type: "\(type)"){ datas in
            self.detailData = datas.data
            DispatchQueue.main.async {
                self.setUI()
            }
        }
    }
    
    func setUI() {
        if detailData["\(index)"]?.logo != "" {
            getImage()
        } else {
            image_layanan.image = UIImage(named: "noimage")
        }
        
        label_nama.text = detailData["\(index)"]?.name
        label_deskripsi.text = detailData["\(index)"]?.description
        
        for i in 0..<(detailData["\(index)"]?.services.count)! {
            array_list_layanan.append("\(detailData["\(index)"]?.services[i].value ?? "")")
        }
        label_list_layanan.text = array_list_layanan.joined(separator: "\n")

        if (detailData["\(index)"]?.schedules.count)! > 0 {
            for i in 0..<(detailData["\(index)"]?.schedules.count)! {
                array_list_jadwal.append("\(detailData["\(index)"]?.schedules[i].value ?? "")")
            }
            label_hari_layanan.text = array_list_jadwal.joined(separator: "\n")
        } else {
            label_hari_layanan.text = "-"
        }
        
        if detailData["\(index)"]?.address != "" {
            label_alamat.text = detailData["\(index)"]?.address
        } else {
            label_alamat.text = "-"
        }
    }
    
    func getImage() {
        guard let url = URL(string: "https://bkpm-infomedia.com/drmp/cureheart/sp_logo/" + detailData["\(index)"]!.logo) else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.image_layanan.image = UIImage(data: data)
                }
            }
        }
    }
    
    @IBAction func buttonContact_onClick(_ sender: Any) {
        showActionSheet()
    }
    
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if detailData["\(index)"]?.whatsapp != "" {
            let image = UIImage(named: "whatsapp")
            let whatsapp = UIAlertAction(title: "WA \(detailData["\(index)"]?.name ?? "")", style: .default, handler: whatsapp)
            whatsapp.setValue(image!.withRenderingMode(.alwaysOriginal), forKey: "image")
            actionSheet.addAction(whatsapp) }
        
        if detailData["\(index)"]?.phone != "" {
            let image = UIImage(named: "call")
            let phone = UIAlertAction(title: "Call \(detailData["\(index)"]?.name ?? "")", style: .default, handler: call)
            phone.setValue(image!.withRenderingMode(.alwaysOriginal), forKey: "image")
            actionSheet.addAction(phone)
        }
        
        if detailData["\(index)"]?.email != "" {
            let image = UIImage(named: "mail")
            let email = UIAlertAction(title: "Email \(detailData["\(index)"]?.name ?? "")", style: .default, handler: email)
            email.setValue(image!.withRenderingMode(.alwaysOriginal), forKey: "image")
            actionSheet.addAction(email)
        }
        
        if detailData["\(index)"]?.whatsapp == "" && detailData["\(index)"]?.phone == "" && detailData["\(index)"]?.email == "" {
            goToWebsite()
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
    
    func goToWebsite() {
        if let url = URL(string: detailData["\(index)"]?.website ?? "") {
            UIApplication.shared.open(url)
        }
    }
}
