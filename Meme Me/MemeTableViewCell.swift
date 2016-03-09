//
//  MemeTableViewCell.swift
//  Meme Me
//
//  Created by Matthew Young on 1/12/16.
//  Copyright © 2016 Matthew Young. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    @IBOutlet weak var memeTextLabel: UILabel!
    @IBOutlet weak var memeTopTextLabel: UILabel!
    @IBOutlet weak var memeBottomTextLabel: UILabel!
    
    let memeTextAttributes: [String: AnyObject] = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSStrokeWidthAttributeName: NSNumber(float: -3.0)
    ]
    
    func setText(topText: String, bottomText: String, fontName: String) {
        memeTopTextLabel.font = UIFont(name: fontName, size: 20)
        memeBottomTextLabel.font = UIFont(name: fontName, size: 20)
        memeTopTextLabel.attributedText = NSAttributedString(string: topText, attributes: memeTextAttributes)
        memeBottomTextLabel.attributedText = NSAttributedString(string: bottomText, attributes: memeTextAttributes)
    }
    
}
