//
//  SearchRepoViewController.swift
//  GitHubClient
//
//  Created by Regular User on 11/15/15.
//  Copyright © 2015 Lynn Kuhlman. All rights reserved.
//

import UIKit
import SafariServices

class SearchRepoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SFSafariViewControllerDelegate {
    
  
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var searchBar: UISearchBar!

    var repositories = [Repository]() {
        didSet {
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
            
        }
    }
    
    class func identifier() -> String {
        return "SearchRepoViewController"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update(searchTerm: String) {
        
        do {
            let token = try GithubOAuth.shared.accessToken()
            
            guard let url = NSURL(string: "https://api.github.com/search/repositories?access_token=\(token)&q=\(searchTerm)") else { return }
            
            let request = NSMutableURLRequest(URL: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
                
                if let error = error {
                    print(error)
                }
                
                if let data = data {
                    if let dictionaryOfRepositories = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [String : AnyObject] {
                        
                        if let items = dictionaryOfRepositories["items"] as? [[String : AnyObject]] {
                            
                            
                            var repositories = [Repository]()
                            
                            for eachRepository in items {
                                
                                let name = eachRepository["name"] as? String
                                let id = eachRepository["id"] as? Int
                                let url = eachRepository["url"] as? String
                                
                                
                                if let name = name, id = id, url = url {
                                    let repo = Repository(name: name, id: id, url: url)
                                    repositories.append(repo)
                                }
                            }
                            
                            // This is because NSURLSession comes back on a background q.
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                self.repositories = repositories
                            })
                        }
                    }
                }
                }.resume()
        } catch {}
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("repoCell", forIndexPath: indexPath)
        let repository = self.repositories[indexPath.row]
        cell.textLabel?.text = repository.name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedRepositoryUrl = repositories[indexPath.row].url
        print("The selected repo url for safari is: \(selectedRepositoryUrl)")
        
        if #available(iOS 9.0, *) {
            let safariViewController = SFSafariViewController(URL: NSURL(string: selectedRepositoryUrl)!, entersReaderIfAvailable: true)
            safariViewController.delegate = self
            self.presentViewController(safariViewController, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
            self.performSegueWithIdentifier("GitHubWebViewController", sender: self)
        }
        
    }
    
    // MARK: UISearchBarDelegate
    
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        self.searchBar.resignFirstResponder()
        return true
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("have clicked search")
        if let searchTerm = searchBar.text {
            if String.validateInput(searchTerm) {
                self.update(searchTerm)
            }
        }
        else {return}
        
    }
    
    @available(iOS 9.0, *)
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
