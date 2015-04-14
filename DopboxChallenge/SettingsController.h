//
//  SettingsController.h
//  DopboxIntegration
//
//  Created by Andres Socha on 4/13/15.
//  Copyright (c) 2015 AndreSocha. All rights reserved.
//

#import <Dropbox/Dropbox.h>
#import <UIKit/UIKit.h>

@interface SettingsController : UITableViewController
- (void)showDataForAccount:(DBAccount*)account fileSystem:(DBFilesystem*)filesystem;

@end
