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
        } catch _ {  }
        
    }
    
        
    
    class func CreateRepository(name: String, description: String?)
    {
    
    do {
        
        let token = try GithubOAuth.shared.accessToken()
        guard let url = NSURL(string: "https://api.github.com/user/repos?access_token=\(token)") else { return }
        
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        
        let newPost = ["name": name, "description": description!]
        let body = try! NSJSONSerialization.dataWithJSONObject(newPost, options: NSJSONWritingOptions.PrettyPrinted)
        
        request.setValue("application/json", forHTTPHeaderField:"Accept")
        request.HTTPBody = body
        
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            print("did complete making request")
            if let error = error {
                print(error)
            }
            
            if let data = data {
                let json = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
                print(json)
            }
            
        }).resume()
    } catch _ {}
}

}



