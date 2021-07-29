//
//  ListSupportSystemViewController+TableViewDataSource+TableViewDelegate.swift
//  CureHeart
//
//  Created by Kendra Arsena on 29/07/21.
//

import UIKit

extension ListSupportSystemViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "supportSystemCell") as! SupportSystemCell
        
        cell.SupportSystemCell_ImageView.image = UIImage(named: "noimage")
        cell.SupportSystemCell_LabelName.text = "Hanania Consulting"
        cell.SupportSystemCell_LabelDescription.text = "Tempat konsultasi punya Hanania"
        cell.backgroundColor = #colorLiteral(red: 0.574837625, green: 0.690248549, blue: 0.7848291993, alpha: 1)
        cell.layer.cornerRadius = 20
        
        return cell
    }
    
    
}

extension ListSupportSystemViewController: UITableViewDelegate {
    
}
