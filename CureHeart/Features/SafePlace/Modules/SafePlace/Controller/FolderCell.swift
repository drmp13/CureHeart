//
//  FolderCell.swift
//  CureHeart
//
//  Created by Dwi RIzki Manggala Putra on 01/08/21.
//

import UIKit

class FolderCell: UITableViewCell {

  @IBOutlet weak var MainFrame: UIView!
  @IBOutlet weak var innerFrame: UIView!
  @IBOutlet weak var labelFolderName: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        innerFrame.layer.cornerRadius = 10

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
