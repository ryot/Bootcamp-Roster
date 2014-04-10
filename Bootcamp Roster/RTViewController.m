//
//  RTViewController.m
//  Bootcamp Roster
//
//  Created by Ryo Tulman on 4/7/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import "RTViewController.h"
#import "RTDetailViewController.h"
#import "RTDataSourceController.h"
#import "RTPerson.h"
#import "RTStudent.h"
#import "RTTeacher.h"

@interface RTViewController () <UITableViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RTPerson *currentPerson;
@property (nonatomic, strong) RTDataSourceController *tableDataSource;
@property (nonatomic, strong) UIBarButtonItem *leftButton, *rightButton;

typedef NS_ENUM(NSInteger, peopleSectionType) {
    kTeacherSection,
    kStudentSection,
    peopleSectionType_count
};

@end

@implementation RTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Bootcamp Roster";
    
    //create and configure table view
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    _tableView.dataSource = [RTDataSourceController sharedDataSource];
    _tableDataSource = [RTDataSourceController sharedDataSource];

    [self.view addSubview:_tableView];
    
    //set up nav bar buttons
    _rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                  target:self
                                                                                  action:@selector(sortButtonPressed)];
    self.navigationItem.rightBarButtonItem = _rightButton;
    
    _leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(newPersonButtonPressed)];
    self.navigationItem.leftBarButtonItem = _leftButton;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    RTDetailViewController *detailViewController = [RTDetailViewController new];
    switch (indexPath.section) {
        case kStudentSection:
            _currentPerson = _tableDataSource.students[indexPath.row];
            break;
        default:
            _currentPerson = _tableDataSource.teachers[indexPath.row];
            break;
    }
    detailViewController.person = _currentPerson;
    detailViewController.title = _currentPerson.fullName;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

-(void)sortButtonPressed
{
    _rightButton.enabled = NO;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Sort People" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Sort By First Name", @"Sort By Last Name", nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}

-(void)newPersonButtonPressed
{
    _leftButton.enabled = NO;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add Person" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add Teacher", @"Add Student", nil];
    actionSheet.tag = 2;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1) {
        NSString *sortKey;
        if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Sort By First Name"]) {
            sortKey = @"firstName";
        } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Sort By Last Name"]) {
            sortKey = @"lastName";
        }
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:YES];
        _tableDataSource.students = [[_tableDataSource.students sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
        _tableDataSource.teachers = [[_tableDataSource.teachers sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
        NSMutableSet *allPeople = [NSMutableSet new];
        [allPeople addObjectsFromArray:_tableDataSource.students];
        [allPeople addObjectsFromArray:_tableDataSource.teachers];
        for (RTPerson *person in allPeople) {
            if ([sortKey isEqual:@"firstName"]) {
                person.fullNameInverted = NO;
            } else {
                person.fullNameInverted = YES;
            }
        }
        [_tableView reloadData];
        [[RTDataSourceController sharedDataSource] saveDocumentsDirectoryPlist];
        _rightButton.enabled = YES;
    } else if (actionSheet.tag == 2) {
        RTDetailViewController *detailViewController = [RTDetailViewController new];
        RTPerson *newPerson = [RTPerson new];
        if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Add Teacher"]) {
            newPerson = [RTTeacher new];
            newPerson.type = kTeacher;
            [_tableDataSource.teachers insertObject:newPerson atIndex:0];
        } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Add Student"]) {
            newPerson = [RTStudent new];
            newPerson.type = kStudent;
            [_tableDataSource.students insertObject:newPerson atIndex:0];
        }
        newPerson.imagePath = @"";
        newPerson.fullNameInverted = NO;
        detailViewController.person = newPerson;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _leftButton.enabled = YES;
    _rightButton.enabled = YES;
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
