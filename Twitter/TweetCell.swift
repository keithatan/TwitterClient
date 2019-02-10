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
    var retweeted:Bool = false
    
    func setFavorite(_ isFavorited:Bool){
        favorited = isFavorited
        if (favorited){
            favoriteBtn.setImage(UIImage(named:"favor-icon-red"), for: UIControl.State.normal)
        }
        else{
            favoriteBtn.setImage(UIImage(named:"favor-icon"), for: UIControl.State.normal)
        }
    }
    
    func setRetweeted(_ isRetweeted: Bool){
        retweeted = isRetweeted
        if (retweeted){
            retweetBtn.setImage(UIImage(named:"retweet-icon-green"), for: UIControl.State.normal)
            retweetBtn.isEnabled = false
        }
        else{
            retweetBtn.setImage(UIImage(named:"retweet-icon"), for: UIControl.State.normal)
            retweetBtn.isEnabled = true
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
        TwitterAPICaller.client?.reweet(tweetID: self.tweetID, success: {
            self.setRetweeted(true)
        }, failure: { (Error) in
            print("Error Retweeting")
        })
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
