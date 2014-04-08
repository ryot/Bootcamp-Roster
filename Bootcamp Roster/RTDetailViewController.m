//
//  RTDetailViewController.m
//  Bootcamp Roster
//
//  Created by Ryo Tulman on 4/8/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import "RTDetailViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface RTDetailViewController () <UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation RTDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 55, 300, 300)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView];
    if (_person.image) {
        _imageView.image = _person.image;
    }
    //set up camera button and add to nav bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                                                  target:self
                                                                                  action:@selector(photoButtonPressed)];
}

- (void)photoButtonPressed
{
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:@"Photos" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Photo" otherButtonTitles:@"Camera", @"Photo Library", nil];
    } else {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:@"Photos" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Photo" otherButtonTitles:@"Photo Library", nil];
    }
    [_actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Camera"]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Photo Library"]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Delete Photo"]) {
        _imageView.image = nil;
        _person.image = nil;
        return;
    } else {
        return;
    }
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _imageView.image = info[UIImagePickerControllerEditedImage];
    _person.image = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:^{
        ALAssetsLibrary *library = [ALAssetsLibrary new];
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera && ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized || [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized)) {
            [library writeImageToSavedPhotosAlbum:_person.image.CGImage orientation:ALAssetOrientationUp completionBlock:^(NSURL *assetURL, NSError *error) {
                if (error) {
                    NSLog(@"Error Saving Image: %@", error.localizedDescription);
                }
            }];
        } else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera && ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied || [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusRestricted)) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot Save Photo" message:@"Photo Library save permission not granted." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
