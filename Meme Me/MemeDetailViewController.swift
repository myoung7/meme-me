//
//  MemeDetailViewController.swift
//  Meme Me
//
//  Created by Matthew Young on 1/14/16.
//  Copyright © 2016 Matthew Young. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var memeDetailImageView: UIImageView!
    
    var currentMeme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "editMeme")
        memeDetailImageView.image = currentMeme.memedImage
        navigationController?.title = "Meme Detail"
    }

    override func viewWillDisappear(animated: Bool) {
        tabBarController?.tabBar.hidden = false
    }
    
    func editMeme() {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        controller.currentImage = currentMeme.image
        controller.currentFont = UIFont(name: currentMeme.fontName, size: 40)
        controller.currentTopText = currentMeme.topText
        controller.currentBottomText = currentMeme.bottomText
        
        presentViewController(controller, animated: true, completion: nil)
    }
}
