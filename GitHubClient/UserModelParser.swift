//
//  UserModelParser.swift
//  GitHubClient
//
//  Created by Regular User on 11/12/15.
//  Copyright © 2015 Lynn Kuhlman. All rights reserved.
//

import Foundation
import CoreData

class UserModelParser {


    class func parseUser(completion: (success: Bool, json: [[String: AnyObject]]?) -> ()) {
        
        var owners = [Owner]()
        
        // This is the official URL, use it. This will work.
        // "https://api.github.com/user?access_token=\(token)"
        do {
            
            let token = try GithubOAuth.shared.accessToken()
            guard let url = NSURL(string: "https://api.github.com/user?access_token=\(token)")
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
                        let userObjects = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
    
                       
                        guard let name = userObjects["name"] as? String else {return }
                           guard let login = userObjects["login"] as? String else {return }
                           guard let location = userObjects["location"] as? String else {return }
                          guard  let blog = userObjects["blog"] as? String else {return }
                          guard  let createdAt = userObjects["createdAt"] as? String else {return }
                           guard let followers = userObjects["followers"] as? String else {return }
                        
//                           let date = NSDate.dateFromString(createdAt)
//                        User(name: name, login: login, location: location, blog: blog, createdAt: date, followers: followers)
                        
                        

                    } catch _ {
                        return completion(success: false, json: nil)
        }
                }
            }).resume()
        } catch _ {
            return completion(success: false, json: nil)        }
    }
}