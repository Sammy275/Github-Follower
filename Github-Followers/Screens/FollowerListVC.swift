//
//  ListFollowersViewController.swift
//  Github-Followers
//
//  Created by Saim on 05/09/2023.
//

import UIKit

class FollowerListVC: BaseViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Follower>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Follower>
    
    var datasource: DataSource!
    
    @IBOutlet var followersCollectionView: UICollectionView!
    @IBOutlet var noUserLbl: UILabel!
    
    let searchController = UISearchController()
    let favouriteUserManager = FavouriteUserManager()
    
    var username: String!
    var followerList: [Follower]!

    
    var isLoadable = true
    private var currentPage = 1
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if followerList.isEmpty {
            followersCollectionView.removeFromSuperview()
        }
        else {
            noUserLbl.removeFromSuperview()
            configureSearchController()
            configureDataSource()
            applySnapshot(followerList)
            
            followersCollectionView.delegate = self
        }
    }
    
    private func getFavouriteStatus() -> Bool {
        if favouriteUserManager.get(byUsername: username) != nil {
            return true
        }
        return false
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = username
        
        var heartIcon = UIImage(systemName: "heart")
        
        if getFavouriteStatus() {
            heartIcon = UIImage(systemName: "heart.fill")
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: heartIcon, style: .plain, target: self, action: #selector(favouriteBtnTapped))
    }
    
    private func configureDataSource() {
        datasource = DataSource(collectionView: followersCollectionView, cellProvider: { (collectionView, indexPath, follower) -> FollowerCollectionCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "followersCollectionCell", for: indexPath) as! FollowerCollectionCell
            
            cell.imageView.kf.setImage(with: URL(string: follower.imageURL)!)
            cell.textLbl.text = follower.username
            
            return cell
        })
    }
    
    func loadMoreData() {
        if isLoadable == false {
            return
        }
        
        currentPage += 1
        
        let url = GithubFollowerAPI.getURL(for: username, pageNo: currentPage)
        
        NetworkManager.getDataFromAPI(url: url) { (followerList: [Follower]?) in
            if let paginatedFollowerList = followerList {
                if paginatedFollowerList.isEmpty {
                    self.isLoadable = false
                    return
                }
                
                DispatchQueue.main.async {
                    self.followerList.append(contentsOf: paginatedFollowerList)
                    self.applySnapshot(self.followerList)
                }
            }
        }
        
    }
    
    func applySnapshot(_ dataList: [Follower]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(dataList)
        datasource.apply(snapshot)
    }
    
    func openUserDetailVC(for follower: String) {
        let userDetailURL = GithubUserAPI.getURL(for: follower)
        
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
    
    @objc func favouriteBtnTapped() {
        let favouriteUserManager = FavouriteUserManager()
        
        if getFavouriteStatus() {
            GFAlertVC.showAlert(on: self, title: "Hold up!", content: "You have already favourited this user 😌", buttonText: "Alright")
            return
        }
        
        // Get user's detail from the API
        let userDetailURL = GithubUserAPI.getURL(for: username)
        
        NetworkManager.getDataFromAPI(url: userDetailURL) { (favouritedUser: FavouriteUser?) in
            guard let favouritedUser = favouritedUser else {
                DispatchQueue.main.async {
                    GFAlertVC.showAlert(on: self, title: "Oh no", content: "Problem during favouriting the user", buttonText: "Ok 😞")
                }
                return
            }
            
            favouriteUserManager.create(favouritedUser)
            
            DispatchQueue.main.async {
                GFAlertVC.showAlert(on: self, title: "Success!", content: "You have favourited this user 🎊", buttonText: "Hooray!")
            }
        }
        
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
    }
}
