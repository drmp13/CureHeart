//
//  FetchSupportSystemData.swift
//  CureHeart
//
//  Created by Kendra Arsena on 02/08/21.
//

import UIKit

class FetchSupportSystemData: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


  struct RawServerResponse: Codable {
      struct PayloadData: Codable {
        struct Schedule: Codable{
          let value: String
        }

        struct Services: Codable{
          let value: String
        }

        let id: String
        let name: String
        let description: String
        let logo: String
        let type: String
        let address: String
        let phone: String
        let whatsapp: String
        let email: String
        let schedules: [Schedule]
        let services: [Services]
      }

      let status: Int
      let message: String
      let data: [String: PayloadData]
  }



//  FetchSupportSystemData().fetchAll(type: "psi"){ datas in
//    print(datas)
//  }

  func fetchAll(type: String, completionHandler: @escaping (RawServerResponse) -> Void) {
    let queryItems = [URLQueryItem(name: "type", value: type)]
    var urlComps = URLComponents(string: "https://bkpm-infomedia.com/drmp/cureheart/api/support-system/fetch-organisations")!
    urlComps.queryItems = queryItems

    guard let url = urlComps.url else { return }
            URLSession.shared.dataTask(with: url) { (data, _, _) in
                let users = try! JSONDecoder().decode(RawServerResponse.self, from: data!)

                DispatchQueue.main.async {
                  completionHandler(users)
                }
            }
            .resume()

    }

}
