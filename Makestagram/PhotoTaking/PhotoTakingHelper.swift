//
//  PhotoTakingHelper.swift
//  Makestagram
//
//  Created by ANGELIE RAMDIAL on 6/29/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
//help us choose an image by calling the image picker

//here creating a type alias//optional bc user can cancel when selecting a photo
//sending a photo that the user selected as a parameter
typealias PhotoTakingHelperCallback = UIImage? -> Void

//class selects an image and uploads it to parse
class PhotoTakingHelper : NSObject {
    
    // View controller on which AlertViewController and UIImagePickerController are presented
    weak var viewController: UIViewController!
    var callback: PhotoTakingHelperCallback
    var imagePickerController: UIImagePickerController?
    
    init(viewController: UIViewController, callback: PhotoTakingHelperCallback) {
        self.viewController = viewController
        self.callback = callback
        
        super.init()
        
        showPhotoSourceSelection()
    }
    
    func showPhotoSourceSelection() {
        // Allow user to choose between photo library and camera
        
        //The UIAlertController can be used to present different types of popups.
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)

        
        // Only show camera option if rear camera is available
        if (UIImagePickerController.isCameraDeviceAvailable(.Rear)) {
            let cameraAction = UIAlertAction(title: "Photo from Camera", style: .Default) { (action) in
                //methods in closures require "self"
                 self.showImagePickerController(.Camera)
            }
            alertController.addAction(cameraAction)
        }
        viewController.presentViewController(alertController, animated: true, completion: nil)
        
        let photoLibraryAction = UIAlertAction(title: "Photo from Library", style: .Default) { (dogAction) in
            self.showImagePickerController(.PhotoLibrary)
            print("SELECTED Library")
        }
        alertController.addAction(photoLibraryAction)
    }
    
    //Depending on the sourceType the UIImagePickerController will activate the camera and display a photo taking overlay - or will show the user's photo library
    func showImagePickerController(sourceType: UIImagePickerControllerSourceType) {
        imagePickerController = UIImagePickerController()
        imagePickerController!.sourceType = sourceType
        imagePickerController!.delegate = self
        
        self.viewController.presentViewController(imagePickerController!, animated: true, completion: nil)
    }
    
}

extension PhotoTakingHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        viewController.dismissViewControllerAnimated(false, completion: nil)
        //send selected image
        callback(image)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}