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

+(id)sharedDataSource {
    static RTDataSourceController *sharedData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedData = [[self alloc] init];
    });
    return sharedData;
}

-(id)init {
    self = [super init];
    if (self) {
        //FIRST LAUNCH if writeable documents directory plist does not exist, copy from bundle
        if (![RTDataSourceController checkIfPlistInDocDirectory]) {
            [RTDataSourceController movePlistToDocDirectory];
        }
        //use doc directory plist path before moving forward
        NSString *plistPath = [[RTDataSourceController applicationDocumentsDirectory] stringByAppendingPathComponent:@"people.plist"];

        //create runtime dictionary from new doc directory plist
        NSDictionary *personDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        //get arrays of name strings from dictionary
        NSArray *teacherArray = [NSMutableArray arrayWithArray:personDict[@"Teacher"]];
        NSArray *studentArray = [NSMutableArray arrayWithArray:personDict[@"Student"]];
        
        //create teacher array, use name strings to make teacher objects
        _teachers = [NSMutableArray new];
        for (NSDictionary *dict in teacherArray) {//int i = 0; i < teacherArray.count; i++) {
            RTTeacher *newTeacher = [RTTeacher new];
            newTeacher.imagePath = dict[@"imagePath"];
            if (newTeacher.imagePath) {
                newTeacher.image = [UIImage imageWithContentsOfFile:newTeacher.imagePath];
            }
            newTeacher.firstName = dict[@"firstName"];
            newTeacher.lastName = dict[@"lastName"];
            newTeacher.twitter = dict[@"twitter"];
            newTeacher.github = dict[@"github"];
            CGFloat r = [dict[@"r"] floatValue];
            CGFloat g = [dict[@"g"] floatValue];
            CGFloat b = [dict[@"b"] floatValue];
            if (r == 0.0 && g == 0.0 && b == 0.0) {
                newTeacher.color = [UIColor whiteColor];
            } else {
                newTeacher.color = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
            }
            [_teachers addObject:newTeacher];
        }
        //create student array, use name strings to make student objects
        _students = [NSMutableArray new];
        for (NSDictionary *dict in studentArray) {
            RTStudent *newStudent = [RTStudent new];
            newStudent.imagePath = dict[@"imagePath"];
            if (newStudent.imagePath) {
                newStudent.image = [UIImage imageWithContentsOfFile:newStudent.imagePath];
            }
            newStudent.firstName = dict[@"firstName"];
            newStudent.lastName = dict[@"lastName"];
            newStudent.twitter = dict[@"twitter"];
            newStudent.github = dict[@"github"];
            CGFloat r = [dict[@"r"] floatValue];
            CGFloat g = [dict[@"g"] floatValue];
            CGFloat b = [dict[@"b"] floatValue];
            if (r == 0.0 && g == 0.0 && b == 0.0) {
                newStudent.color = [UIColor whiteColor];
            } else {
                newStudent.color = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
            }
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
    cell.backgroundColor = person.color;
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
        CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
        [thisTeacher.color getRed:&red green:&green blue:&blue alpha:&alpha];
        NSDictionary *thisTeacherDict = @{@"firstName": thisTeacher.firstName, @"lastName": thisTeacher.lastName, @"imagePath": thisTeacher.imagePath, @"twitter": thisTeacher.twitter, @"github": thisTeacher.github, @"r": [NSNumber numberWithFloat:red], @"g": [NSNumber numberWithFloat:green], @"b": [NSNumber numberWithFloat:blue]};
        [teacherSaveDict addObject:thisTeacherDict];
    }
    NSMutableArray *studentSaveDict = [NSMutableArray new];
    for (RTPerson *thisStudent in _students) {
        CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
        [thisStudent.color getRed:&red green:&green blue:&blue alpha:&alpha];
        NSDictionary *thisStudentDict = @{@"firstName": thisStudent.firstName, @"lastName": thisStudent.lastName, @"imagePath": thisStudent.imagePath, @"twitter": thisStudent.twitter, @"github": thisStudent.github, @"r": [NSNumber numberWithFloat:red], @"g": [NSNumber numberWithFloat:green], @"b": [NSNumber numberWithFloat:blue]};
        [studentSaveDict addObject:thisStudentDict];
    }
    NSDictionary *saveDict = @{@"Teacher": teacherSaveDict, @"Student": studentSaveDict};
    
    NSError *removeError, *copyError, *cleanupError;
    NSFileManager *myFileManager = [NSFileManager defaultManager];
    [saveDict writeToFile:[[RTDataSourceController applicationDocumentsDirectory] stringByAppendingPathComponent:@"new-people.plist"] atomically:YES];
    
    [myFileManager removeItemAtPath:[[RTDataSourceController applicationDocumentsDirectory] stringByAppendingPathComponent:@"people.plist"] error:&removeError];
    [myFileManager copyItemAtPath:[[RTDataSourceController applicationDocumentsDirectory] stringByAppendingPathComponent:@"new-people.plist"] toPath:[[RTDataSourceController applicationDocumentsDirectory] stringByAppendingPathComponent:@"people.plist"] error:&copyError];
    [myFileManager removeItemAtPath:[[RTDataSourceController applicationDocumentsDirectory] stringByAppendingPathComponent:@"new-people.plist"] error:&cleanupError];
}

+(void)saveImageForPersonToDocumentsDirectory:(RTPerson *)thisPerson
{
    NSString *imageName = [NSString stringWithFormat:@"%@.png", [thisPerson.firstName stringByAppendingString:thisPerson.lastName]];
    NSString *savePath = [[RTDataSourceController applicationDocumentsDirectory] stringByAppendingPathComponent:imageName];
    NSData *data = UIImagePNGRepresentation(thisPerson.image);
    [data writeToFile:savePath atomically:YES];
    thisPerson.imagePath = savePath;
}

//gets auto-generated path string for documents directory
+(NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+(BOOL)checkIfPlistInDocDirectory
{
    NSFileManager *myManager = [NSFileManager defaultManager];
    return [myManager fileExistsAtPath:[[RTDataSourceController applicationDocumentsDirectory] stringByAppendingPathComponent:@"people.plist"]];
}

//copies bundle plist to doc directory, keeping the same name
+(BOOL)movePlistToDocDirectory
{
    NSError *error;
    NSFileManager *myManager = [NSFileManager defaultManager];
    [myManager copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"people" ofType:@"plist"] toPath:[[RTDataSourceController applicationDocumentsDirectory] stringByAppendingPathComponent:@"people.plist"] error:&error];
    if (error) {
        NSLog(@"error: %@", error);
        return NO;
    } else {
        return YES;
    }
}

@end
