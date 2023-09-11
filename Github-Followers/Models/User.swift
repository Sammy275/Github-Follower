//
//  User.swift
//  Github-Followers
//
//  Created by Saim on 05/09/2023.
//

import Foundation

struct User: Decodable {
    let username: String
    let name: String
    let location: String
    let imageURL: String
    let bio: String
    let publicRepositories: Int
    let publicGists: Int
    let followers: Int
    let following: Int
    let followersURL: URL
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case name, location, bio, followers, following
        case username = "login"
        case imageURL = "avatar_url"
        case publicRepositories = "public_repos"
        case publicGists = "public_gists"
        case followersURL = "followers_url"
        case createdAt = "created_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        name = (try? container.decode(String.self, forKey: .name)) ?? ""
        location = (try? container.decode(String.self, forKey: .location)) ?? ""
        bio = (try? container.decode(String.self, forKey: .bio)) ?? ""
        followers = try! container.decode(Int.self, forKey: .followers)
        following = try! container.decode(Int.self, forKey: .following)
        username = try! container.decode(String.self, forKey: .username)
        imageURL = try! container.decode(String.self, forKey: .imageURL)
        publicRepositories = try! container.decode(Int.self, forKey: .publicRepositories)
        publicGists = try! container.decode(Int.self, forKey: .publicGists)
        followersURL = try! container.decode(URL.self, forKey: .followersURL)
        
        let rawISODate = try! container.decode(String.self, forKey: .createdAt)
        let isoFormatter = ISO8601DateFormatter()
        createdAt = isoFormatter.date(from: rawISODate)!
    }
}
