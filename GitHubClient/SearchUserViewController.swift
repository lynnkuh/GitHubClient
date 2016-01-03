//
//  SearchUserViewController.swift
//  GoGoGithub
//
//  Created by Michael Babiy on 11/13/15.
//  Copyright © 2015 Michael Babiy. All rights reserved.
//

import UIKit

/*protocol PassProfileImageProfileNameFromSearchUserDelegate{
    func didSelectImageProfileNameFromProfile( profileName: String, profileImageUrl:String)->()

}
*/

class SearchUserViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UIViewControllerTransitioningDelegate {
  
   
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let customTransition = CustomModalTransition(duration: 6.0)
    
//    var delegate: PassProfileImageProfileNameFromSearchUserDelegate?
    
    var users = [User]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    class func identifier() -> String {
        return "SearchUserViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.collectionViewLayout = CustomFlowLayout(columns: 2)
        
 //       if let profileViewController = self.delegate as? ProfileViewController {
 //           profileViewController.delegate = self
            
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func update(searchTerm: String) {
        do {
            let token = try GithubOAuth.shared.accessToken()
            
            guard let url = NSURL(string: "https://api.github.com/search/users?access_token=\(token)&q=\(searchTerm)") else { return }
            
            let request = NSMutableURLRequest(URL: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
                
                if let error = error {
                    print(error)
                }
                
                if let data = data {
                    
                   if let json = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [String : AnyObject] {
                        
                        if let items = json["items"] as? [[String : AnyObject]] {
                            
                            // login
                            // avatar_url
                            
                            var users = [User]()
                            
                            for item in items {
                                
                                let name = item["login"] as? String
                                let profileImageUrl = item["avatar_url"] as? String
                                
                                if let name = name, profileImageUrl = profileImageUrl {
                                    
                                    users.append(User(name: name, profileImageUrl: profileImageUrl))
                                    
                                }
                                
                            }
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                self.users = users
                            })
                            
                        }
                        
                    }
                    
                }
                
                }.resume()
        } catch { return }
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("userCell", forIndexPath: indexPath) as! UserCollectionViewCell
        let user = self.users[indexPath.row]
        cell.user = user
//        let profileImageUrl = cell.user.profileImageUrl;
//        let profileNameSelected = cell.user.name;
        
//            self.delegate?.didSelectImageProfileNameFromProfile(profileNameSelected, profileImageUrl: profileImageUrl)
        
        return cell
    }
    
    // MARK: UISearchBarDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if let searchTerm = searchBar.text {
            if String.validateInput(searchTerm) {
                self.update(searchTerm)            }
        }
    else {return}
        
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        self.searchBar.resignFirstResponder()
        return true
    }
    // MARK: prepareForSegue

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetailView" {
            if let cell = sender as? UICollectionViewCell, indexPath = collectionView.indexPathForCell(cell) {
                guard let profileViewController = segue.destinationViewController as? ProfileViewController else {return}
                profileViewController.transitioningDelegate = self
                
                let user = users[indexPath.item]
                print(user.profileImageUrl)
                
                profileViewController.chosenUser = user
            }
        }
    }

   
 
    // MARK: Transition
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.customTransition
    }
}