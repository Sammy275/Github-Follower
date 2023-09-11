//
//  GithubUserAPI.swift
//  Github-Followers
//
//  Created by Saim on 07/09/2023.
//

import Foundation

struct GithubUserAPI {
    static func getURL(for username: String) -> URL {
        URL(string: "https://api.github.com/users/\(username.lowercased())")!
    }
}
