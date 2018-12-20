//
//  ProfileVC.swift
//  twitter_alamofire_demo
//
//  Created by Eli Armstrong on 12/20/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfileVC: UIViewController {

    var user = User.current
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var realNameLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var tweetsCountLbl: UILabel!
    @IBOutlet weak var followingCountLbl: UILabel!
    @IBOutlet weak var followersCountLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let profileImgUrl = user?.userImageUrl{
            userImage.af_setImage(withURL: profileImgUrl)
        }
        
        if let backgroundImgUrl = user?.userBackGroundUrl{
            backgroundImg.af_setImage(withURL: backgroundImgUrl)
        }
        
        realNameLbl.text = user?.name
        userNameLbl.text = "@" + user!.screenName!
        tweetsCountLbl.text = "\(user!.statusCount!)"
        followersCountLbl.text = "\(user!.followercount!)"
        followingCountLbl.text = "\(user!.friendcount!)"
        
        // Do any additional setup after loading the view.
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
