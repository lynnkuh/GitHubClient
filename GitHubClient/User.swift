//
//  User.swift
//  GitHubClient
//
//  Created by Regular User on 11/11/15.
//  Copyright © 2015 Lynn Kuhlman. All rights reserved.
//

import Foundation

class User {
    
    let name: String
    let login: String
    let location: String?
    let blog: String?
    let createdAt: NSDate
    let followers: Int
    
    init(name: String, login: String, location: String?, blog: String?, createdAt: NSDate, followers: Int) {
        self.name = name
        self.login = login
        self.location = location
        self.blog = blog
        self.createdAt = createdAt
        self.followers = followers
    }
}