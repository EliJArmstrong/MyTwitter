//
//  User.swift
//  twitter_alamofire_demo
//
//  Created by Aristotle on 2018-10-05.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var dictionary: [String: Any]?
    
    private static var _current: User? // the user user that is logged in.
    
    var name: String? //  The name of the user
    var screenName: String? // This is the "@" name for the user
    var userImageUrl: URL? // The image url for the user
    var userBackGroundUrl: URL? // Some users have a background Image
    var statusCount : Int? // This holds the the amount of tweet the users has posted
    var friendcount: Int? // This is the count of how acconts the user as following
    var followercount : Int? // This is the count of how meny account are following the user.
    
    
    /// If set the users data is stroed via user defaults.
    /// When get is called and _current is nil the user data is stored and the _current data is returned.
    /// else the users data is returned.
    static var current: User? {
        get {
            if _current == nil {
                let defaults = UserDefaults.standard
                if let userData = defaults.data(forKey: "currentUserData") {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String: Any]
                    _current = User(dictionary: dictionary)
                }
            }
            return _current
        }
        set (user) {
            _current = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
        }
    }
    
    
    
    /// Converts a [String: Any] dictionary to a tweet.
    init(dictionary: [String : Any]) {
        super.init()
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        let imageUrl = dictionary["profile_image_url_https"] as? String
        if let backUrl = dictionary["profile_banner_url"] as? String{
            userBackGroundUrl = URL(string: backUrl)
        }
        userImageUrl = URL(string: imageUrl!)
        friendcount = dictionary["friends_count"] as? Int
        followercount = dictionary["followers_count"] as? Int
        statusCount = dictionary["statuses_count"] as? Int
    }

    
}
