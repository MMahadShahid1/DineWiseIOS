//
//  Media.swift
//  DineWise
//
//  Created by Muhammad Mahad on 2025-03-24.
//

import Foundation

enum MediaType: String, Codable {
    case image
    case video
}

struct Media: Codable {
    let id: String
    let url: String
    let type: MediaType

    init?(documentID: String, data: [String: Any]) {
        guard let url = data["url"] as? String,
              let typeString = data["type"] as? String,
              let type = MediaType(rawValue: typeString) else {
            return nil
        }
        self.id = documentID
        self.url = url
        self.type = type
    }
}

