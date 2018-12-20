//
//  TweetDetail.swift
//  twitter_alamofire_demo
//
//  Created by Eli Armstrong on 12/19/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

protocol TweetDetailDelegate : class {
    func update(tweet : Tweet, row: Int)
}

class TweetDetailVC: UIViewController {

    
    var tweet: Tweet!
    
    weak var delegate: TweetDetailDelegate?
    
    var row: Int?
    
    @IBOutlet weak var replyBtn: UIButton!
    
    @IBOutlet weak var favBtn: UIButton!
    
    @IBOutlet weak var retweetBtn: UIButton!
    
    @IBOutlet weak var userImg: UIImageView!
    
    @IBOutlet weak var realName: UILabel!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var tweetMessage: UILabel!
    
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var favLbl: UILabel!
    
    @IBOutlet weak var retweetNumber: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realName.text = tweet.user?.name
        username.text = "@\(tweet.user?.screenName ?? "")"
        tweetMessage.text = tweet.text
        if let url = tweet.user?.userImageUrl{
            userImg.af_setImage(withURL: url)
        }
        dateLbl.text = "\(tweet.createdAtString ?? "")"
        refreshData()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func replyBtnPressed(_ sender: Any) {
        
    }
    
    
    @IBAction func retweetBtnPressed(_ sender: Any) {
        (tweet.retweeted!) ? unretweet() : retweet()
    }
    
    
    @IBAction func favBtnPressed(_ sender: Any) {
        (tweet.favorited!) ? unfavorited() : favorited()
    }
    
    func favorited(){
        // TODO: Update the local tweet model
        tweet.favorited = true
        tweet.favoriteCount! += 1
        // TODO: Update cell UI
        refreshData()
        // TODO: Send a POST request to the POST favorites/create endpoint
        APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
            if let  error = error {
                print("Error favoriting tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                print("Successfully favorited the following Tweet: \n\(tweet.text!)")
            }
        }
    }
    
    func unfavorited(){
        // TODO: Update the local tweet model
        tweet.favorited = false
        tweet.favoriteCount! -= 1
        // TODO: Update cell UI
        refreshData()
        // TODO: Send a POST request to the POST favorites/create endpoint
        APIManager.shared.unfavorite(tweet) { (tweet: Tweet?, error: Error?) in
            if let  error = error {
                print("Error unfavoriting tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                print("Successfully unfavorited the following Tweet: \n\(tweet.text!)")
            }
        }
    }
    
    func unretweet(){
        tweet.retweeted = false
        tweet.retweetCount! -= 1
        refreshData()
        APIManager.shared.unretweet(tweet) { (tweet, error) in
            if let  error = error {
                print("Error unretweet tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                print("Successfully unretweet the following Tweet: \n\(tweet.text!)")
            }
        }
    }
    
    func retweet(){
        tweet.retweeted = true
        tweet.retweetCount! += 1
        refreshData()
        APIManager.shared.retweet(tweet) { (tweet, error) in
            if let  error = error {
                print("Error retweet tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                print("Successfully retweet the following Tweet: \n\(tweet.text!)")
            }
        }
    }
    
    
    private func refreshData(){
        (self.tweet.favorited!) ?
            favBtn.setImage(UIImage(named: "favor-icon-red"), for: .normal) : favBtn.setImage(UIImage(named: "favor-icon"), for: .normal)
        
        (self.tweet.retweeted!) ?
            retweetBtn.setImage(UIImage(named: "retweet-icon-green"), for: .normal) : retweetBtn.setImage(UIImage(named: "retweet-icon"), for: .normal)
        
        favLbl.text = "\(tweet.favoriteCount ?? 0)"
        retweetNumber.text = "\(tweet.retweetCount ?? 0)"
        
        if(delegate != nil){
            self.delegate!.update(tweet: tweet, row: row!)
        }
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
