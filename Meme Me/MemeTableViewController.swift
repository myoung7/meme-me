//
//  MemeTableViewController.swift
//  Meme Me
//
//  Created by Matthew Young on 1/12/16.
//  Copyright © 2016 Matthew Young. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController {
    var memes = {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .Plain, target: self, action: "newMeme")
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes().count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell", forIndexPath: indexPath) as! MemeTableViewCell
        let currentMeme = memes()[indexPath.row]
        cell.memeImageView.image = currentMeme.image
        cell.memeTextLabel.text = "\(currentMeme.topText)...\(currentMeme.bottomText)"
        cell.setText(currentMeme.topText, bottomText: currentMeme.bottomText, fontName: currentMeme.fontName)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        var memeArray = memes()
        if editingStyle == .Delete {
            print("Deleted meme at \(indexPath.row)")
            memeArray.removeAtIndex(indexPath.row)
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes = memeArray
            tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        let currentMeme = memes()[indexPath.row]
        controller.currentMeme = currentMeme
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func newMeme() {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        presentViewController(controller, animated: true, completion: nil)
    }
}
