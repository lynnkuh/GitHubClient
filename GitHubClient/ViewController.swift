//
//  ViewController.swift
//  GitHubClient
//
//  Created by Regular User on 11/9/15.
//  Copyright © 2015 Lynn Kuhlman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var queryStringForRepository: UITextField!

    @IBAction func RequestToken(sender: UIButton) {
        GithubOAuth.shared.oauthRequestWith(["scope" : "email,user"])
    }
    
    
    @IBAction func PrintToken(sender: UIButton) {
        
        do {
            let token = try GithubOAuth.shared.accessToken()
            
            print(token)
            
            let queryTextString = queryStringForRepository.text
            
            GitHubService.searchWithTerm(queryTextString!, completion: { (success, json) -> () in
                print("called the completion handler")
            })
            
            
            
        } catch let error {
            
            print(error)
            
        }    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
            
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

