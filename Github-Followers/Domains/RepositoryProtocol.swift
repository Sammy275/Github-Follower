//
//  RepositoryProtocol.swift
//  Github-Followers
//
//  Created by Saim on 08/09/2023.
//

import Foundation

protocol RepositoryProtocol {
    associatedtype Record
    associatedtype Identifier
    
    func create(record: Record)
    func getAll() -> [Record]
    func get(byIdentifier: Identifier) -> Record?
    func update(record: Record)
    func delete(byIdentifier: Identifier)
}
