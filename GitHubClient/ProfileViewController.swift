//
//  ProfileViewController.swift
//  GitHubClient
//
//  Created by Regular User on 11/16/15.
//  Copyright © 2015 Lynn Kuhlman. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController  {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var profileName: UITextField!
    
    let customTransition = CustomModalTransition(duration: 6.0)
    
    class func identifier() -> String {
        return "ProfileViewController"
    }
    
    var chosenUser: User? {
        didSet {
            print("Profile view controller received the user: \(chosenUser?.name)")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        
//        profileName.text = chosenUser?.name
        
//        didSelectImageProfileNameFromProfile(profileName.text!, profileImageUrl: profileUrl)
        self.getImage()
        self.getName()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        AnimateImage.expandImage(imageView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        AnimateImage.animateImageRotatingZoomIn(imageView)
    }

/*
    func didSelectImageProfileNameFromProfile( profileName: String, profileImageUrl:String)
    {
        self.profileName.text = profileName
        getImage()

    }
*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getImage () {
       
        guard let profileURL = chosenUser?.profileImageUrl else { return }
        guard let url = NSURL(string: (profileURL)) else { return }
        
        let downloadQueue = dispatch_queue_create("downloadQueue", nil)
        dispatch_async(downloadQueue, { () -> Void in
            let imageData = NSData(contentsOfURL: url)!
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                guard let image = UIImage(data: imageData) else { return }
                self.imageView.image = image
            })
        })
        
    }
    func getName() {
        self.profileName.text = chosenUser?.name
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.customTransition
    }

}
