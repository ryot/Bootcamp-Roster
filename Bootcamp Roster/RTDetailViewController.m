//
//  RTDetailViewController.m
//  Bootcamp Roster
//
//  Created by Ryo Tulman on 4/8/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import "RTDetailViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface RTDetailViewController () <UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *firstNameLabel, *lastNameLabel;
@property (nonatomic, strong) UITextField *firstNameField, *lastNameField;

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
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 90, 300, 300)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView];
    if (_person.image) {
        _imageView.image = _person.image;
    }
    _firstNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 74, 100, 20)];
    _lastNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 106, 100, 20)];
    _firstNameLabel.text = @"First Name: ";
    _lastNameLabel.text = @"Last Name: ";
    _firstNameLabel.font = [UIFont boldSystemFontOfSize:_firstNameLabel.font.pointSize];
    _lastNameLabel.font = [UIFont boldSystemFontOfSize:_lastNameLabel.font.pointSize];
    [self.view addSubview:_firstNameLabel];
    [self.view addSubview:_lastNameLabel];
    
    _firstNameField = [[UITextField alloc] initWithFrame:CGRectMake(120, 72, 160, 25)];
    _lastNameField = [[UITextField alloc] initWithFrame:CGRectMake(120, 104, 160, 25)];
    _firstNameField.tag = 1;
    _lastNameField.tag = 2;
    _firstNameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    _firstNameField.leftViewMode = UITextFieldViewModeAlways;
    _lastNameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    _lastNameField.leftViewMode = UITextFieldViewModeAlways;
    _firstNameField.text = _person.firstName;
    _lastNameField.text = _person.lastName;
    _firstNameField.backgroundColor = [UIColor yellowColor];
    _lastNameField.backgroundColor = [UIColor yellowColor];
    _firstNameField.layer.borderWidth = 1.0;
    _lastNameField.layer.borderWidth = 1.0;
    _firstNameField.layer.borderColor = [UIColor blueColor].CGColor;
    _lastNameField.layer.borderColor = [UIColor blueColor].CGColor;
    _firstNameField.delegate = self;
    _lastNameField.delegate = self;
    [self.view addSubview:_firstNameField];
    [self.view addSubview:_lastNameField];

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
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot Save Photo" message:@"Photo Library save permission not granted." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    switch (textField.tag) {
        case 1:
            _person.firstName = textField.text;
            break;
            
        case 2:
            _person.lastName = textField.text;
            break;
    }
    self.title = _person.fullName;
    return YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    _person.firstName = _firstNameField.text;
    _person.lastName = _lastNameField.text;
}

//challenge item - dismiss keyboard on 'return' key press
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
