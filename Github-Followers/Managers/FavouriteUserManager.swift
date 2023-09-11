//
//  FavouriteUserManager.swift
//  Github-Followers
//
//  Created by Saim on 08/09/2023.
//

import Foundation

class FavouriteUserManager {
    private let userDataRepository = FavouriteUserDataRepository()
    
    func create(_ user: FavouriteUser) {
        userDataRepository.create(record: user)
    }
    
    func getAll() -> [FavouriteUser] {
        userDataRepository.getAll()
    }
    
    func get(byUsername username: String) -> FavouriteUser? {
        userDataRepository.get(byIdentifier: username)
    }
    
    func update(_ user: FavouriteUser) {
        userDataRepository.update(record: user)
    }
    
    func delete(byUsername username: String) {
        userDataRepository.delete(byIdentifier: username)
    }
    
    func checkIfExists(by username: String) -> Bool {
        guard let _ = get(byUsername: username) else {
            return false
        }
        return true
    }
}

