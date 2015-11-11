//
//  AppDelegate.swift
//  GitHubClient
//
//  Created by Regular User on 11/9/15.
//  Copyright © 2015 Lynn Kuhlman. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

        
        var window: UIWindow?
        
        
        func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
            return true
        }
        
        func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
            
            
            GithubOAuth.shared.tokenRequestWithCallback(url, options: SaveOptions.UserDefaults) {
                (success) -> () in
                if success {
                    print("We have token.")
                    print(url)
                }
            }
            
            return true
        }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
        GithubOAuth.shared.exchangeCodeInURL(url)
        
        return true
    }
}



