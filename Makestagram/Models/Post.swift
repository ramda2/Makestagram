//
//  Post.swift
//  Makestagram
//
//  Created by ANGELIE RAMDIAL on 6/30/16.
//  Copyright © 2016 Make School. All rights reserved.
//
import Foundation
import Parse
import Bond

//1 Custom Parse Class
class Post : PFObject, PFSubclassing {
    // Observable wrapper allows us to listen for changes to the wrapped value.
    var image: Observable<UIImage?> = Observable(nil)
    var photoUploadTask: UIBackgroundTaskIdentifier?
    
    // 2 define each property that you want to access on this Parse class.
    @NSManaged var imageFile: PFFile?
    @NSManaged var user: PFUser?
    
    
    //MARK: PFSubclassing Protocol
    
    // 3 creates a connection between the ParSse class and your Swift class.
    static func parseClassName() -> String {
        return "Post"
    }
    
    // 4
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    
    func uploadPost() {
        // if image is not null
        // guard is used to unwrap optionals,
            // We used guard to exit the uploadPost() method early if creating the imageData
            //or imageFile fail for some reason.
        if let image = image.value {
            // converting image to file and specifying image quality
            // We turn the UIImage into an NSData instance because the PFFile class needs an NSData argument for its initializer.
            guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {return}
            // The higher the number, the higher the quality but the larger the size as well.
            guard let imageFile = PFFile(name: "jpeg.jpg", data: imageData) else {return}
            // allow access for the user thats logged in
            user = PFUser.currentUser()
            self.imageFile = imageFile
            // we don't need be informed when the upload completes, so we pass nil to the method.
            // saveInBackgroundWithBlock(nil)
            
            //**************************************CREATE A BACKGROUND JOB**************************************
            // The API requires us to provide an expirationHandler in the form of a closure. 
            // That closure runs when the extra time that iOS permitted us has expired.
            // In case the additional background time wasn't sufficient, we are required to cancel our task!
            photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            }
            
            //This block gets called as soon as the image upload is finished && background task is completed
            saveInBackgroundWithBlock() { (success: Bool, error: NSError?) in
            UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            //****************************************************************************************************
            }
        }
    }
    
    func downloadImage() {
        // if image is not downloaded yet, get it
        // start the donwload if image.value is nil to avoid downloading images multiple times.
        if (image.value == nil) {
            // Instead of using getData we are using getDataInBackgroundWithBlock - that way we are no longer blocking the main thread!
            imageFile?.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
                if let data = data {
                    let image = UIImage(data: data, scale:1.0)!
                    //  we are now using the .value property, because image is an Observable.
                    self.image.value = image
                }
            }
        }
    }
    
}
