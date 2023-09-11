//
//  FavouriteUsersVC.swift
//  Github-Followers
//
//  Created by Saim on 08/09/2023.
//

import UIKit

class FavouriteUsersVC: BaseViewController {
    @IBOutlet var favouriteUserTView: UITableView!
    
    let favouriteUserManager = FavouriteUserManager()
    
    var favouriteUserList: [FavouriteUser] = [] {
        didSet {
            favouriteUserTView.reloadData()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let favouritedUsers = favouriteUserManager.getAll()
        favouriteUserList = favouritedUsers
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favouriteUserTView.delegate = self
        favouriteUserTView.dataSource = self
    }
}


extension FavouriteUsersVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteUserTableCell") as! FavouriteUserTableViewCell
        
        let userImageURL = URL(string: favouriteUserList[indexPath.row].imageURL)!
        cell.userImage.loadImageFrom(url: userImageURL)
        cell.usernameLbl.text = favouriteUserList[indexPath.row].username
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userDetailURL = GithubUserAPI.getURL(for: favouriteUserList[indexPath.row].username)
        NetworkManager.getDataFromAPI(url: userDetailURL) { (userDetail: User?) in
            guard let user = userDetail else {
                DispatchQueue.main.async {
                    GFCustomAlertVC.showAlert(on: self, title: "Something is wrong", content: "Please try again!", buttonText: "Ok")
                }
                
                return
            }
            DispatchQueue.main.async {
                let userDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailsVC") as! UserDetailsVC
                
                userDetailsVC.imageUrl = URL(string: user.imageURL)!
                userDetailsVC.username = user.username
                userDetailsVC.name = user.name
                userDetailsVC.location = user.location
                userDetailsVC.bio = user.bio
                userDetailsVC.repositories = String(user.publicRepositories)
                userDetailsVC.gists = String(user.publicGists)
                userDetailsVC.followers = String(user.followers)
                userDetailsVC.followings = String(user.following)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM yyyy"
                let formattedDate = dateFormatter.string(from: user.createdAt)
                userDetailsVC.createDate = formattedDate
                
                userDetailsVC.delegate = self
                
                self.present(userDetailsVC, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        favouriteUserManager.delete(byUsername: favouriteUserList[indexPath.row].username)
        favouriteUserList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
}


extension FavouriteUsersVC: UserDetailsDelegate {
    func followerButtonTapped(followerName: String) {
        openFollowerColletionVCFor(username: followerName)
    }
}
