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


@end
