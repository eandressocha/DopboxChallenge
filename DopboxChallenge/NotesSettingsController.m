//
//  NotesSettingsController.m
//  DopboxIntegration
//
//  Created by Andres Socha on 4/13/15.
//  Copyright (c) 2015 AndreSocha. All rights reserved.
//

#import "NotesSettingsController.h"
#import "NotesFolderListController.h"

@implementation NotesSettingsController


- (void)showDataForAccount:(DBAccount*)account fileSystem:(DBFilesystem*)filesystem {
    NotesFolderListController *controller =
    [[NotesFolderListController alloc]
     initWithFilesystem:filesystem root:[DBPath root]];
    [self.navigationController pushViewController:controller animated:YES];
}


@end
