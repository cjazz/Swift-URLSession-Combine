//
//  Models.swift
//  Swift-URLSession-Combine
//
//  Created by Adam Chin on 11/11/19.
//  Copyright © 2019 Adam Chin. All rights reserved.
//

import Foundation

enum HTTPError: LocalizedError {
  case statusCode
  case post
  case Todo
  case Card
}

struct Pst {
  let id: Int
  let title: String
  let body: String
  let userId: Int
  init(json: [String: Any]) {
    id = json["id"] as? Int ?? -1
    title = json["title"] as? String ?? ""
    body = json["body"] as? String ?? ""
    userId = json["userId"] as? Int ?? -1
  }
}

struct DPost: Decodable {
  let id: Int
  let title: String
  let body: String
  let userId: Int
  init(json: [String: Any]) {
    id = json["id"] as? Int ?? -1
    title = json["title"] as? String ?? ""
    body = json["body"] as? String ?? ""
    userId = json["userId"] as? Int ?? -1
  }
}

struct Post: Codable {
  let id: Int
  let title: String
  let body: String
  let userId: Int
}

struct Todo: Codable {
  let id: Int
  let title: String
  let completed: Bool
  let userId: Int
}

struct Card: Codable {
  let id:String?
  let name:String?
  let nationalPokedexNumber:Int?
  let imageUrl:String?
  let imageUrlHiRes:String?
}

struct Position: Codable, Identifiable {
  let id: String
  let type: String
  let url: String
  let company: String
  let location: String
  let title: String
}
