//
//  MemeCollectionViewController.swift
//  Meme Me
//
//  Created by Matthew Young on 1/12/16.
//  Copyright © 2016 Matthew Young. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {
    var memes = {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .Plain, target: self, action: "newMeme")
        
        let space: CGFloat = 1.0 // Copied from Udacity, UIKit Fundamentals II, Build MemeMe v2.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes().count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let currentMeme = memes()[indexPath.row]
        cell.memeImageView.image = currentMeme.image
        cell.setText(currentMeme.topText, bottomText: currentMeme.bottomText, fontName: currentMeme.fontName)
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        controller.currentMeme = memes()[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func newMeme() {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        presentViewController(controller, animated: true, completion: nil)
    }
}