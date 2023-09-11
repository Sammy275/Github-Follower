//
//  CachedImageView.swift
//  Github-Followers
//
//  Created by Saim on 06/09/2023.
//

import UIKit

class GFImageView: UIImageView {
    static let defaultImage = UIImage(named: "gh-logo")
    
    override func awakeFromNib() {
        layer.cornerRadius = 10.0
    }
}
