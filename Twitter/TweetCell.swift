//
//  TweetCell.swift
//  Twitter
//
//  Created by Keith Tan on 1/30/19.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var retweetBtn: UIButton!
    
    var favorited:Bool = false
    var tweetID:Int = -1
    
    func setFavorite(_ isFavorited:Bool){
        favorited = isFavorited
        if (favorited){
            favoriteBtn.setImage(UIImage(named:"favor-icon-red"), for: UIControl.State.normal)
        }
        else{
            favoriteBtn.setImage(UIImage(named:"favor-icon"), for: UIControl.State.normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func favoriteTweet(_ sender: Any) {
        let oppositeState = !favorited
        if (oppositeState == true){
            TwitterAPICaller.client?.favoriteTweet(tweetID: self.tweetID, success: {
                self.setFavorite(true)
            }, failure: { (Error) in
                print("Unable to favorite")
            })
        }
        else{
            TwitterAPICaller.client?.unfavoriteTweet(tweetID: self.tweetID, success: {
                self.setFavorite(false)
            }, failure: { (Error) in
                print("Unable to unfavorite")
            })
        }
    }
    
    @IBAction func retweet(_ sender: Any) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
