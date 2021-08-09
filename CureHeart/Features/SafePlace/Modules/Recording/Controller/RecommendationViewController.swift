//
//  RecommendationViewController.swift
//  CureHeart
//
//  Created by Kendra Arsena on 07/08/21.
//

import UIKit
import MessageUI

class RecommendationViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var label_recommendation: UILabel!
    @IBOutlet weak var tv_list_recommendation: UITableView!
    
    var list_data_recommendation: [String: FetchSupportSystemData.RawServerResponse.PayloadData] = [:]
    
    var currentindex: Int = 0
    var recommendation_type: String = ""
    var concerning_point = 0
    
    @IBOutlet weak var button_backToSafePlace: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    func setUI() {
        tv_list_recommendation.isScrollEnabled = false
        
        button_backToSafePlace.layer.cornerRadius = 10
        
        // TAMBAH IF RECOMMENDATION = PSI
        label_recommendation.text = "Based on your story, it would be great if you meet psychologist in order to relieve you from this situation."
        
        // TAMBAH ELSE IF RECOMMENDATION = ORG
        label_recommendation.text = "Based on your story, it would be great if you meet someone who could help you furthermore than us in this situation."
        
        let nib = UINib(nibName: "\(SupportSystemCell.self)", bundle: nil)
        tv_list_recommendation.register(nib, forCellReuseIdentifier: "supportSystemCell")
        tv_list_recommendation.dataSource = self
        tv_list_recommendation.delegate = self
        
      if(recommendation_type != "" && concerning_point>=5){
        FetchSupportSystemData().fetchRecommendation(type: recommendation_type){ datas in
            self.list_data_recommendation = datas.data
            DispatchQueue.main.async {
                self.tv_list_recommendation.reloadData()
            }
        }
      }

        

    }
}
