//
//  FavouriteUser.swift
//  Github-Followers
//
//  Created by Saim on 08/09/2023.
//


struct FavouriteUser: Decodable {
    let username: String
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case username = "login"
        case imageURL = "avatar_url"
    }

    init(username: String, imageURL: String) {
        self.username = username
        self.imageURL = imageURL
    }
}
