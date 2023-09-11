//
//  FavouriteUserTableViewCell.swift
//  Github-Followers
//
//  Created by Saim on 08/09/2023.
//

import UIKit

class FavouriteUserTableViewCell: UITableViewCell {
    @IBOutlet var userImage: GFImageView!
    @IBOutlet var usernameLbl: UILabel!
    
    override func awakeFromNib() {
        selectionStyle = .none
    }
}
