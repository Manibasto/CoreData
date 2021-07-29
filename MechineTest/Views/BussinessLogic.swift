//
//  BussinessLogic.swift
//  MechineTest
//
//  Created by Mani on 3/11/21.
//

import Foundation

class DataModel: NSObject {
    weak var delegate : DataModelDelegate?
    func requestData() {
        Service.sharedInstance.userList { (response, error) in
            if error != nil {
                self.delegate?.didFailUpdateWithError(error: error!)
            } else if let response = response{
                self.setDataWithResponse(response: response as UserModel)
            }
        }
    }    
    private func setDataWithResponse(response:UserModel){
        delegate?.didRecieveDataUpdata(data: response.data ?? [])
    }
}
