//DONE RIGHT
//  AddPhotoVC.h
//  DopboxIntegration
//
//  Created by Andres Socha on 4/11/15.
//  Copyright (c) 2015 AndreSocha. All rights reserved.
//
#import <Dropbox/Dropbox.h>
#import <UIKit/UIKit.h>
#import "AccountController.h"

@interface AddPhotoVC : UIViewController <UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
- (id)initWithFile:(DBFile *)file;
@end
