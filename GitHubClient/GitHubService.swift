//
//  GitHubService.swift
//  GitHubClient
//
//  Created by Regular User on 11/10/15.
//  Copyright © 2015 Lynn Kuhlman. All rights reserved.
//

import Foundation

class GitHubService {
    
    class func searchWithTerm(term: String, completion: (success: Bool, json: [AnyObject]) -> ()) {
        
        // This is the official URL, use it. This will work.
        // https://api.github.com/search/repositories?q=term
        
        do {
            guard let url = NSURL(string: "https://api.github.com/search/repositories?q=\(term)") else {
                return
            }
            
            let request = NSMutableURLRequest(URL: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                
                print("did complete making request")
                if let error = error {
                    print(error)
                }
                
                if let data = data {
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
                        print(json)
                    } catch _ {}
                }
            }).resume()
        } catch _ {}
        
    }
    
        
    
 class func GetUser(completion: (success: Bool, json: [AnyObject]) -> ()) {
    
    
    do {
        
        let token = try GithubOAuth.shared.accessToken()
        guard let url = NSURL(string: "https://api.github.com/user/repos?access_token=\(token)")
            
            else {
            
            print("Error: cannot create URL")
            return
        }
        
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let newPost: NSDictionary = ["name": "TestRepository"]
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            print("did complete making request")
            if let error = error {
                print(error)
            }
            
             if let data = data {
                do {
                    let json = try NSJSONSerialization.dataWithJSONObject(newPost, options: NSJSONWritingOptions.PrettyPrinted)
                    print(json)
                } catch _ {
                    print("Error cannot create repository from post")
                }
            }
        }).resume()
    } catch _ {}
}

}



