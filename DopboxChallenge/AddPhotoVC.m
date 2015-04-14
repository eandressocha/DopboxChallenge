//DONE RIGHT
//  AddPhotoVC.m
//  DopboxIntegration
//
//  Created by Andres Socha on 4/11/15.
//  Copyright (c) 2015 AndreSocha. All rights reserved.
//
//
#import "NotesFolderListController.h"
#import "AddPhotoVC.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface AddPhotoVC () <UITextViewDelegate>

@property (nonatomic, retain)UIImageView *imagewindow;
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, retain) DBFile *file;
@property (nonatomic, assign) BOOL onlyDisplay;

@end

@implementation AddPhotoVC

- (id)initWithFile:(DBFile *)file {
    if (!(self = [super init])) return nil;
    
    _file = file;
    self.navigationItem.title = [_file.info.path name];
    if (_file.info.size<200) {
        _onlyDisplay = NO;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(didPressCamera)];
    }
    else{
        _onlyDisplay = YES;
    }
    
    return self;
}

#pragma mark - Controller lifecycle methods

- (void)unloadViews {
    self.imagewindow = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        self.imagewindow = [[UIImageView alloc]initWithFrame:self.view.bounds];
        self.imagewindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:self.imagewindow];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    __weak AddPhotoVC *weakSelf = self;
    [_file addObserver:self block:^() { [weakSelf reload]; }];
    [self.navigationController setToolbarHidden:YES];
    [self reload];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_file removeObserver:self];

    if (self.image && !_onlyDisplay) {
        [self saveChanges];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - image set and get

-(void) setImage:(UIImage *)image{
    self.imagewindow.image = image;
    [[NSFileManager defaultManager]removeItemAtURL:_imageURL error:NULL];
    self.imageURL = nil;
}
-(UIImage *)image{
    return self.imagewindow.image;
}

#pragma mark - camera related methods

+(BOOL)canAddPhoto{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if ([availableMediaTypes containsObject:(NSString *)kUTTypeImage]) {
            return YES;
        }
    }
    return NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(![[self class]canAddPhoto]){
        [self fatalAlert:@"Sorry, this device cannot add a photo."];
        self.navigationItem.leftBarButtonItem.enabled = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

#pragma mark - alerts methods

-(void)didPressCamera{
    UIImagePickerController *uiipc = [[UIImagePickerController alloc]init];
    uiipc.delegate = self;
    uiipc.mediaTypes = @[(NSString *)kUTTypeImage];
    uiipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    uiipc.allowsEditing = YES;
    [self presentViewController:uiipc animated:YES completion:NULL];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image) image = info[UIImagePickerControllerOriginalImage];
    self.image = image;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)saveChanges {
    NSData *imageData = UIImageJPEGRepresentation(self.image, 1.0);
    [_file writeData:imageData error:nil];
}

#pragma mark - alerts methods

-(void)fatalAlert:(NSString *)msg{
    [[[UIAlertView alloc]initWithTitle:@"Add Photo"
                               message:msg
                              delegate:self
                     cancelButtonTitle:nil
                     otherButtonTitles:@"OK", nil]show];
}

-(void)alert:(NSString *)msg{
    [[[UIAlertView alloc]initWithTitle:@"Add Photo"
                               message:msg
                              delegate:nil
                     cancelButtonTitle:nil
                     otherButtonTitles:@"OK", nil]show];
}

#pragma mark - private methods

- (void)reload {
    if (_onlyDisplay) {
        NSData *imageinfo = [_file readData:nil];
        UIImage *actpic = [UIImage imageWithData:imageinfo];
        _imagewindow.image =  actpic;
        self.imagewindow.hidden = NO;
    }
    else{
        self.imagewindow.hidden = NO;
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}
@end
