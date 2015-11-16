//
//  HomeViewController.swift
//  GitHubClient
//
//  Created by Regular User on 11/11/15.
//  Copyright © 2015 Lynn Kuhlman. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    
    var repositories = [Repository]() {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.update()
    }
    
    func setupTableView() {
    self.tableView.delegate = self
    self.tableView.dataSource = self
    
    //       GitHubService.CreateRepository("Test", description: "Test repository")
    
    }
    func update() {
        
        do {
            let token = try GithubOAuth.shared.accessToken()
            
            let url = NSURL(string: "https://api.github.com/user/repos?access_token=\(token)")!
            
            let request = NSMutableURLRequest(URL: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
                
                if let error = error {
                    print(error)
                }
                
                if let data = data {
                    if let arraysOfRepoDictionaries = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [[String : AnyObject]] {
                        
                        var repositories = [Repository]()
                        
                        for eachRepository in arraysOfRepoDictionaries {
                            
                            let name = eachRepository["name"] as? String
                            let id = eachRepository["id"] as? Int
                            
                            if let name = name, id = id {
                                let repo = Repository(name: name, id: id)
                                repositories.append(repo)
                            }
                        }
                        
                        // This is because NSURLSession comes back on a background q.
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.repositories = repositories
                        })
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let repository = self.repositories[indexPath.row]
        
        cell.textLabel?.text = repository.name
        
        return cell
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
