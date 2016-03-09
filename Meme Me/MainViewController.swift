//
//  ViewController.swift
//  Meme Me
//
//  Created by Matthew Young on 1/8/16.
//  Copyright © 2016 Matthew Young. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, TransferDataDelegate {

    @IBOutlet weak var memeView: UIView!
    
    @IBOutlet weak var topTextField: UITextField! // Tag = 3
    @IBOutlet weak var bottomTextField: UITextField! // Tag = 4
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    var topTextFieldPositionRatio: CGFloat = 0.0
    var bottomTextFieldPositionRatio: CGFloat = 0.85
    
    var topTextFieldInitialPositionRatio: CGFloat = 0.0
    var bottomTextFieldInitialPositionRatio: CGFloat = 0.85
    
    
    let memeTextAttributes: [String: AnyObject] = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "Impact", size: 40)!,
        NSStrokeWidthAttributeName: NSNumber(float: -3.0)
    ]
    
    var keyboardIsShowing = false
    var okayToMoveKeyboard = false
    var currentFontIndexValue = 0
    var currentFont = UIFont(name: "Impact", size: 40)

    var activeTextField: UITextField?
    var memedImage: UIImage?
    var currentImage: UIImage?
    var currentTopText: String?
    var currentBottomText: String?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        setFontForTextFields()
        userDidChangeTextfieldYPosition(topTextFieldPositionRatio, bottomRatio: bottomTextFieldPositionRatio)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        subscribeToKeyboardAndOrientationNotifications()
        if let currentImage = currentImage {
            mainImageView.image = currentImage
            mainImageView.contentMode = .ScaleAspectFit
            topTextField.text = currentTopText
            bottomTextField.text = currentBottomText
            shareButton.enabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if mainImageView.image == nil {
            shareButton.enabled = false
        }
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        setFontForTextFields()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardAndOrientationNotifications()
        currentImage = nil
    }

    @IBAction func selectImageFromAlbumOrCamera(sender: UIBarButtonItem) {
        let controller = UIImagePickerController()
        controller.delegate = self
        
        switch sender.tag {
        case 0: controller.sourceType = .PhotoLibrary // Album button is pressed
        case 1: controller.sourceType = .Camera // Camera button is pressed
        default: break
        }
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Delete Confirmation", message: "Are you sure you want to delete this meme?", preferredStyle: .Alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive) { (action) -> Void in
            self.topTextField.text = "TOP"
            self.bottomTextField.text = "BOTTOM"
            self.mainImageView.image = nil
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
            self.topTextFieldPositionRatio = self.topTextFieldInitialPositionRatio
            self.bottomTextFieldPositionRatio = self.bottomTextFieldInitialPositionRatio
            self.userDidChangeTextfieldYPosition(self.topTextFieldPositionRatio, bottomRatio: self.bottomTextFieldPositionRatio)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func activityButtonPressed(sender: UIBarButtonItem) { //Opens Activity view
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        //Saves meme if action is taken; doesn't save if cancelled.
        activityController.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.saveMeme(memedImage)
                print("Saved!")
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                print("Not saved!")
            }
        }
        
        unsubscribeFromKeyboardAndOrientationNotifications()
        
        activityController.popoverPresentationController?.barButtonItem = sender
        presentViewController(activityController, animated: true, completion: nil)
            
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        activeTextField = textField
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            mainImageView.image = image
        }
        
        mainImageView.contentMode = .ScaleAspectFit
        shareButton.enabled = true
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func subscribeToKeyboardAndOrientationNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationDidChange:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardAndOrientationNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let activeTextField = activeTextField {
            if activeTextField.tag == 4 {
                if !keyboardIsShowing {
                    view.frame.origin.y -= getKeyboardHeight(notification)
                    keyboardIsShowing = true
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let activeTextField = activeTextField {
            if activeTextField.tag == 4 || keyboardIsShowing {
                view.frame.origin.y += getKeyboardHeight(notification)
                keyboardIsShowing = false
            }
        }
    }
    
    func orientationDidChange(notification: NSNotification) {
        if UIDevice().orientation != .Portrait {
            if bottomTextFieldPositionRatio > 0.8 {
                bottomTextFieldPositionRatio = 0.8
            }
        }
        userDidChangeTextfieldYPosition(topTextFieldPositionRatio, bottomRatio: bottomTextFieldPositionRatio)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func setFontForTextFields() {
        topTextField.font = currentFont
        bottomTextField.font = currentFont
    }
    
    func userDidChangeFont(index: Int, font: UIFont) {
        currentFontIndexValue = index
        currentFont = UIFont(name: font.fontName, size: 40)
    }
    
    func saveMeme(memedImage: UIImage) {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: mainImageView.image!, memedImage: memedImage, fontName: currentFont!.fontName)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        topToolbar.hidden = true
        bottomToolbar.hidden = true
        
        // Render view to an image (Original code from Udacity, but modified by myself)
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(memeView.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        topToolbar.hidden = false
        bottomToolbar.hidden = false
        
        return memedImage
    }
    
    func userDidChangeTextfieldYPosition(topRatio: CGFloat, bottomRatio: CGFloat) {
        topTextField.frame.origin.y = mainImageView.frame.height * topRatio
        bottomTextField.frame.origin.y = mainImageView.frame.height * bottomRatio
        
        topTextFieldPositionRatio = topRatio
        bottomTextFieldPositionRatio = bottomRatio
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "optionsSegue" {
            let controller = segue.destinationViewController as! OptionsViewController
            controller.currentFontIndexValue = currentFontIndexValue
            controller.delegate = self
        }
    }
    
    

}

