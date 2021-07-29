//
//  Singleton.swift
//  MechineTest
//
//  Created by Mani on 3/12/21.
//

import Foundation
import CoreData
import UIKit

class Singleton {
    static let shared = Singleton()
    var userDetail = [Datum]()
    func saveData(){
        userDetail.forEach { (model) in
            save(data: model)
        }
    }
    func retrive(){
        retrieve_data()
    }
}

