//
//  ComposeViewController.swift
//  twitter_alamofire_demo
//
//  Created by Eli Armstrong on 12/20/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import RSKPlaceholderTextView

protocol ComposeViewControllerDelegate : class {
    func did(post : Tweet)
}

class ComposeViewController: UIViewController, UITextViewDelegate{

    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var textView: RSKPlaceholderTextView!
    
    weak var delegate: ComposeViewControllerDelegate?
    
    @IBOutlet weak var postBtn: UIButton!
    
    // Set the max character limit
    let characterLimit = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        countLbl.text = "\(newText.count)/140"
        return newText.count < characterLimit
    }

    @IBAction func didTapPost(_ sender: Any) {
        APIManager.shared.composeTweet(with: textView.text) { (tweet, error) in
            if let error = error {
                print("Error composing Tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                self.delegate?.did(post: tweet)
                print("Compose Tweet Success!")
            }
            self.textView.resignFirstResponder()
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        textView.resignFirstResponder()
        dismiss(animated: false, completion: nil)
    }
}
