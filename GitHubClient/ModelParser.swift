//
//  ModelParser.swift
//  GitHubClient
//
//  Created by Regular User on 11/12/15.
//  Copyright © 2015 Lynn Kuhlman. All rights reserved.
//

import Foundation

class ModelParser {


    class func parseOwner(completion: (success: Bool, json: [[String: AnyObject]]?) -> ()) {
        
        var owners = [Owner]()
        
        // This is the official URL, use it. This will work.
        // "https://api.github.com/user/repos?access_token=\(token)"
        do {
            
            let token = try GithubOAuth.shared.accessToken()
            guard let url = NSURL(string: "https://api.github.com/user/repos?access_token=\(token)")
                else { return completion(success: false, json: nil) }
            
            let request = NSMutableURLRequest(URL: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                
                print("did complete making request")
                if let error = error {
                    print(error)
                    return completion(success: false, json: nil)
                }
                
                
                
                
                if let data = data {
                    do {
                        if let arraysOfRepoDictionaries = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [[String : AnyObject]] {

                       
                        
                        for eachRepository in arraysOfRepoDictionaries {
                            
                            let login = eachRepository["login"] as? String
                            let avatarUrl = eachRepository["avatar_url"] as? String
                            let id = eachRepository["id"] as? Int
                            let url = eachRepository["url"] as? String
                            
                            
                            
                                let owner = Owner(login: login, avatarUrl: avatarUrl, id: id, url: url)
                                owners.append(owner)
                           
                        }
                            
                        }
                        
                        
                        

                    } catch _ {
                        return completion(success: false, json: nil)
        }
                }
            }).resume()
        } catch _ {
            return completion(success: false, json: nil)        }
    }
}