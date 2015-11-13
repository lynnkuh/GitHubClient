//
//  Repository.swift
//  GitHubClient
//
//  Created by Regular User on 11/11/15.
//  Copyright © 2015 Lynn Kuhlman. All rights reserved.
//

import Foundation

class Repository {
    
    let name: String
    let id: Int
    let owner: Owner?

    
    init(name: String, id: Int, owner: Owner?) {
        self.name = name
        self.id = id
        self.owner = owner
        
        
    }
}