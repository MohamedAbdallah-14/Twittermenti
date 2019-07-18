//
//  ViewController.swift
//  Twittermenti
//
//  Created by MohamedAbdallah on 7/17/19.
//  Copyright © 2019 MohamedAbdallah. All rights reserved.
//

import UIKit
import SwifteriOS

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var tweetSentimentLabel: UILabel!
    @IBOutlet weak var tweetCounrLabel: UILabel!
    @IBOutlet weak var tweetProgressView: UIProgressView!
    
    
    let sentimentClassifier = TweetSentimentClassifier()
    
    let swifter = Swifter(consumerKey: "3CkyrV0E4yUr8uE3Gu9xVUu4X", consumerSecret: "Q8RLoQMT5QQLeVd1KUSqqpVagCGJAQ0sizK3oXbJYGWdv6H57i")
    
    var tweetTimer: Timer!
    var tweets = [TweetSentimentClassifierInput]()
    var predictions = [TweetSentimentClassifierOutput]()
    var timerCount=0, finalCount=0, count=0

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func startTimer() {
        tweetTimer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true, block: { (timer) in
            if(self.timerCount<self.finalCount){
                self.tweetLabel.text = self.tweets[self.timerCount].text
                self.timerCount += 1
                self.tweetProgressView.progress = Float((self.timerCount + 1))/Float(self.finalCount)
                self.tweetCounrLabel.text = "\(self.timerCount)/\(self.finalCount)"
            }
            if self.timerCount == self.finalCount , self.timerCount > 0{
                self.displaySentiment()
                self.tweetTimer.invalidate()
            }
        })
    }

    func displaySentiment(){
        do {
            predictions = try sentimentClassifier.predictions(inputs: tweets)
            
            var sentimentsScore = 0
            
            for pred in predictions {
                let sentiment = pred.label
                if sentiment == "Pos" {
                    sentimentsScore += 1
                } else if sentiment == "Neg" {
                    sentimentsScore -= 1
                }
            }
            if sentimentsScore > 20 {
                self.sentimentLabel.text = "😍\n\(sentimentsScore)"
                //self.backgroundView.backgroundColor = UIColor(red: 0.15, green: 0.68, blue: 0.38, alpha: 1.0)
            }
            else if sentimentsScore > 10 {
                self.sentimentLabel.text = "😁\n\(sentimentsScore)"
                //self.backgroundView.backgroundColor = UIColor(red: 0.18, green: 0.80, blue: 0.44, alpha: 1.0)
            }
            else if sentimentsScore > 0 {
                self.sentimentLabel.text = "🙂\n\(sentimentsScore)"
                //self.backgroundView.backgroundColor = UIColor(red: 0.24, green: 0.92, blue: 0.60, alpha: 1.0)
            }
            else if sentimentsScore == 0 {
                self.sentimentLabel.text = "😐\n\(sentimentsScore)"
                //self.backgroundView.backgroundColor = UIColor(red: 0.74, green: 0.76, blue: 0.78, alpha: 1.0)
            }
            else if sentimentsScore > -10 {
                self.sentimentLabel.text = "😕\n\(sentimentsScore)"
                //self.backgroundView.backgroundColor = UIColor(red: 0.95, green: 0.61, blue: 0.07, alpha: 1.0)
            }
            else if sentimentsScore > -20 {
                self.sentimentLabel.text = "😡\n\(sentimentsScore)"
                //self.backgroundView.backgroundColor = UIColor(red: 0.91, green: 0.30, blue: 0.24, alpha: 1.0)
            }
            else {
                self.sentimentLabel.text = "🤮\n\(sentimentsScore)"
                //self.backgroundView.backgroundColor = UIColor(red: 0.75, green: 0.22, blue: 0.17, alpha: 1.0)
            }
        } catch {
            print("There was an error with making a predicition, \(error)")
        }
    }
    
    @IBAction func predictPressed(_ sender: UIButton) {
        if let searchText = textField.text {
            finalCount = 0
            count = 0
            startTimer()
            dismissKeyboard()
            tweetLabel.text = "Loading Tweets ...."
            swifter.searchTweet(
                using: searchText,
                lang: "en",
                count: 100,
                tweetMode: .extended,
                success: { (results, metadata) in
                    var tweetCount = 0
                    self.tweets.removeAll()
                    for i in 0..<100 {
                        if let tweet = results[i]["full_text"].string{
                            self.tweets.append(TweetSentimentClassifierInput(text: tweet))
                            tweetCount += 1
                        }
                    }
                    self.finalCount = tweetCount
                    self.count = self.finalCount
                    self.timerCount = 0
                },
                failure: { (error) in
                    print("There was an error with the Twitter API Request, \(error)")
                }
            )
        }
    }
    
    @IBAction func nextTweet(_ sender: UIButton) {
        if(count<finalCount-1){
            count += 1
            tweetLabel.text = tweets[count].text
            if predictions[count].label == "Pos" {
                tweetSentimentLabel.text = "😀"
            } else if predictions[count].label == "Neg" {
                tweetSentimentLabel.text = "☹️"
            } else if predictions[count].label == "Neutral" {
                tweetSentimentLabel.text = "😐"
            }
            tweetProgressView.progress = Float((count + 1))/Float(finalCount)
            tweetCounrLabel.text = "\(count+1)/\(finalCount)"
        }
    }
    
    @IBAction func previousTweet(_ sender: UIButton) {
        if(count>0){
            count -= 1
            tweetLabel.text = tweets[count].text
            if predictions[count].label == "Pos" {
                tweetSentimentLabel.text = "😀"
            } else if predictions[count].label == "Neg" {
                tweetSentimentLabel.text = "☹️"
            } else if predictions[count].label == "Neutral" {
                tweetSentimentLabel.text = "😐"
            }
            tweetProgressView.progress = Float((count + 1))/Float(finalCount)
            tweetCounrLabel.text = "\(count+1)/\(finalCount)"
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

