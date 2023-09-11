//
//  FavouriteUserDataRepository.swift
//  Github-Followers
//
//  Created by Saim on 08/09/2023.
//

import Foundation

struct FavouriteUserDataRepository: RepositoryProtocol {
    private static let modelName = "favouriteUser"
    
    func create(record: FavouriteUser) {
        let userDictionary: Dictionary<String, String> = [
            "username": record.username,
            "imageURL": record.imageURL
        ]
        
        if let userArray = UserDefaults.standard.array(forKey: FavouriteUserDataRepository.modelName)
        {
            var updatedArray = userArray
            updatedArray.append(userDictionary)
            
            UserDefaults.standard.set(updatedArray, forKey: FavouriteUserDataRepository.modelName)
        }
        else {
            UserDefaults.standard.set([userDictionary], forKey: FavouriteUserDataRepository.modelName)
        }
    }
    
    func getAll() -> [FavouriteUser] {
        if let userArray = UserDefaults.standard.array(forKey: FavouriteUserDataRepository.modelName)
        {
            return userArray.map { userData in
                let userDictionary = userData as! Dictionary<String, String>
                
                return FavouriteUser(username: userDictionary["username"]!, imageURL: userDictionary["imageURL"]!)
            }
        }
        else {
            return []
        }
    }
    
    func get(byIdentifier username: String) -> FavouriteUser? {
        guard let userArray = UserDefaults.standard.array(forKey: FavouriteUserDataRepository.modelName) else {
            return nil
        }
        
        guard let foundUser = userArray.first(where: { userData in
            let userDictionary = userData as! Dictionary<String, String>
            let storedUserName = userDictionary["username"]!
            
            return username == storedUserName
        }) as? Dictionary<String, String>
        else {
            return nil
        }
        
        return FavouriteUser(username: foundUser["username"]!, imageURL: foundUser["imageURL"]!)
    }
    
    func update(record: FavouriteUser) {
        guard var userArray = UserDefaults.standard.array(forKey: FavouriteUserDataRepository.modelName) else {
            return
        }
        
        guard let indexOfUserToUpdate = userArray.firstIndex(where: { userData in
            let userDictionary = userData as! Dictionary<String, String>
            let currentUserName = userDictionary["username"]!
            
            return currentUserName == record.username
        }) else {
            return
        }
        
        var userToUpdate = userArray[indexOfUserToUpdate] as? Dictionary<String, String>
        userToUpdate!["username"] = record.username
        
        userArray.remove(at: indexOfUserToUpdate)
        userArray.append(userToUpdate!)
    }
    
    func delete(byIdentifier username: String) {
        guard let userArray = UserDefaults.standard.array(forKey: FavouriteUserDataRepository.modelName) else {
            return
        }
        
        guard let indexOfUserToDelete = userArray.firstIndex(where: { userData in
            let userDictionary = userData as! Dictionary<String, String>
            let currentUserName = userDictionary["username"]!
            
            return currentUserName == username
        }) else {
            return
        }
        
        var updatedArray = userArray
        updatedArray.remove(at: indexOfUserToDelete)
        
        
        UserDefaults.standard.set(updatedArray, forKey: FavouriteUserDataRepository.modelName)
    }
    
    typealias Record = FavouriteUser
    typealias Identifier = String
}

