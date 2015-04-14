//
//  AppDelegate.m
//  DopboxChallenge
//
//  Created by Andres Socha on 4/13/15.
//  Copyright (c) 2015 AndreSocha. All rights reserved.
//

#import "NotesSettingsController.h"
#import "AppDelegate.h"
#import <Dropbox/Dropbox.h>
#import "NotesFolderListController.h"

@interface AppDelegate ()

@property (nonatomic, retain) UINavigationController *rootController;
@property (nonatomic, retain) SettingsController *settingsController;

@end

@implementation AppDelegate

+ (AppDelegate *)sharedDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    DBAccountManager *accountManager =
    [[DBAccountManager alloc] initWithAppKey:@"bo9xkesukizkvmr" secret:@"48q8uyxo2tki5ki"];
    [DBAccountManager setSharedManager:accountManager];
    
    _settingsController = [[NotesSettingsController alloc] init];
    
    DBAccount *account = [accountManager.linkedAccounts objectAtIndex:0];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_settingsController];
    if (account) {
        DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
        NotesFolderListController *folderController =
        [[NotesFolderListController alloc] initWithFilesystem:filesystem root:[DBPath root]];
        [nav pushViewController:folderController animated:NO];
    }
    self.rootController = nav;
    
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    DBAccount *account = [[DBAccountManager sharedManager] handleOpenURL:url];
    if (account) {
        DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
        NotesFolderListController *folderController =
        [[NotesFolderListController alloc] initWithFilesystem:filesystem root:[DBPath root]];
        [self.rootController pushViewController:folderController animated:YES];
    }
    
    return YES;
}

@end
