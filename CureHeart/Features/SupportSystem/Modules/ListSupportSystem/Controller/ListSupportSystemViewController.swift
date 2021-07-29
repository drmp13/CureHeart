//
//  ListSupportSystemViewController.swift
//  CureHeart
//
//  Created by Kendra Arsena on 29/07/21.
//

import UIKit

class ListSupportSystemViewController: UIViewController {

    @IBOutlet weak var TV_SupportSystem: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "\(SupportSystemCell.self)", bundle: nil)
        TV_SupportSystem.register(nib, forCellReuseIdentifier: "supportSystemCell")
        TV_SupportSystem.dataSource = self
        TV_SupportSystem.delegate = self
    }
}
