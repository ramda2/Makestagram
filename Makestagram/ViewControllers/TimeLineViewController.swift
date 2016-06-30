//
//  TimeLineViewController.swift
//  Makestagram
//
//  Created by ANGELIE RAMDIAL on 6/29/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
  class TimeLineViewController: UIViewController {
    var photoTakingHelper: PhotoTakingHelper?
    //create an instance of a PhotoTakingHelper that will display our popup.
    override func viewDidLoad() {
        super.viewDidLoad()
        //we are setting the TimelineViewController to be the delegate of the tabBarController.
        self.tabBarController?.delegate = self
    }
    
    func takePhoto() {
        // instantiate photo taking class, provide callback for when photo is selected
        photoTakingHelper = PhotoTakingHelper(viewController: self.tabBarController!) { (image: UIImage?) in
            // don't do anything, yet...
            print("received a callback")
        }
        //photoTakingHelper = PhotoTakingHelper(viewController: self.tabBarController!) { (image: UIImage?) in
            // don't do anything, yet...
    }
}

// MARK: Section 1
//Tab Bar Delegate
//use it to determine whether specific tabs should be selected, to perform actions after a tab is selected, or to perform actions before or after the user customizes the order of the tabs

//*******************************************************************************************
//Using this method the tab bar view controller asks its delegate whether or not it should present the view controller that belongs to the tab bar item that the user just tapped.
extension TimeLineViewController: UITabBarControllerDelegate {

    //shouldSelectViewController - Asks the delegate whether the specified view controller should be made active.
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if (viewController.isKindOfClass(PhotoViewController)) {
            //is PhotoViewController) {
            takePhoto()
            //return YES if the view controller’s tab should be selected or NO if the current tab should remain active.
            return false
        } else {
            return true
        }
    }
}
//*******************************************************************************************

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


