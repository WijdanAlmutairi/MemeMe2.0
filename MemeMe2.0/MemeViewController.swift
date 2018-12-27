//
//  MemeViewController.swift
//  MemeMe1.0
//
//  Created by MAC on 15/11/2018.
//  Copyright © 2018 Dan. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    var topTextFieldState : Bool = false
    var bottomTextFieldState : Bool = false
    
    //dectionary to set the default attributes of the TextFields
    let memeTextAttributes:[NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.0]
    
    //MARK:- View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Disable the camera for non camera devices and the share button
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = false
        
        configureMemeTextField(textField: topText, text: "Top")
        configureMemeTextField(textField: bottomText, text: "Bottom")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //Function that style the bottom and top TextFields
    func configureMemeTextField(textField: UITextField, text: String) {
        textField.text = text
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    
    //MARK:- Image Picker Function
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imagePickerView.image = image
        shareButton.isEnabled = true
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    //set the ImagePickerController
    func pickAnImage(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK:- photo library function
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickAnImage(sourceType: .photoLibrary)
    }
    
    //MARK:- camera function
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImage(sourceType: .camera)
    }
    
    //MARK:- TextField Delegate Functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if topTextFieldState == false && textField == topText {
            textField.text = ""
            topTextFieldState = true
        } else if bottomTextFieldState == false && textField == bottomText {
            textField.text = ""
            bottomTextFieldState = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:- keyboard notifications functions
    @objc func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK:- keyboard functions
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomText.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y = 0
    }
    
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    //MARK:- create Meme object functions
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        toolBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        toolBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        
        return memedImage
    }
    
    func save(){
        // Create the meme
        let meme = Meme(topTextString: topText.text!, bottomTextString: bottomText.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    //MARK:- share functions
    @IBAction func shareAnImage(_ sender: Any) {
        let image: UIImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
        controller.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            
            if completed {
                self.save()
            }
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        
        navigationController?.popToRootViewController(animated: true)
    }
    
}



