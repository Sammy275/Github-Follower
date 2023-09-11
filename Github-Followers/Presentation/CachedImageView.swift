//
//  CachedImageView.swift
//  Github-Followers
//
//  Created by Saim on 06/09/2023.
//

import UIKit

class CachedImageView: UIImageView {
    static let defaultImage = UIImage(named: "gh-logo")
//    let imageCache = NSCache<AnyObject, AnyObject>()
    var task: URLSessionDataTask!
    
    override func awakeFromNib() {
        layer.cornerRadius = 10.0
    }
    
    func styleImage() {
        print("Image styling")
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = 25.0
        
//        self.contentMode = .scaleToFill
    }
    
    func loadImageFrom(_ url: URL) {
        if let task = task {
            task.cancel()
        }
        
        image = CachedImageView.defaultImage
        
//        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
//            self.image = imageFromCache
//            print("Using Cache")
//            return
//        }
        
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, let newImage = UIImage(data: data) else {
                return
            }
            
//            self.imageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)
            
            DispatchQueue.main.async {
                self.image = newImage
            }
        }
        
        task.resume()
    }
}
