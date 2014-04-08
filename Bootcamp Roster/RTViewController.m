//
//  RTViewController.m
//  Bootcamp Roster
//
//  Created by Ryo Tulman on 4/7/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import "RTViewController.h"
#import "RTDetailViewController.h"
#import "RTPerson.h"
#import "RTStudent.h"
#import "RTTeacher.h"

@interface RTViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *teachers;
@property (nonatomic, strong) NSMutableArray *students;
@property (nonatomic, strong) RTPerson *currentPerson;

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
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

    //set up sort button and add to nav bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                  target:self
                                                                                  action:@selector(sortButtonPressed)];
    //Apple standard method of reading in plist
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"Person Property List.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"Person Property List" ofType:@"plist"];
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML
                                        mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorDesc];
    if (!temp) {
        NSLog(@"Error reading plist: %@, format: %lu", errorDesc, format);
    }
    
    //get array of name strings
    NSArray *teacherNames = [NSMutableArray arrayWithArray:[temp objectForKey:@"Teacher"]];
    NSArray *studentNames = [NSMutableArray arrayWithArray:[temp objectForKey:@"Student"]];
    
    //create teacher array and objects
    _teachers = [NSMutableArray new];
    for (int i = 0; i < teacherNames.count; i++) {
        RTTeacher *newTeacher = [RTTeacher new];
        newTeacher.fullName = teacherNames[i];
        NSArray *nameArray = [newTeacher.fullName componentsSeparatedByString:@" "];
        newTeacher.firstName = nameArray[0];
        if (nameArray.count > 1) {
            newTeacher.lastName = nameArray[1];
        }
        newTeacher.type = kTeacher;
        [_teachers addObject:newTeacher];
    }
    //create student array and objects
    _students = [NSMutableArray new];
    for (int i = 0; i < studentNames.count; i++) {
        RTStudent *newStudent = [RTStudent new];
        newStudent.fullName = studentNames[i];
        NSArray *nameArray = [newStudent.fullName componentsSeparatedByString:@" "];
        newStudent.firstName = nameArray[0];
        if (nameArray.count > 1) {
            newStudent.lastName = nameArray[1];
        }
        newStudent.type = kStudent;
        [_students addObject:newStudent];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return peopleSectionType_count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case kStudentSection:
            return _students.count;
        default:
            return _teachers.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    RTPerson *person;
    switch (indexPath.section) {
        case kStudentSection:
            person = _students[indexPath.row];
            break;
        default:
            person = _teachers[indexPath.row];
            break;
    }
    cell.textLabel.text = person.fullName;
    cell.imageView.image = nil;
    if (person.image) {
        cell.imageView.layer.cornerRadius = 15;
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.imageView.image = person.image;
    }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case kStudentSection:
            return @"Students";
        default:
            return @"Teachers";
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    RTDetailViewController *detailViewController = [RTDetailViewController new];
    switch (indexPath.section) {
        case kStudentSection:
            _currentPerson = _students[indexPath.row];
            break;
        default:
            _currentPerson = _teachers[indexPath.row];
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
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Sort By First Name"]) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
        _students = [[_students sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
        _teachers = [[_teachers sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
        for (RTPerson *person in _students) {
            [person invertFullName:NO];
        }
        for (RTPerson *person in _teachers) {
            [person invertFullName:NO];
        }
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Sort By Last Name"]) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
        _students = [[_students sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
        _teachers = [[_teachers sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
        for (RTPerson *person in _students) {
            [person invertFullName:YES];
        }
        for (RTPerson *person in _teachers) {
            [person invertFullName:YES];
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
