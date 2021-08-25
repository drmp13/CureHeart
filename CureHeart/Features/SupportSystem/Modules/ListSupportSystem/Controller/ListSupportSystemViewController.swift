//
//  ListSupportSystemViewController.swift
//  CureHeart
//
//  Created by Kendra Arsena on 29/07/21.
//

import UIKit

class ListSupportSystemViewController: UIViewController {

    @IBOutlet weak var TV_SupportSystem: UITableView!
    @IBOutlet weak var SegmentedControl_SupportSystem: UISegmentedControl!
    var dataPsikolog: [String: FetchSupportSystemData.RawServerResponse.PayloadData] = [:]
    var dataOrganisasi: [String: FetchSupportSystemData.RawServerResponse.PayloadData] = [:]
    
    var currentIndexpath = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let nib = UINib(nibName: "\(SupportSystemCell.self)", bundle: nil)
        TV_SupportSystem.register(nib, forCellReuseIdentifier: "supportSystemCell")
        TV_SupportSystem.dataSource = self
        TV_SupportSystem.delegate = self
        
        FetchSupportSystemData().fetchAll(type: "psi"){ datas in
            self.dataPsikolog = datas.data
            DispatchQueue.main.async {
                self.TV_SupportSystem.reloadData()
            }
        }
        
        FetchSupportSystemData().fetchAll(type: "org"){ datas in
            self.dataOrganisasi = datas.data
        }
        
    }
    
    @IBAction func didSelectOnSegmentedControl_SupportSystem(_ sender: Any) {
        TV_SupportSystem.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToDetailPage" {
            let dest = segue.destination as! DetailSupportSystemViewController
            dest.index = currentIndexpath
            if SegmentedControl_SupportSystem.selectedSegmentIndex == 0 {
                dest.type = "psi"
            } else {
                dest.type = "org"
            }
        }
    }
}
