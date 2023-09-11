//
//  UserDetailsVC.swift
//  Github-Followers
//
//  Created by Saim on 07/09/2023.
//

import UIKit
import SafariServices

class UserDetailsVC: UIViewController {
    
    
    @IBOutlet private var userImage: CachedImageView!
    
    @IBOutlet private var usernameLbl: UILabel!
    @IBOutlet private var nameLbl: UILabel!
    @IBOutlet private var locationLbl: UILabel!
    
    @IBOutlet private var bioLbl: UILabel!
    
    @IBOutlet private var repoLbl: UILabel!
    @IBOutlet private var gistLbl: UILabel!
    
    @IBOutlet private var followersLbl: UILabel!
    @IBOutlet private var followingLbl: UILabel!
    
    @IBOutlet private var createDateLbl: UILabel!
    
    var imageUrl: URL!
    var username: String!
    var name: String!
    var location: String!
    var bio: String!
    var repositories: String!
    var gists: String!
    var followers: String!
    var followings: String!
    var createDate: String!
    var delegate: UserDetailsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLabels()
        configureNavigationBar()
    }
    
    func configureLabels() {
        userImage.loadImageFrom(url: imageUrl)
        usernameLbl.text = username
        
        nameLbl.text = name
        locationLbl.text = location
        
        if bio.isEmpty {
            bioLbl.isHidden = true
        }
        else {
            bioLbl.text = bio
        }
        
        repoLbl.text = repositories
        gistLbl.text = gists
        followersLbl.text = followers
        followingLbl.text = followings
        createDateLbl.text = "Github since \(createDate!)"
    }
    
    func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissController))
    }
    
    @objc func dismissController() {
        dismiss(animated: true)
    }
    
    
    @IBAction func profileBtnTapped(_ sender: UIButton) {
        print("Profile button tapped!")
        let profileUrl = URL(string: "https://github.com/\(username!)/")!
        let profileWebview = SFSafariViewController(url: profileUrl)
        present(profileWebview, animated: true)
    }
    
    
    @IBAction func getFollowerBtnTapped(_ sender: UIButton) {
        dismiss(animated: true)
        delegate?.followerButtonTapped(followerName: username)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

protocol UserDetailsDelegate {
    func followerButtonTapped(followerName: String) -> Void
}