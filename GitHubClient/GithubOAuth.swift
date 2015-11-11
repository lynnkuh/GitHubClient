//
//  GithubOAuth.swift
//  GitHubClient
//
//  Created by Regular User on 11/9/15.
//  Copyright © 2015 Lynn Kuhlman. All rights reserved.
//

import UIKit


let kAccessTokenKey = "kAccessTokenKey"
let kOAuthBaseURLString = "https://github.com/login/oauth/"
let kAccessTokenRegexPattern = "access_token=([^&]+)"

typealias GithubOAuthCompletion = (success: Bool) -> ()


enum GithubOAuthError: ErrorType {
    case MissingAccessToken(String)
    case ExtractingTokenFromString(String)
    case ExtractingTermporaryCode(String)
    case ResponseFromGithub(String)
}

enum SaveOptions: Int {
    case UserDefaults
}


let githubClientId = "5eff589a5d6f824a9d45"
let githubClientSecret = "f66a1ad5418c960dac11d332344e6c576a6d0213"

class GithubOAuth {
    
    /*
    Setup your Github client id and your client secret first.
    */
    
    
    
    private var token: NSString?
    
    static let shared = GithubOAuth()
    
    var toKen: NSString? {
        
        get {
            
            return KeychainService.loadFromKeychain()
        }
    
        set {
            if let newValue = newValue {
            
                KeychainService.save(newValue)
            }
            
        }
    }

    func oauthRequestWith(parameters: [String : String]) {
        var parametersString = String()
        for parameter in parameters.values {
            parametersString = parametersString.stringByAppendingString(parameter)
        }
        
        // URL constructor.
        if let requestURL = NSURL(string: "\(kOAuthBaseURLString)authorize?client_id=\(githubClientId)&scope=\(parametersString)") {
            UIApplication.sharedApplication().openURL(requestURL)
        }
    }
    
    func tokenRequestWithCallback(url: NSURL, options: SaveOptions, completion: GithubOAuthCompletion) {
        
        do {
            let temporaryCode = try self.temporaryCodeFromCallback(url)
            let requestString = "\(kOAuthBaseURLString)access_token?client_id=\(githubClientId)&client_secret=\(githubClientSecret)&code=\(temporaryCode)"
            
            if let requestURL = NSURL(string: requestString) {
                
                let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
                let session = NSURLSession(configuration: sessionConfiguration)
                session.dataTaskWithURL(requestURL, completionHandler: { (data, response, error) -> Void in
                    
                    if let _ = error {
                        completion(success: false); return
                    }
                    
                    if let data = data {
                        if let tokenString = self.stringWith(data) {
                            
                            do {
                                let token = try self.accessTokenFromString(tokenString)!
                                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                    completion(success: self.saveAccessTokenToUserDefaults(token))
                                })
                                
                            } catch _ {
                                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                    completion(success: false)
                                })
                            }
                            
                        }
                    }
                }).resume()
            }
            
        } catch _ {
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completion(success: false)
            })
        }
    }
    
    func accessToken() throws -> String {
        
        guard let accessToken = NSUserDefaults.standardUserDefaults().stringForKey(kAccessTokenKey) else {
            throw GithubOAuthError.MissingAccessToken("You don't have access token saved.")
        }
        
        return accessToken
        
    }
    
    // MARK: Helper Functions
    
    func temporaryCodeFromCallback(url: NSURL) throws -> String {
        
        guard let temporaryCode = url.absoluteString.componentsSeparatedByString("=").last else {
            throw GithubOAuthError.ExtractingTermporaryCode("Error ExtractingTermporaryCode. See: temporaryCodeFromCallback:")
        }
        
        return temporaryCode
    }
    
    func accessTokenFromString(string: String) throws -> String? {
        
        do {
            let regex = try NSRegularExpression(pattern: kAccessTokenRegexPattern, options: NSRegularExpressionOptions.CaseInsensitive)
            let matches = regex.matchesInString(string, options: NSMatchingOptions.Anchored, range: NSMakeRange(0, string.characters.count))
            if matches.count > 0 {
                for (_, value) in matches.enumerate() {
                    let matchRange = value.rangeAtIndex(1)
                    return (string as NSString).substringWithRange(matchRange)
                }
            }
        } catch _ {
            throw GithubOAuthError.ExtractingTokenFromString("Could not extract token from string.")
        }
        
        return nil
    }
    
    func saveAccessTokenToUserDefaults(accessToken: String) -> Bool {
        NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: kAccessTokenKey)
        return NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func stringWith(data: NSData) -> String? {
        let byteBuffer: UnsafeBufferPointer<UInt8> = UnsafeBufferPointer<UInt8>(start: UnsafeMutablePointer<UInt8>(data.bytes), count: data.length)
        return String(bytes: byteBuffer, encoding: NSASCIIStringEncoding)
    }
    
  
    
    func exchangeCodeInURL(codeURL: NSURL) {

    if let code = codeURL.query {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://github.com/login/oauth/access_token?\(code)&client_id=\(githubClientId)&client_secret=\(githubClientSecret)")!)
        
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if let _ = response as? NSHTTPURLResponse {
                
                if let data = data {
                    do {
                        if let rootObject = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String : AnyObject] {
                            
                            print(rootObject["access_token"])
                            print(rootObject)
                            
                            if let user = rootObject["access_token"]as? String {
                                self.token =  user
                                print("My token is \(user)")
                                
                            }
                        }
                    } catch _ {}
                }
            }
        }).resume()
    }
    
  }
    
}