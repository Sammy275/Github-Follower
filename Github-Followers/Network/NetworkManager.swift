//
//  NetworkManager.swift
//  Github-Followers
//
//  Created by Saim on 06/09/2023.
//

import Foundation

class NetworkManager {
    static func getDataFromAPI<T: Decodable>(url: URL, headers: [String: String] = [:], completion: @escaping (T?) -> Void) {
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        for header in headers {
            print(header.key)
            print(header.value)
            request.setValue(header.key, forHTTPHeaderField: header.value)
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil) // Pass nil to the completion handler in case of an error
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil) // Pass nil to the completion handler if no data is received
                return
            }
            
            do {
                let data = try JSONDecoder().decode(T.self, from: data)
                completion(data) // Pass the decoded data to the completion handler
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil) // Pass nil to the completion handler if decoding fails
            }
        }.resume()
    }
}
