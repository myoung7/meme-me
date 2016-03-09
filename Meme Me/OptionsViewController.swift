//
//  OptionsViewController.swift
//  Meme Me
//
//  Created by Matthew Young on 1/9/16.
//  Copyright © 2016 Matthew Young. All rights reserved.
//

import Foundation
import UIKit

protocol TransferDataDelegate: class {
    func userDidChangeFont(index: Int, font: UIFont)
    func userDidChangeTextfieldYPosition(topRatio: CGFloat, bottomRatio: CGFloat)
}

class OptionsViewController: UIViewController {
    
    @IBOutlet weak var previewMemeView: UIView!
    
    @IBOutlet weak var fontSelectorStepper: UIStepper!
    
    @IBOutlet weak var topExampleTextLabel: UILabel!
    @IBOutlet weak var bottomExampleTextLabel: UILabel!
    @IBOutlet weak var fontNameLabel: UILabel!
    
    @IBOutlet weak var topTextHeightSlider: UISlider!
    @IBOutlet weak var bottomTextHeightSlider: UISlider!
    
    weak var delegate: TransferDataDelegate?
    
    var memeTextAttributes: [String: AnyObject] = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "Impact", size: 30)!,
        NSStrokeWidthAttributeName: NSNumber(float: -3.0)
    ]
    
    let arrayOfFonts = [
        UIFont(name: "Impact", size: 20)!,
        UIFont(name: "GillSans", size: 20)!,
        UIFont(name: "HelveticaNeue", size: 20)!
    ]
    
    let arrayOfFontNames = [
        "Impact",
        "Gill Sans",
        "Helvetica Neue"
    ]
    
    var topTextHeight = 0
    var bottomTextHeight = 0
    var newMemeTopTextYRatio: CGFloat = 0.0
    var newMemeBottomTextYRatio: CGFloat = 0.85
    
    var currentFontIndexValue = 0
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let memeAttributesTopText = NSMutableAttributedString(string: "TOP TEXT", attributes: memeTextAttributes)
        let memeAttributesBottomText = NSMutableAttributedString(string: "BOTTOM TEXT", attributes: memeTextAttributes)
        topExampleTextLabel.attributedText = memeAttributesTopText
        bottomExampleTextLabel.attributedText = memeAttributesBottomText
        
        setFontsForTextLabels(currentFontIndexValue)
        
        fontSelectorStepper.maximumValue = Double(arrayOfFonts.count) - 1.0
        fontSelectorStepper.minimumValue = 0.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        delegate?.userDidChangeFont(currentFontIndexValue, font: arrayOfFonts[currentFontIndexValue])
        delegate?.userDidChangeTextfieldYPosition(newMemeTopTextYRatio, bottomRatio: newMemeBottomTextYRatio)
    }
    
    @IBAction func backButton(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func topTextHeightSliderChanged(sender: UISlider) {
        let newValueY = CGFloat(50 + (-50 * sender.value))
        topExampleTextLabel.frame.origin.y = newValueY
        
        newMemeTopTextYRatio = newValueY / previewMemeView.frame.height
    }
    
    @IBAction func bottomTextHeightSliderChanged(sender: UISlider) {
        let newValueY = CGFloat(220 + (-50 * sender.value))
        bottomExampleTextLabel.frame.origin.y = newValueY
        
        newMemeBottomTextYRatio = newValueY / previewMemeView.frame.height
    }
    
    @IBAction func fontStepperChanged(sender: UIStepper) {
        setFontsForTextLabels(Int(sender.value))
        currentFontIndexValue = Int(sender.value)
    }
    
    func setFontsForTextLabels(index: Int) {
        fontNameLabel.font = arrayOfFonts[index]
        fontNameLabel.text = arrayOfFontNames[index]
        topExampleTextLabel.font = arrayOfFonts[index]
        bottomExampleTextLabel.font = arrayOfFonts[index]
    }
}
