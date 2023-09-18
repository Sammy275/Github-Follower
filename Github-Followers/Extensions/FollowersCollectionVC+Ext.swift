//
//  FollowersCollectionVC+Ext.swift
//  Github-Followers
//
//  Created by Saim on 08/09/2023.
//

import UIKit

extension FollowerListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Returns the follower that is stored in the tapped item
        let follower = datasource.itemIdentifier(for: indexPath)!
        openUserDetailVC(for: follower.username)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastSection = collectionView.numberOfSections - 1
        let lastRow = collectionView.numberOfItems(inSection: lastSection) - 1
        
        // Check if the current indexPath represents the last item in the collection view
        if indexPath.section == lastSection && indexPath.row == lastRow {
            loadMoreData()
        }
    }
}

extension FollowerListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            isLoadable = true
            return
        }
        
        if searchText.isEmpty {
            isLoadable = true
            applySnapshot(followerList)
        }
        else {
            isLoadable = false
            let filteredFollowerList = followerList.filter {
                return $0.username.lowercased().contains(searchText.lowercased())
            }
            applySnapshot(filteredFollowerList)
        }
    }
    
    func configureSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a username"
        
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
    }
}

extension FollowerListVC: UserDetailsDelegate {
    func followerButtonTapped(followerName: String) {
        openFollowerColletionVCFor(username: followerName)
    }
}

extension FollowerListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = followersCollectionView.bounds.width
        
        return CGSize(width: collectionViewWidth/3 - 20, height: collectionViewWidth/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
