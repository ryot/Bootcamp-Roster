//
//  RTDetailViewController.m
//  Bootcamp Roster
//
//  Created by Ryo Tulman on 4/8/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import "RTDetailViewController.h"
#import "RTDataSourceController.h"
#import "RTScrollView.h"

@interface RTDetailViewController () <UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *firstNameLabel, *lastNameLabel, *twitterLabel, *githubLabel;
@property (nonatomic, strong) UITextField *firstNameField, *lastNameField, *twitterField, *githubField;
@property (nonatomic, strong) UIScrollView *myScrollView;
@property (nonatomic) CGPoint contentOffset;
@property (nonatomic, strong) UISlider *redSlider, *greenSlider, *blueSlider;

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
    _myScrollView = [[RTScrollView alloc] initWithFrame:self.view.frame];
    _myScrollView.delegate = self;
    [self.view addSubview:_myScrollView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEdited) name:UITextFieldTextDidChangeNotification object:nil];
    if (_person.color) {
        _myScrollView.backgroundColor = _person.color;
    } else {
        _myScrollView.backgroundColor = [UIColor whiteColor];
    }
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(55, 78, 210, 210)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_myScrollView addSubview:_imageView];
    if (_person.image) {
        _imageView.image = _person.image;
    }
    _imageView.layer.borderWidth = 3.0;
    _imageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    _imageView.clipsToBounds = YES;
    
    _firstNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 8, 100, 20)];
    _lastNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 34, 100, 20)];
    _firstNameLabel.text = @"First Name: ";
    _lastNameLabel.text = @"Last Name: ";
    _firstNameLabel.font = [UIFont boldSystemFontOfSize:_firstNameLabel.font.pointSize];
    _lastNameLabel.font = [UIFont boldSystemFontOfSize:_lastNameLabel.font.pointSize];
    [_myScrollView addSubview:_firstNameLabel];
    [_myScrollView addSubview:_lastNameLabel];
    
    _firstNameField = [[UITextField alloc] initWithFrame:CGRectMake(120, 6, 160, 25)];
    _lastNameField = [[UITextField alloc] initWithFrame:CGRectMake(120, 36, 160, 25)];
    _firstNameField.tag = 1;
    _lastNameField.tag = 2;
    _firstNameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    _firstNameField.leftViewMode = UITextFieldViewModeAlways;
    _lastNameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    _lastNameField.leftViewMode = UITextFieldViewModeAlways;
    _firstNameField.text = _person.firstName;
    _lastNameField.text = _person.lastName;
    _firstNameField.backgroundColor = [UIColor colorWithRed:0.884 green:1.000 blue:0.775 alpha:1.000];
    _lastNameField.backgroundColor = [UIColor colorWithRed:0.884 green:1.000 blue:0.775 alpha:1.000];
    _firstNameField.layer.borderWidth = 1.0;
    _lastNameField.layer.borderWidth = 1.0;
    _firstNameField.layer.borderColor = [UIColor blueColor].CGColor;
    _lastNameField.layer.borderColor = [UIColor blueColor].CGColor;
    _firstNameField.delegate = self;
    _lastNameField.delegate = self;
    [_myScrollView addSubview:_firstNameField];
    [_myScrollView addSubview:_lastNameField];
    
    
    _twitterLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 305, 100, 20)];
    _githubLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 335, 100, 20)];
    _twitterLabel.text = @"Twitter: ";
    _githubLabel.text = @"Github: ";
    _twitterLabel.font = [UIFont boldSystemFontOfSize:_twitterLabel.font.pointSize];
    _githubLabel.font = [UIFont boldSystemFontOfSize:_githubLabel.font.pointSize];
    [_myScrollView addSubview:_twitterLabel];
    [_myScrollView addSubview:_githubLabel];
    
    _twitterField = [[UITextField alloc] initWithFrame:CGRectMake(120, 303, 160, 25)];
    _githubField = [[UITextField alloc] initWithFrame:CGRectMake(120, 333, 160, 25)];
    _twitterField.tag = 3;
    _githubField.tag = 4;
    _twitterField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    _twitterField.leftViewMode = UITextFieldViewModeAlways;
    _githubField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    _githubField.leftViewMode = UITextFieldViewModeAlways;
    _twitterField.text = _person.twitter;
    _githubField.text = _person.github;
    _twitterField.backgroundColor = [UIColor colorWithRed:0.797 green:0.919 blue:1.000 alpha:1.000];
    _githubField.backgroundColor = [UIColor colorWithRed:0.797 green:0.919 blue:1.000 alpha:1.000];
    _twitterField.layer.borderWidth = 1.0;
    _githubField.layer.borderWidth = 1.0;
    _twitterField.layer.borderColor = [UIColor blueColor].CGColor;
    _githubField.layer.borderColor = [UIColor blueColor].CGColor;
    _twitterField.delegate = self;
    _githubField.delegate = self;
    [_myScrollView addSubview:_twitterField];
    [_myScrollView addSubview:_githubField];
    
    _redSlider = [[UISlider alloc] initWithFrame:CGRectMake(5, 365, 100, 20)];
    _greenSlider = [[UISlider alloc] initWithFrame:CGRectMake(110, 365, 100, 20)];
    _blueSlider = [[UISlider alloc] initWithFrame:CGRectMake(215, 365, 100, 20)];
    _redSlider.minimumTrackTintColor = [UIColor redColor];
    _greenSlider.minimumTrackTintColor = [UIColor greenColor];
    _blueSlider.minimumTrackTintColor = [UIColor blueColor];
    CGFloat red = 1.0, green = 1.0, blue = 1.0, alpha = 1.0;
    [_person.color getRed:&red green:&green blue:&blue alpha:&alpha];
    _redSlider.value = red;
    _greenSlider.value = green;
    _blueSlider.value = blue;
    [_redSlider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    [_greenSlider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    [_blueSlider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    [_myScrollView addSubview:_redSlider];
    [_myScrollView addSubview:_greenSlider];
    [_myScrollView addSubview:_blueSlider];

    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAction
                                                                                           target:self
                                                                                           action:@selector(sharePhoto)];
    self.navigationController.toolbarHidden = NO;
    self.toolbarItems = @[shareButton];

    //set up camera button and add to nav bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                                                  target:self
                                                                                  action:@selector(photoButtonPressed)];
}
-(void)viewDidAppear:(BOOL)animated {
    _contentOffset = _myScrollView.contentOffset;
}

