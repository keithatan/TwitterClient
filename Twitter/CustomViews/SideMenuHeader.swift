//
//  SideMenuHeader.swift
//  Twitter
//
//  Created by Keith Tan on 2/10/19.
//

import UIKit

class SideMenuCustomHeader: UIView {
    let nameLabel = UILabel()
    let usernameLabel = UILabel()
    let statsLabel = UILabel()
    let profileImageView = ProfileImageView()
    var userObject = NSDictionary()
    
    required init(test: String){
        print(test)
        
        super.init(frame: CGRect.zero)
        backgroundColor = .white
        TwitterAPICaller.client?.getCredentialsRequest(success: { (response) in
            self.userObject = response;
            self.setupComponentProps()
            self.setupStackView()
        }, failure: { (Error) in
            print("nope")
        })
        
    }
    
    /*
     override init(frame: CGRect) {
     super.init(frame: frame)
     backgroundColor = .white
     setupComponentProps()
     setupStackView()
     }*/
    
    fileprivate func setupComponentProps() {
        // custom components for our header
        nameLabel.text = userObject["name"] as? String
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        usernameLabel.text = "@\(userObject["screen_name"] as! String)"
        let followers = userObject["followers_count"] as! Int
        let friends = userObject["friends_count"] as! Int
        statsLabel.text = "\(friends) Following \(followers) Followers"
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = 50 / 2
        profileImageView.clipsToBounds = true
        let imageURL = URL(string: (userObject["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageURL!)
        if let imageData = data {
            profileImageView.image = UIImage(data: imageData)
        }
        setupStatsAttributedText()
    }
    
    fileprivate func setupStatsAttributedText() {
        statsLabel.font = UIFont.systemFont(ofSize: 14)
        let followers = userObject["followers_count"] as! Int
        let friends = userObject["friends_count"] as! Int
        let attributedText = NSMutableAttributedString(string: "\(friends) ", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .medium)])
        attributedText.append(NSAttributedString(string: "Following  ", attributes: [.foregroundColor: UIColor.black]))
        attributedText.append(NSAttributedString(string: "\(followers) ", attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .medium)]))
        attributedText.append(NSAttributedString(string: "Followers", attributes: [.foregroundColor: UIColor.black]))
        
        statsLabel.attributedText = attributedText
    }
    
    fileprivate func setupStackView() {
        // this is a spacing hack with UIView
        let rightSpacerView = UIView()
        let arrangedSubviews = [
            UIView(),
            UIStackView(arrangedSubviews: [profileImageView, rightSpacerView]),
            nameLabel,
            usernameLabel,
            SpacerView(space: 16),
            statsLabel
        ]
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.spacing = 4
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
