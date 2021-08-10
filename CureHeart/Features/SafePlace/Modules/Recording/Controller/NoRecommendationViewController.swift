//
//  NoRecommendationViewController.swift
//  CureHeart
//
//  Created by Dwi RIzki Manggala Putra on 09/08/21.
//

import UIKit

class NoRecommendationViewController: UIViewController {

  @IBOutlet weak var backtoSafePlaceButton: UIButton!
  override func viewDidLoad() {
        super.viewDidLoad()
    backtoSafePlaceButton.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
  @IBAction func dismissAll(_ sender: UIButton) {
    if let first = presentingViewController,
            let second = first.presentingViewController, let third = second.presentingViewController{
              first.view.isHidden = true
              first.dismiss(animated: false)
              second.dismiss(animated: false)
              third.dismiss(animated: true)
         }
  }

}
