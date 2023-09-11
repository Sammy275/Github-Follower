//
//  Follower.swift
//  Github-Followers
//
//  Created by Saim on 05/09/2023.
//

struct Follower: Decodable, Hashable {
    let username: String
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case username = "login"
        case imageURL = "avatar_url"
    }
}
