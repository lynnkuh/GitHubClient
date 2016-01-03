//
//  AnimateImage.swift
//  GitHubClient
//
//  Created by Regular User on 1/2/16.
//  Copyright © 2016 Lynn Kuhlman. All rights reserved.
//

import UIKit

class AnimateImage {
    class func expandImage(imageView: UIImageView) {
        imageView.clipsToBounds = true
        imageView.transform = CGAffineTransformScale(imageView.transform, 4.2, 4.2)
    }

    class func animateImageRotatingZoomIn(imageView: UIImageView) {
        //             Example of rotating view 45 degrees clockwise.
        for _ in 0...7 {
            UIView.animateWithDuration(1.0) { () -> Void in
                imageView.transform = CGAffineTransformRotate(imageView.transform, CGFloat(M_PI * 45 / 180.0))
                imageView.transform = CGAffineTransformScale(imageView.transform, 0.82, 0.82)
            }
        }
    }

}