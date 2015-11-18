//
//  ProfileViewController.swift
//  GitHubClient
//
//  Created by Regular User on 11/16/15.
//  Copyright © 2015 Lynn Kuhlman. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var profileName: UITextField!
    
    var chosenUser: User? {
        didSet {
            print("Profile view controller received the user: \(chosenUser?.name)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getImage()
        profileName.text = chosenUser?.name
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getImage () {
        guard let string = chosenUser?.profileImageUrl  else {return}
        print(string)
        guard let url = NSURL(string: (string)) else { return }
        
        let downloadQueue = dispatch_queue_create("downloadQueue", nil)
        dispatch_async(downloadQueue, { () -> Void in
            let imageData = NSData(contentsOfURL: url)!
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                guard let image = UIImage(data: imageData) else { return }
                self.imageView.image = image
            })
        })
        
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
