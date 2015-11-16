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
    
        var loginViewController: LoginViewController?
    
        
        func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
            self.checkLoginAuthorizationStatus()
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


// If the token doesn't come back from GitHub present the login screen

func checkLoginAuthorizationStatus() {
    
    do {
        
        let token = try GithubOAuth.shared.accessToken()
        print(token)
        
    } catch _ { self.presentLoginViewController() }
}
    
    func presentLoginViewController() {
        
        if let tabbarController = self.window?.rootViewController as? UITabBarController, homeViewController = tabbarController.viewControllers?.first as? HomeViewController, storyboard = tabbarController.storyboard {
            
            
            if let loginViewController = storyboard.instantiateViewControllerWithIdentifier(LoginViewController.identifier()) as? LoginViewController {
                
                homeViewController.addChildViewController(loginViewController)
                homeViewController.view.addSubview(loginViewController.view)
                loginViewController.didMoveToParentViewController(homeViewController)
                
                tabbarController.tabBar.hidden = true
                
                loginViewController.loginCompletionHandler = ({
                    UIView.animateWithDuration(0.6, delay: 1.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                        loginViewController.view.alpha = 0.0
                        }, completion: { (finished) -> Void in
                            loginViewController.view.removeFromSuperview()
                            loginViewController.removeFromParentViewController()
                            
                            tabbarController.tabBar.hidden = false
                            
                            // Make the call for repositories.
                            homeViewController.update()
                    })
                })
                
                self.loginViewController = loginViewController
                
            }
            
            
        }
        
    }

}


