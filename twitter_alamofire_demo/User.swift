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
    
    private static var _current: User?
    
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
    
    var name: String?
    var screenName: String?
    var userImageUrl: URL?
    var userBackGroundUrl: URL?
    var statusCount : Int?
    var friendcount: Int?
    var followercount : Int?
    
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
