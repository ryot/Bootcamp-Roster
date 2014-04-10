//
//  RTDataSource.h
//  Bootcamp Roster
//
//  Created by Ryo Tulman on 4/9/14.
//  Copyright (c) 2014 Ryo Tulman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTPerson.h"

@interface RTDataSourceController : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *teachers, *students;

+(id)sharedDataSource;
+(NSString *)applicationDocumentsDirectory;
+(void)saveImageForPersonToDocumentsDirectory:(RTPerson *)person;
-(void)saveDocumentsDirectoryPlist;

@end
