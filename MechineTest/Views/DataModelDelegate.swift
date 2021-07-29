//
//  DataModelDelegate.swift
//  MechineTest
//
//  Created by Mani on 3/11/21.
//

import Foundation
import UIKit

protocol DataModelDelegate:class {
    func didRecieveDataUpdata(data: [Datum])
    func didFailUpdateWithError(error:Error)
}
