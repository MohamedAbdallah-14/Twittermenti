//
//  ViewController.swift
//  Twittermenti
//
//  Created by MohamedAbdallah on 7/17/19.
//  Copyright © 2019 MohamedAbdallah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var tweetSentimentLabel: UILabel!
    @IBOutlet weak var tweetCounrLabel: UILabel!
    @IBOutlet weak var tweetProgressView: UIProgressView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func predictPressed(_ sender: UIButton) {
    }
    
    @IBAction func nextTweet(_ sender: UIButton) {
    }
    
    @IBAction func previousTweet(_ sender: UIButton) {
    }
    
}

