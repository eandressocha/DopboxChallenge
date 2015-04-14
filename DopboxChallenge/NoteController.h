//
//  NoteController.h
//  DopboxIntegration
//
//  Created by Andres Socha on 4/13/15.
//  Copyright (c) 2015 AndreSocha. All rights reserved.
//

#import <Dropbox/Dropbox.h>

@interface NoteController : UIViewController

- (id)initWithFile:(DBFile *)file;

@end
