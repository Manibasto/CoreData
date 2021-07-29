//
//  Constant.swift
//  MechineTest
//
//  Created by Mani on 3/11/21.
//

import Foundation

struct APPURL {
   private struct Domains {
       static let Dev = "https://reqres.in/"
   }
   private  struct Routes {
       static let users = "api/users"
   }
   private  static let Domain = Domains.Dev
   private  static let Route = Routes.users
   static let BaseURL = Domain + Route
}

let reload = NSNotification.Name("reload")
