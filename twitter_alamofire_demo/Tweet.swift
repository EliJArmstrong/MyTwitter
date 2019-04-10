//
//  Tweet.swift
//  twitter_alamofire_demo
//
//  Created by Aristotle on 2018-10-05.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit



/// This is a tweet object to store tweet data.
class Tweet: NSObject {
    
    // MARK: Properties
    var id: Int64? // For favoriting, retweeting & replying
    var text: String? // Text content of tweet
    var favoriteCount: Int? // Update favorite count label
    var favorited: Bool? // Configure favorite button
    var retweetCount: Int? // Update favorite count label
    var retweeted: Bool? // Configure retweet button
    var user: User? // Author of the Tweet
    var createdAtString: String? // String representation of date posted
    var media_url: URL? // If there is media. It's url it will be stored here.
    
    // For Retweets
    var retweetedByUser: User?  // user who retweeted if tweet is retweet
    
    init(dictionary: [String : Any]) {
        super.init()
        var dictionary = dictionary
        
        // Is this a re-tweet?
        if let originalTweet = dictionary["retweeted_status"] as? [String: Any] {
            let userDictionary = dictionary["user"] as! [String: Any]
            self.retweetedByUser = User(dictionary: userDictionary)
            
            // Change tweet to original tweet
            dictionary = originalTweet
        }
        
        id = dictionary["id"] as? Int64
        text = dictionary["full_text"] as? String
        favoriteCount = dictionary["favorite_count"] as? Int
        favorited = dictionary["favorited"] as? Bool
        retweetCount = dictionary["retweet_count"] as? Int
        retweeted = dictionary["retweeted"] as? Bool
        
        let user = dictionary["user"] as! [String: Any]
        self.user = User(dictionary: user)
        
        
        let entities = dictionary["entities"] as! [String: Any]
        if let media = entities["media"] as? [[String: Any]]{
            let media1 = media[0]
            let media_url_https = media1["media_url_https"] as? String
            self.media_url = URL(string: media_url_https!)
        }

        
        
        
        
        // Format createdAt date string
        let createdAtOriginalString = dictionary["created_at"] as! String
        let formatter = DateFormatter()
        // Configure the input format to parse the date string
        formatter.dateFormat = "E MMM d HH:mm:ss Z y"
        // Convert String to Date
        let date = formatter.date(from: createdAtOriginalString)!
        // Configure output format
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        // Convert Date to String and set the createdAtString property
        createdAtString = formatter.string(from: date)

    }

    static func tweets(with array: [[String: Any]]) -> [Tweet] {
        return array.compactMap({ (dictionary) -> Tweet in
            Tweet(dictionary: dictionary)
        })
    }
    
    // Same as above but the compactMap (flat map the old name and is now deprecated) takes care of nils.
//    static func tweets(with array: [[String: Any]]) -> [Tweet] {
//        var tweets: [Tweet] = []
//        for tweetDictionary in array {
//            let tweet = Tweet(dictionary: tweetDictionary)
//            tweets.append(tweet)
//        }
//        return tweets
//    }

}
