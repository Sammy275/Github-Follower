//
//  GFCustomAlertVC.swift
//  Github-Followers
//
//  Created by Saim on 05/09/2023.
//

import UIKit

class GFAlertVC: UIViewController {
    
    var titleText: String!
    var contentText: String!
    var dissmissBtnText: String!
    
    
    let containerStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMainView()
        configureContent()
    }
    
    func configureContent() {
        let titleLbl = UILabel()
        let contentLbl = UILabel()
        let dismissButton = UIButton(type: .system) // Use .system type for standard UIButton appearance

        
        titleLbl.text = titleText
        titleLbl.numberOfLines = 0
        titleLbl.font = .systemFont(ofSize: 22, weight: .bold)
        titleLbl.textAlignment = .center
        
        contentLbl.text = contentText
        contentLbl.numberOfLines = 0
        contentLbl.textColor = .systemGray
        contentLbl.textAlignment = .center
        
        
        dismissButton.setTitle(dissmissBtnText, for: .normal)
        dismissButton.backgroundColor = .red // Set the background color to red
        dismissButton.setTitleColor(.white, for: .normal) // Set the title color to white
        dismissButton.layer.cornerRadius = 10.0

        let boldFont = UIFont.boldSystemFont(ofSize: 18) // Adjust the font size as needed
        dismissButton.titleLabel?.font = boldFont

        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true

        dismissButton.addTarget(self, action: #selector(dismissBtnTapped), for: .touchUpInside)

        
        containerStackView.addArrangedSubview(titleLbl)
        containerStackView.addArrangedSubview(contentLbl)
        containerStackView.addArrangedSubview(dismissButton)
    }
    
    func configureMainView() {
        self.view.addSubview(containerStackView)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        
        containerStackView.isLayoutMarginsRelativeArrangement = true
        containerStackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            containerStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            containerStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7)
        ])
        
        containerStackView.distribution = .fill
        containerStackView.alignment = .fill
        containerStackView.axis = .vertical
        containerStackView.spacing = 30
        
        containerStackView.layer.cornerRadius = 15
        containerStackView.layer.borderWidth = 2.0
        containerStackView.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor
        
        
        
        containerStackView.backgroundColor = .systemBackground
    }
    
    @objc func dismissBtnTapped() {
        dismiss(animated: true)
    }
    
    static func showAlert(on view: UIViewController, title: String, content: String, buttonText: String) {
        let alert = GFAlertVC()
        
        alert.titleText = title
        alert.contentText = content
        alert.dissmissBtnText = buttonText
        
        alert.modalPresentationStyle = .overFullScreen
        
        view.present(alert, animated: true)
    }
}
