//
//  RTDataSource.m
//  Bootcamp Roster
//
//  Created by Ryo Tulman on 4/9/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import "RTDataSource.h"
#import "RTTeacher.h"
#import "RTStudent.h"

@implementation RTDataSource

typedef NS_ENUM(NSInteger, peopleSectionType) {
    kTeacherSection,
    kStudentSection,
    peopleSectionType_count
};

-(id)init {
    self = [super init];
    if (self) {
        //specify how to find plist in bundle
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Person Property List" ofType:@"plist"];
        //if plist exists, copy read-only bundle plist to writeable documents directory
        if ([RTDataSource movePlistToDocDirectory]) {
            //then create full path for new doc directory plist
            plistPath = [[RTDataSource applicationDocumentsDirectory] stringByAppendingPathComponent:@"Person Property List.plist"];
        }
        
        //create runtime dictionary from new doc directory plist
        NSDictionary *personDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        //get arrays of name strings from dictionary
        NSArray *teacherNames = [NSMutableArray arrayWithArray:personDict[@"Teacher"]];
        NSArray *studentNames = [NSMutableArray arrayWithArray:personDict[@"Student"]];
        
        //create teacher array, use name strings to make teacher objects
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
        //create student array, use name strings to make student objects
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

//gets auto-generated path string for documents directory
+(NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

//copies bundle plist to doc directory, keeping the same name
+(BOOL)movePlistToDocDirectory
{
    NSError *error;
    NSFileManager *myManager = [NSFileManager defaultManager];
    [myManager copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"Person Property List" ofType:@"plist"] toPath:[[RTDataSource applicationDocumentsDirectory] stringByAppendingString:@"Person Property List.plist"] error:&error];
    if (error) {
        NSLog(@"error: %@", error);
        return NO;
    } else {
        return YES;
    }
}


@end
