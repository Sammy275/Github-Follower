//
//  ViewController.swift
//  Github-Followers
//
//  Created by Saim on 01/09/2023.
//

import UIKit

class FollowerSearchVC: BaseViewController {
    
    @IBOutlet var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        
        // When the user taps anywhere on the view, the keyboard will dismiss
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapOnView))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTapOnView() {
        usernameTextField.resignFirstResponder()
    }
    
    @IBAction func followersButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text, username.isEmpty == false else {
            GFCustomAlertVC.showAlert(on: self, title: "Empty Username!", content: "Please make sure to add a username in the box.", buttonText: "Ok")
            return
        }
        openFollowerColletionVCFor(username: username.lowercased())
        usernameTextField.text = ""
    }
}

extension FollowerSearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
}
