//
//  RTDataSource.m
//  Bootcamp Roster
//
//  Created by Ryo Tulman on 4/9/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import "RTDataSourceController.h"
#import "RTTeacher.h"
#import "RTStudent.h"

@implementation RTDataSourceController

typedef NS_ENUM(NSInteger, peopleSectionType) {
    kTeacherSection,
    kStudentSection,
    peopleSectionType_count
};

-(id)init {
    self = [super init];
    if (self) {
        //specify full path for doc directory plist
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Person Property List" ofType:@"plist"];
        //if writeable documents directory plist does not exist, copy one from bundle
        if ([RTDataSourceController movePlistToDocDirectory]) {
            //use that doc directory plist path before moving forward
            plistPath = [[RTDataSourceController applicationDocumentsDirectory] stringByAppendingPathComponent:@"Person Property List.plist"];
            NSLog(@"does this happen");
        }
        //create runtime dictionary from new doc directory plist
        NSDictionary *personDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        //get arrays of name strings from dictionary
        NSArray *teacherArray = [NSMutableArray arrayWithArray:personDict[@"Teacher"]];
        NSArray *studentArray = [NSMutableArray arrayWithArray:personDict[@"Student"]];
        
        //create teacher array, use name strings to make teacher objects
        _teachers = [NSMutableArray new];
        for (int i = 0; i < teacherArray.count; i++) {
            RTTeacher *newTeacher = [RTTeacher new];
            newTeacher.fullNameInverted = NO;
            newTeacher.imagePath = teacherArray[i][@"imagePath"];
            NSString *fullNameString = teacherArray[i][@"fullName"];
            NSArray *nameArray = [fullNameString componentsSeparatedByString:@" "];
            newTeacher.firstName = nameArray[0];
            if (nameArray.count > 1) {
                newTeacher.lastName = nameArray[1];
            }
            newTeacher.type = kTeacher;
            [_teachers addObject:newTeacher];
        }
        //create student array, use name strings to make student objects
        _students = [NSMutableArray new];
        for (int i = 0; i < studentArray.count; i++) {
            RTStudent *newStudent = [RTStudent new];
            newStudent.fullNameInverted = NO;
            newStudent.imagePath = studentArray[i][@"imagePath"];
            NSString *fullNameString = studentArray[i][@"fullName"];
            NSArray *nameArray = [fullNameString componentsSeparatedByString:@" "];
            newStudent.firstName = nameArray[0];
            if (nameArray.count > 1) {
                newStudent.lastName = nameArray[1];
            }
            newStudent.type = kStudent;
            [_students addObject:newStudent];
        }
    }
    return self;
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

-(void)saveDocumentsDirectoryPlist
{
    //assemble appropriately formatted dictionary
    NSMutableArray *teacherSaveDict = [NSMutableArray new];
    for (RTPerson *thisTeacher in _teachers) {
        NSDictionary *thisTeacherDict = @{@"fullName": thisTeacher.fullName, @"imagePath": thisTeacher.imagePath};
        [teacherSaveDict addObject:thisTeacherDict];
    }
    NSMutableArray *studentSaveDict = [NSMutableArray new];
    for (RTPerson *thisStudent in _students) {
        NSDictionary *thisStudentDict = @{@"fullName": thisStudent.fullName, @"imagePath": thisStudent.imagePath};
        [studentSaveDict addObject:thisStudentDict];
    }
    NSDictionary *saveDict = @{@"Teacher": teacherSaveDict, @"Student": studentSaveDict};
    
    //arrange urls and save dictionary as plist
    NSURL *resultURL;
    NSURL *url = [NSURL URLWithString:[[RTDataSourceController applicationDocumentsDirectory] stringByAppendingString:@"Person Property List.plist"]];
    NSURL *tempURL = [NSURL URLWithString:[[RTDataSourceController applicationDocumentsDirectory] stringByAppendingString:@"NEW Person Property List.plist"]];
    [saveDict writeToURL:tempURL atomically:YES];
    NSFileManager *myManager = [NSFileManager defaultManager];
    [myManager replaceItemAtURL:url
                  withItemAtURL:tempURL
                 backupItemName:nil
                        options:NSFileManagerItemReplacementUsingNewMetadataOnly
               resultingItemURL:&resultURL
                          error:nil];
}

//gets auto-generated path string for documents directory
+(NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+(BOOL)checkIfPlistInDocDirectory
{
    NSFileManager *myManager = [NSFileManager defaultManager];
    return [myManager fileExistsAtPath:[[RTDataSourceController applicationDocumentsDirectory] stringByAppendingString:@"Person Property List.plist"]];
}

//copies bundle plist to doc directory, keeping the same name
+(BOOL)movePlistToDocDirectory
{
    if (![RTDataSourceController checkIfPlistInDocDirectory]) {
        return NO;
    }
    NSError *error;
    NSFileManager *myManager = [NSFileManager defaultManager];
    [myManager copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"Person Property List" ofType:@"plist"] toPath:[[RTDataSourceController applicationDocumentsDirectory] stringByAppendingString:@"Person Property List.plist"] error:&error];
    if (error) {
        NSLog(@"error: %@", error);
        return NO;
    } else {
        return YES;
    }
}

@end
