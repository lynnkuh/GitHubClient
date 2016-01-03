//
//  GitHubWebViewViewController.swift
//  GitHubClient
//
//  Created by Regular User on 1/1/16.
//  Copyright © 2016 Lynn Kuhlman. All rights reserved.
//

import UIKit

typealias WebViewControllerCompletion = ()->()

class GitHubWebViewViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var gitHubWebView: UIWebView!
    
    var profileUrl: String?
    
    var completion: WebViewControllerCompletion?

    override func viewDidLoad() {
        self.gitHubWebView.delegate = self
        loadWebViewData()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func loadWebViewData(){
        guard let profileURL = self.profileUrl else {return}
        guard let nsurl = NSURL(string: profileURL) else {return}
        let request = NSURLRequest(URL: nsurl)
        gitHubWebView?.loadRequest(request)
        
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
