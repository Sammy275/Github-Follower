//
//  BaseViewController.swift
//  Github-Followers
//
//  Created by Saim on 08/09/2023.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func openFollowerColletionVCFor(username: String) {
        let followersURL = GithubFollowerAPI.getURL(for: username, pageNo: 1)
        NetworkManager.getDataFromAPI(url: followersURL) { (followerList: [Follower]?) in
            if let followerList = followerList {
                // Use the followerList here
                DispatchQueue.main.async {
                    let followersVC = self.storyboard?.instantiateViewController(withIdentifier: "followerCollectionVC") as! FollowerListVC
                    
                    followersVC.followerList = followerList
                    followersVC.username = username
                    
                    self.navigationController?.pushViewController(followersVC, animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    GFCustomAlertVC.showAlert(on: self, title: "Problem With Username", content: "The username may not be valid", buttonText: "Ok")
                }
                
            }
        }
    }
}
