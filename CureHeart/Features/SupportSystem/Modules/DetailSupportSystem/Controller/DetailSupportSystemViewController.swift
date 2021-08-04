//
//  DetailSupportSystemViewController.swift
//  CureHeart
//
//  Created by Kendra Arsena on 31/07/21.
//

import UIKit

class DetailSupportSystemViewController: UIViewController {
    
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
    
    var nama = ""
    var deskripsi = ""
    var list_layanan = ""
    var hari_layanan = ""
    var jam_layanan = ""
    var alamat = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            label_list_layanan.text = detailData["\(index)"]?.services[i].value
        }
        for i in 0..<(detailData["\(index)"]?.schedules.count)! {
            label_hari_layanan.text = detailData["\(index)"]?.schedules[i].value
        }
        label_alamat.text = detailData["\(index)"]?.address
        
        button_contact.layer.cornerRadius = 10
    }
    
    @IBAction func buttonContact_onClick(_ sender: Any) {
        
    }
    
}
