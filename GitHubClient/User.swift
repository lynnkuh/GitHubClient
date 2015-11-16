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
    let profileImageUrl: String

    
    init(name: String, profileImageUrl: String) {
        self.name = name
        self.profileImageUrl = profileImageUrl
    }
}