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
        
        if SegmentedControl_SupportSystem.selectedSegmentIndex == 0 {
            // ISI DATA MENTAL HEALTH
            cell.SupportSystemCell_ImageView.image = UIImage(named: "noimage")
            cell.SupportSystemCell_LabelName.text = "Hanania Consulting"
            cell.SupportSystemCell_LabelDescription.text = "Tempat konsultasi punya Hanania"
        } else {
            // ISI DATA ORGANIZATION
            cell.SupportSystemCell_ImageView.image = UIImage(named: "noimage")
            cell.SupportSystemCell_LabelName.text = "Awas KBGO"
            cell.SupportSystemCell_LabelDescription.text = "Lembaga bantuan hukum"
        }
        cell.BackgroundSupportSystemCell.layer.cornerRadius = 20
        cell.BackgroundSupportSystemCell.layer.masksToBounds = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // JUMLAH DATA
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 60, y: 0, width: tableView.frame.width - 60, height: 0.5))
        footerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        let gradient = CAGradientLayer()
//        gradient.frame = footerView.bounds
//        gradient.colors = [UIColor.black.cgColor, UIColor.gray.cgColor]
//        footerView.layer.insertSublayer(gradient, at: 0)
        return footerView
    }
}

extension ListSupportSystemViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SegueToDetailPage", sender: self)
    }
}
