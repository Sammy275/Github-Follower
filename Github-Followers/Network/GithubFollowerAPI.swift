//
//  GithubAPI.swift
//  Github-Followers
//
//  Created by Saim on 06/09/2023.
//

import Foundation

struct GithubFollowerAPI {
    static func getURL(for username: String, pageNo: Int) -> URL {
        URL(string: "https://api.github.com/users/\(username.lowercased())/followers?per_page=50&page=\(pageNo)")!
    }
}
