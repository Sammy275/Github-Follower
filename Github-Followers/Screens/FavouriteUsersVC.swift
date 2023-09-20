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
    var favouriteUserList: [FavouriteUser] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let favouritedUsers = favouriteUserManager.getAll()
        if favouriteUserList.count != favouritedUsers.count {
            for newUser in favouritedUsers[favouriteUserList.count..<favouritedUsers.count] {
                favouriteUserList.append(newUser)
                insertNewRow(itemNumber: favouriteUserList.count - 1)
            }
        }
    
        setTableVisibility()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favouriteUserTView.delegate = self
        favouriteUserTView.dataSource = self
    }
    
    func canHideTableView() -> Bool {
        if favouriteUserList.isEmpty {
            return true
        }
        return false
    }
    
    func insertNewRow(itemNumber: Int) {
        let newIndexPath = IndexPath(item: itemNumber, section: 0)
        
        favouriteUserTView.beginUpdates()
        favouriteUserTView.insertRows(at: [newIndexPath], with: .automatic)
        favouriteUserTView.endUpdates()
    }
    
    func setTableVisibility() {
        if canHideTableView() {
            favouriteUserTView.isHidden = true
            return
        }
        favouriteUserTView.isHidden = false
    }
}


extension FavouriteUsersVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteUserTableCell") as! FavouriteUserTableViewCell
        
        
        
        let userImageURL = URL(string: favouriteUserList[indexPath.row].imageURL)!
        cell.userImage.kf.setImage(with: userImageURL)
        cell.usernameLbl.text = favouriteUserList[indexPath.row].username
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userDetailURL = GithubUserAPI.getURL(for: favouriteUserList[indexPath.row].username)
        NetworkManager.getDataFromAPI(url: userDetailURL) { (userDetail: User?) in
            guard let user = userDetail else {
                DispatchQueue.main.async {
                    GFAlertVC.showAlert(on: self, title: "Something is wrong", content: "Please try again!", buttonText: "Ok")
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
        favouriteUserManager.delete(byUsername: favouriteUserList[indexPath.row].username)
        favouriteUserList.remove(at: indexPath.row)
        
        tableView.performBatchUpdates {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } completion: { didUpdateComplete in
            print("A new crispy table")
            self.setTableVisibility()
        }
    }
}


extension FavouriteUsersVC: UserDetailsDelegate {
    func followerButtonTapped(followerName: String) {
        openFollowerColletionVCFor(username: followerName)
    }
}