- (void)photoButtonPressed
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:@"Photos" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Photo" otherButtonTitles:@"Camera", @"Photo Library", nil];
    } else {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:@"Photos" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Photo" otherButtonTitles:@"Photo Library", nil];
    }
    [_actionSheet showInView:_myScrollView];
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
        NSFileManager *myManager = [NSFileManager defaultManager];
        if ([_person.imagePath length] > 0 && [myManager fileExistsAtPath:[[RTDataSourceController applicationDocumentsDirectory] stringByAppendingPathComponent:@"people.plist"]]) {
            NSError *error;
            [myManager removeItemAtPath:_person.imagePath error:&error];
            if (error){
                NSLog(@"%@", error);
            } else {
                _person.imagePath = @"";
            }
        }
        return;
    } else {
        return;
    }
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _imageView.image = info[UIImagePickerControllerEditedImage];
    _person.image = info[UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:^{
        [RTDataSourceController saveImageForPersonToDocumentsDirectory:_person];
    }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag > 2) {
        [_myScrollView setContentOffset:CGPointMake(0, 130) animated:YES];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag > 2) {
        [_myScrollView setContentOffset:_contentOffset animated:YES];
    }
}

-(void)textFieldEdited {
    _person.firstName = _firstNameField.text;
    _person.lastName = _lastNameField.text;
    _person.twitter = _twitterField.text;
    _person.github = _githubField.text;
    self.title = _person.fullName;
}

-(void)sharePhoto
{
    if (_person.image) {
        UIActivityViewController *sharePhotoVC = [[UIActivityViewController alloc] initWithActivityItems:@[_person.image] applicationActivities:nil];
        [self presentViewController:sharePhotoVC animated:YES completion:nil];
    }
}

-(void)sliderValueChanged
{
    CGFloat red = _redSlider.value;
    CGFloat green = _greenSlider.value;
    CGFloat blue = _blueSlider.value;
    _person.color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    _myScrollView.backgroundColor = _person.color;
}

-(void)viewWillDisappear:(BOOL)animated
{
    _person.firstName = _firstNameField.text;
    _person.lastName = _lastNameField.text;
    _person.twitter = _twitterField.text;
    _person.github = _githubField.text;
    [[RTDataSourceController sharedDataSource] saveDocumentsDirectoryPlist];
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
