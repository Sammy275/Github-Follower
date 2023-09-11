//
//  CachedImageView.swift
//  Github-Followers
//
//  Created by Saim on 06/09/2023.
//

import UIKit

class CachedImageView: UIImageView {
    static let defaultImage = UIImage(named: "gh-logo")
    var task: URLSessionDataTask!
    
    override func awakeFromNib() {
        layer.cornerRadius = 10.0
    }
    
    func styleImage() {
        print("Image styling")
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = 25.0
        
        self.contentMode = .scaleToFill
    }
    
    func loadImageFrom(url: URL) {
        image = CachedImageView.defaultImage
        
        if let task = task {
            task.cancel()
        }
        
        //        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
        //            self.image = imageFromCache
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
