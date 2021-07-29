//
//  UserModel.swift
//  MechineTest
//
//  Created by Mani on 3/11/21.
//

import Foundation

struct UserModel : Codable {
    let data : [Datum]?
    let page : Int?
    let perPage : Int?
    let support : Support?
    let total : Int?
    let totalPages : Int?
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case page = "page"
        case perPage = "per_page"
        case support = "support"
        case total = "total"
        case totalPages = "total_pages"
    }
}
struct Support : Codable {
    let text : String?
    let url : String?
    enum CodingKeys: String, CodingKey {
        case text = "text"
        case url = "url"
    }
}
struct Datum : Codable {
    let avatar : String?
    let email : String?
    let firstName : String?
    let id : Int?
    let lastName : String?
    enum CodingKeys: String, CodingKey {
        case avatar = "avatar"
        case email = "email"
        case firstName = "first_name"
        case id = "id"
        case lastName = "last_name"
    }
}

