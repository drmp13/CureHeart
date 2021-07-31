//
//  DetailSupportSystemViewController.swift
//  CureHeart
//
//  Created by Kendra Arsena on 31/07/21.
//

import UIKit

class DetailSupportSystemViewController: UIViewController {

    @IBOutlet weak var image_layanan: UIImageView!
    @IBOutlet weak var label_nama: UILabel!
    @IBOutlet weak var label_deskripsi: UILabel!
    @IBOutlet weak var label_layanan: UILabel!
    @IBOutlet weak var label_list_layanan: UILabel!
    @IBOutlet weak var label_waktu_layanan: UILabel!
    @IBOutlet weak var label_hari_layanan: UILabel!
    @IBOutlet weak var label_jam_layanan: UILabel!
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
        setUI()
    }
    
    func setUI() {
        // BELOM GANTI WEIGHT LABEL LAYANAN, WAKTU, dan LOKASI
        label_nama.text = nama
        label_deskripsi.text = deskripsi
        label_list_layanan.text = list_layanan
        label_hari_layanan.text = hari_layanan
        label_jam_layanan.text = jam_layanan
        label_alamat.text = alamat
        button_contact.layer.cornerRadius = 10
    }
    
    @IBAction func buttonContact_onClick(_ sender: Any) {
    }
    
}
