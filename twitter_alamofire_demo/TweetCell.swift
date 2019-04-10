//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Eli Armstrong on 12/11/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class TweetCell: UITableViewCell {

    // When this varible is set from a tweet object the data is set to the variables of this cell
    var tweet: Tweet!{
        didSet{
            mediaImage.isHidden = false
            realname.text = tweet.user?.name
            userName.text = "@\(tweet.user?.screenName ?? "")"
            tweetMessage.text = tweet.text
            if let url = tweet.user?.userImageUrl{
                userImage.af_setImage(withURL: url)
            }
            if let url_media = tweet.media_url{
                mediaImage.af_setImage(withURL: url_media)
            } else{
                mediaImage.isHidden = true
            }
            date.text = "• \(tweet.createdAtString ?? "")"
            refreshData()
        }
    }
    
    @IBOutlet weak var mediaImage: UIImageView! // UIImageView for media in a tweet
    @IBOutlet weak var userImage: UIImageView! // UIImageView to the users profile image
    @IBOutlet weak var realname: UILabel! // The "real name" of the user
    @IBOutlet weak var userName: UILabel! // The user name of the user
    @IBOutlet weak var date: UILabel! // To display the creation date of the tweet
    @IBOutlet weak var tweetMessage: UILabel! // The tweets message
    @IBOutlet weak var retweetBtn: UIButton! // The retweet button.
    @IBOutlet weak var favBtn: UIButton! // The favorte button.
    
    
    // Default function like main or viewdidload
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // This will keep the highlighing of a row from being seen.
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        self.selectedBackgroundView = backgroundView
    }
    
    // Will call a function based on the current state of favorite status.
    @IBAction func didTapFavorite(_ sender: Any) {
        (tweet.favorited!) ? unfavorited() : favorited()
    }
    
    // Will call a function based on the current state of retweet status.
    @IBAction func didTapRetweet(_ sender: Any){
        (tweet.retweeted!) ? unretweet() : retweet()
    }
    
    // Updates the count of the tweets (like) count + 1 in this case.
    // This will also send a the update to the twitter API.
    func favorited(){
        // Update the local tweet model
        tweet.favorited = true
        tweet.favoriteCount! += 1
        // Update cell UI
        refreshData()
        // Send a POST request to the POST favorites/create endpoint
        APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
            if let  error = error {
                print("Error favoriting tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                print("Successfully favorited the following Tweet: \n\(tweet.text ?? "empty tweet")")
            }
        }
    }
    
    
    /// Updates the count of the tweets (like) count - 1 in this case.
    /// This will also send a the update to the twitter API.
    func unfavorited(){
        // Update the local tweet model
        tweet.favorited = false
        tweet.favoriteCount! -= 1
        // Update cell UI
        refreshData()
        // Send a POST request to the POST favorites/create endpoint
        APIManager.shared.unfavorite(tweet) { (tweet: Tweet?, error: Error?) in
            if let  error = error {
                print("Error unfavoriting tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                print("Successfully unfavorited the following Tweet: \n\(tweet.text ?? "empty tweet")")
            }
        }
    }
    
    /// Updates the count of the retweet count - 1 in this case.
    /// This will also send a the update to the twitter API.
    func unretweet(){
        tweet.retweeted = false
        tweet.retweetCount! -= 1
        refreshData()
        APIManager.shared.unretweet(tweet) { (tweet, error) in
            if let  error = error {
                print("Error unretweet tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                print("Successfully unretweet the following Tweet: \n\(tweet.text ?? "empty tweet")")
            }
        }
    }
    
    // Updates the count of the retweet count + 1 in this case.
    // This will also send a the update to the twitter API.
    func retweet(){
        tweet.retweeted = true
        tweet.retweetCount! += 1
        refreshData()
        APIManager.shared.retweet(tweet) { (tweet, error) in
            if let  error = error {
                print("Error retweet tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                print("Successfully retweet the following Tweet: \n\(tweet.text ?? "empty tweet")")
            }
        }
    }
    
    // This fuction updates the UI based on the favorited and retweeted variables
    private func refreshData(){
        (self.tweet.favorited!) ?
        favBtn.setImage(UIImage(named: "favor-icon-red"), for: .normal) : favBtn.setImage(UIImage(named: "favor-icon"), for: .normal)
        
        (self.tweet.retweeted!) ?
        retweetBtn.setImage(UIImage(named: "retweet-icon-green"), for: .normal) : retweetBtn.setImage(UIImage(named: "retweet-icon"), for: .normal)
        
        retweetBtn.setTitle("\(tweet!.retweetCount!)", for: .normal)
        favBtn.setTitle("\(tweet!.favoriteCount!)", for: .normal)
        
    }

}
