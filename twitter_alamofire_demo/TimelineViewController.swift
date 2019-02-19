//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Aristotle on 2018-08-11.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, ComposeViewControllerDelegate/*, TweetDetailDelegate*/{

    @IBOutlet weak var tableView: UITableView!
    
    
    var tweets = [Tweet]()
    let refreshControl = UIRefreshControl()
    var isMoreDataLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControl.Event.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        fetchTweets()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        APIManager.shared.logout()
    }
    
    func fetchTweets() {
        APIManager.shared.getHomeTimeLine { (tweets, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                self.tweets = tweets!
                self.tableView.reloadData()
            }
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchTweets()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                
                APIManager.shared.getMoreTweets(sinceId: tweets[tweets.count - 1].id!) { (tweets, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    else {
                        self.tweets += tweets!
                        self.tableView.reloadData()
                        self.isMoreDataLoading = false
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TweetDetailVC{
            let cell = sender as! UITableViewCell
            if let index = tableView.indexPath(for: cell){
                vc.tweet = tweets[index.row]
                //vc.delegate = self
                vc.row = index.row
            }
        } else if let navVC = segue.destination as? UINavigationController{
            let vc = navVC.viewControllers.first as! ComposeViewController
            vc.delegate = self
        }
    }
    
    func did(post: Tweet) {
        tweets.insert(post, at: 0)
        tableView.reloadData()
    }
    
    
//    func update(tweet: Tweet, row: Int) {
//        //tweets[row] = tweet
//        tableView.reloadData()
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
