//
//  RTViewController.m
//  Bootcamp Roster
//
//  Created by Ryo Tulman on 4/7/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import "RTViewController.h"
#import "RTPerson.h"
#import "RTStudent.h"
#import "RTTeacher.h"

@interface RTViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *teachers;
@property (nonatomic, strong) NSMutableArray *students;

typedef NS_ENUM(NSInteger, PersonType) {
    kTeacher,
    kStudent,
    personType_count
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
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    //get array of name strings
    NSArray *teacherNames = [NSMutableArray arrayWithArray:[temp objectForKey:@"Teacher"]];
    NSArray *studentNames = [NSMutableArray arrayWithArray:[temp objectForKey:@"Student"]];
    
    //create teacher array and objects
    _teachers = [NSMutableArray new];
    for (int i = 0; i < teacherNames.count; i++) {
        RTTeacher *newTeacher = [RTTeacher new];
        newTeacher.name = [teacherNames objectAtIndex:i];
        [_teachers addObject:newTeacher];
    }
    //create student array and objects
    _students = [NSMutableArray new];
    for (int i = 0; i < studentNames.count; i++) {
        RTStudent *newStudent = [RTStudent new];
        newStudent.name = [studentNames objectAtIndex:i];
        [_students addObject:newStudent];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return personType_count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case kStudent:
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
        case kStudent:
            person = _students[indexPath.row];
            break;
        default:
            person = _teachers[indexPath.row];
            break;
    }
    cell.textLabel.text = person.name;
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case kStudent:
            return @"Students";
        default:
            return @"Teachers";
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *detailViewController = [UIViewController new];
    detailViewController.view = [[UIView alloc] initWithFrame:self.view.frame];
    detailViewController.view.backgroundColor = [UIColor whiteColor];
    switch (indexPath.section) {
        case kStudent:
            detailViewController.title = [_students[indexPath.row] name];
            break;
        default:
            detailViewController.title = [_teachers[indexPath.row] name];
            break;
    }
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
