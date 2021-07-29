//
//  APIManager.swift
//  MechineTest
//
//  Created by Mani on 3/11/21.
//

import Foundation

class Service : NSObject{
    static let sharedInstance = Service()
    func userList(completion: ((UserModel?, Error?) -> Void)?) {
        guard let gitUrl = URL(string: APPURL.BaseURL) else { return }
        URLSession.shared.dataTask(with: gitUrl) { (data, response
                                                    , error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let gitData = try decoder.decode(UserModel.self, from: data)
                DispatchQueue.main.async {
                    completion!(gitData,nil)
                }
            } catch let err {
                print("Err", err)
                DispatchQueue.main.async {
                    completion!(nil,err)
                }
            }
        }.resume()
    }
}
