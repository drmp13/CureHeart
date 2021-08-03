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
            cell.SupportSystemCell_LabelName.text = dataPsikolog["\(indexPath.section)"]?.name
            cell.SupportSystemCell_LabelDescription.text = dataPsikolog["\(indexPath.section)"]?.description
        } else {
            // ISI DATA ORGANIZATION
            cell.SupportSystemCell_ImageView.image = UIImage(named: "noimage")
            cell.SupportSystemCell_LabelName.text = dataOrganisasi["\(indexPath.section)"]?.name
            cell.SupportSystemCell_LabelDescription.text = dataOrganisasi["\(indexPath.section)"]?.description
        }
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // JUMLAH DATA
        if SegmentedControl_SupportSystem.selectedSegmentIndex == 0 {
            return dataPsikolog.count
        } else {
            return dataOrganisasi.count
        }
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

extension ListSupportSystemViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIndexpath = indexPath.section
        performSegue(withIdentifier: "SegueToDetailPage", sender: self)
    }
}
