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
    
    _tableDataSource = [RTDataSourceController new];
    _tableView.dataSource = _tableDataSource;
    
    [self.view addSubview:_tableView];
    
    //set up sort button and add to nav bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                  target:self
                                                                                  action:@selector(sortButtonPressed)];
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
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Sort People" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Sort By First Name", @"Sort By Last Name", nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *sortKey;
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Sort By First Name"]) {
        sortKey = @"firstName";
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Sort By Last Name"]) {
        sortKey = @"lastName";
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:YES];
    _tableDataSource.students = [[_tableDataSource.students sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
    _tableDataSource.teachers = [[_tableDataSource.teachers sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
    NSMutableArray *allPeople = [NSMutableArray new];
    [allPeople addObjectsFromArray:_tableDataSource.students];
    [allPeople addObjectsFromArray:_tableDataSource.teachers];
    for (RTPerson *person in allPeople) {
        if ([sortKey isEqual: @"firstName"]) {
            person.fullNameInverted = NO;
        } else {
            person.fullNameInverted = YES;
        }
    }
    [_tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
