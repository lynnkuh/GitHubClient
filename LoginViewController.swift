//
//  LoginViewController.swift
//  GitHubClient
//
//  Created by Regular User on 11/11/15.
//  Copyright © 2015 Lynn Kuhlman. All rights reserved.
//

import UIKit

typealias LoginViewControllerCompletionHandler = () -> ()

class LoginViewController: UIViewController {
    
    // The login handler is used to dismiss the controller when the login handler returns
   
    var loginCompletionHandler: LoginViewControllerCompletionHandler?
    
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    //When the login button is selected start the gray animation object
    //Sleep for 1000 milliseconds until the Login handler is completed
    // Then resume on the main thread
    
    @IBAction func loginButtonSelected(sender: AnyObject) {
        
        GithubOAuth.shared.oauthRequestWith(["scope" : "email,user,repo"])
    }
    
    class func identifier() -> String {
        return "LoginViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func processLoginRequest() {
        if let loginCompletionHandler = self.loginCompletionHandler {
            loginCompletionHandler()
        }
    }
    
    
    
}
